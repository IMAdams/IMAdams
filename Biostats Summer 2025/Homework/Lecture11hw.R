# Ian Adams
# homework with lecture 11
# Ian Adams 

# Using the “IRF4_alleles_melanoma.csv” file in the module for today’s lecture, compile and upload your html files to canvas after you answer the following questions.

# What are the allele and genotype frequencies (proportions) of the IRF4 SNP for individuals with and without melanoma (1=melanoma, 0=control)?


irf4 <- read.csv("IRF4_alleles_melanoma.csv");
head(irf4)
library(dplyr);
library(tidyr);
library(tibble);

irf4_genotypes <- irf4 %>%
  rowwise() %>% 
  mutate(genotype = paste(sort(c(allele1, allele2)), collapse = "")) %>%
  ungroup()

# Allele Frequencies
allele_freq_by_melanoma <- irf4_genotypes %>%
pivot_longer(cols = c(allele1, allele2), names_to = "allele_col", values_to = "allele") %>%
  group_by(melanoma, allele) %>%
  summarise(
    count = n(),
    .groups = 'drop' 
  ) %>%
  group_by(melanoma) %>%
  mutate(
    total_alleles = sum(count),
    frequency = count / total_alleles
  )

print(allele_freq_by_melanoma)

# Genotype Frequencies
genotype_freq_by_melanoma <- irf4_genotypes %>%
  group_by(melanoma, genotype) %>%
  summarise(
    count = n(),
    .groups = 'drop'
  ) %>%
  group_by(melanoma) %>%
  mutate(
    total_individuals = sum(count),
    frequency = count / total_individuals
  )

print(genotype_freq_by_melanoma)

# Test for HWE in the controls. Would an allelic test of significance for the genetic association between the IRF4 SNP and melanoma status be appropriate?

library(HardyWeinberg)
controls_data <- irf4_genotypes %>%
  filter(melanoma == 0)
all_alleles <- unique(c(irf4_genotypes$allele1, irf4_genotypes$allele2))
sorted_alleles <- sort(all_alleles)

possible_genotypes <- c(
  paste0(sorted_alleles[1], sorted_alleles[1]),
  paste0(sorted_alleles[1], sorted_alleles[2]),
  paste0(sorted_alleles[2], sorted_alleles[2])
)

observed_genotypes_controls <- controls_data %>%
  count(genotype, name = "count") %>%
  tidyr::complete(genotype = possible_genotypes, fill = list(count = 0)) %>%
  pull(count)
names(observed_genotypes_controls) <- possible_genotypes

allele_counts_controls <- controls_data %>%
  pivot_longer(cols = c(allele1, allele2), names_to = "allele_col", values_to = "allele") %>%
  count(allele) %>%
  arrange(c(count))

if (nrow(allele_counts_controls) >= 2) {
  minor_allele <- allele_counts_controls$allele[1]
  major_allele <- allele_counts_controls$allele[2]
}

genotype_counts_hwe_order <- c(
  controls_data %>% filter(genotype == paste0(major_allele, major_allele)) %>% nrow(),
  controls_data %>% filter(genotype == paste0(minor_allele, major_allele) | genotype == paste0(major_allele, minor_allele)) %>% nrow(),
  controls_data %>% filter(genotype == paste0(minor_allele, minor_allele)) %>% nrow()
)

names(genotype_counts_hwe_order) <- c(
  paste0(major_allele, major_allele),
  paste0(minor_allele, major_allele), 
  paste0(minor_allele, minor_allele)
)

hwe_test_result <- HWChisq(genotype_counts_hwe_order,cc = TRUE)

print(hwe_test_result)

cat("\nThe chi-square p-value is greater than 0.05, which indicates the controls are in Hardy-Weinberg equilibrium")

# Perform a chi-square test of the association between the IRF4 alleles and melanoma status.

alleles_long <- irf4_genotypes %>%
  pivot_longer(
    cols = c(allele1, allele2),
    names_to = "allele_position",
    values_to = "allele"
  )

allele_counts_by_melanoma <- alleles_long %>%
  group_by(melanoma, allele) %>%
  summarise(count = n(), .groups = 'drop')

unique_alleles <- sort(unique(allele_counts_by_melanoma$allele))

contingency_table <- allele_counts_by_melanoma %>%
  pivot_wider(
    names_from = allele,
    values_from = count,
    values_fill = 0
  ) %>%
  column_to_rownames(var = "melanoma")

contingency_table_matrix <- as.matrix(contingency_table[, unique_alleles])

chi_sq_result <- chisq.test(contingency_table_matrix, correct = FALSE)

print(chi_sq_result)

# Perform a logistic regression analysis of the association between the IRF4 alleles and melanoma status (report the odds ratio with its 95% CI along with the p-value).

irf4_genotypes$melanoma <- factor(irf4_genotypes$melanoma, levels = c(0, 1))

all_alleles_counts <- irf4_genotypes %>%
  pivot_longer(cols = c(allele1, allele2), names_to = "allele_pos", values_to = "allele_val") %>%
  count(allele_val) %>%
  arrange(n)

T_allele <- all_alleles_counts$allele_val[1]
C_allele <- all_alleles_counts$allele_val[2]

irf4_allelic <- irf4_genotypes %>%
  mutate(
    T_allelic = case_when(
      allele1 == T_allele | allele2 == T_allele ~ 1,
      allele1 != T_allele & allele2 != T_allele ~ 0
    ),
    C_allelic = case_when(
      allele1 == C_allele | allele2 == C_allele ~ 1,
      allele1 != C_allele & allele2 != C_allele ~ 0
    )
  )


allelic_model <- glm(melanoma ~ T_allelic + C_allelic, data = irf4_allelic, family = binomial(link = "logit"))

print(summary(allelic_model))

allelic_or_ci <- tidy(allelic_model, conf.int = TRUE, exponentiate = TRUE) %>%
  filter(term == "minor_allele_count")

allelic_OR <- exp(coef(allelic_model))
allelic_CI <- exp(confint(allelic_model))
print(allelic_OR)
print(allelic_CI)

# Perform a logistic regression analysis of the association between the IRF4 genotypes and melanoma status (report the odds ratios with its 95% CI along with the p-value).

reference_genotype <- paste0(major_allele, major_allele)

irf4_genotypes$genotype_factor <- factor(irf4_genotypes$genotype)

all_possible_genotypes <- c(
  paste0(major_allele, major_allele),
  paste0(minor_allele, major_allele),
  paste0(minor_allele, minor_allele)
)

irf4_genotypes$genotype_factor <- factor(irf4_genotypes$genotype,
  levels = all_possible_genotypes[order(all_possible_genotypes)])

irf4_genotypes$genotype_factor <- relevel(irf4_genotypes$genotype_factor, ref = reference_genotype)

genotypic_model <- glm(melanoma ~ genotype_factor, data = irf4_genotypes, family = binomial(link = "logit"))

print(summary(genotypic_model))

genotypic_or_ci <- tidy(genotypic_model, conf.int = TRUE, exponentiate = TRUE) %>% filter(term != "(Intercept)")

print(genotypic_or_ci)

# Perform a logistic regression analysis of the association between the number of IRF4 T alleles carried by each individual and melanoma status using the genotype-level data.

irf4_genotypes <- irf4 %>%  rowwise() %>%
  mutate(genotype = paste(sort(c(allele1, allele2)), collapse = "")) %>%
  ungroup()

irf4_genotypes$melanoma <- factor(irf4_genotypes$melanoma, levels = c(0, 1), labels = c("Control", "Case"))

irf4_data_for_T_allele_count <- irf4_genotypes %>%
  mutate(
    T_allele_count = case_when( allele1 == "T" & allele2 == "T" ~ 2, (allele1 == "T" & allele2 != "T") | (allele1 != "T" & allele2 == "T") ~ 1, TRUE ~ 0)
  )

print(head(irf4_data_for_T_allele_count))

print(table(irf4_data_for_T_allele_count$T_allele_count, irf4_data_for_T_allele_count$melanoma))

logistic_model_T_allele <- glm(melanoma ~ T_allele_count, data = irf4_data_for_T_allele_count, family = binomial(link = "logit"))
print(summary(logistic_model_T_allele))

or_ci_T_allele <- tidy(logistic_model_T_allele, conf.int = TRUE, exponentiate = TRUE) %>% filter(term == "T_allele_count")

print(or_ci_T_allele)


# Interpret the odds ratio and compare it to the odds ratio from question 5.

cat("\nThe odds ratio and 95% CI for T allele count and Melanoma status is 1.32(1.18,1,47. From question 5, the odds ratio for having the T allele and melanoma was 1.21(1.05, 1.41). These two analyses are similar, but the first one is a multiple regression model that looks at having either allele, instead of the count of the minor allele only. It does not consider the zygosity of the allele. ")
