# load libs
library(rhdf5)
library(dplyr)
library(ggplot2)
library(ggpubr)
library(rstatix)
library(tidyr)
library(purrr)
library(plotly)

# set up ggplot2 global aesthetic

my_global_theme <- theme_pubr() +
  theme(
    plot.title = element_text(size = 20, face = "bold", hjust = 0.5, vjust = 0.8), 
    plot.subtitle = element_text(size = 16, face = "bold", hjust = 0.5, vjust = 0.8),
    axis.title = element_text(size = 18, face = "bold", vjust = 0.1),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 18, face = "bold"),
    legend.text = element_text(size = 18),
    strip.text = element_text(size = 18, face = "bold"),
    axis.line = element_line(size = 0.6, color = "black"),
    panel.grid.major = element_line(size = 0.4, color = "lightgray"),
    panel.grid.minor = element_line(size = 0.2, color = "lightgray"),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background = element_rect(fill = "white", color = NA)
  )
theme_set(my_global_theme)

base_dir <- "/Users/ianadams/Documents/IMAdams/Biostats Summer 2025/data/"
h5_files <- list(
  "Exp1_Small" = paste0(base_dir, "CHO_Exp1_small13.h5"),
  "Exp1_Large" = paste0(base_dir, "CHO_Exp1_large13.h5"),
  "Exp2_Small" = paste0(base_dir, "CHO_Exp2_small20.h5"),
  "Exp2_Large" = paste0(base_dir, "CHO_Exp2_large20.h5"),
  "Exp3_Small" = paste0(base_dir, "CHO_Exp3_small14.h5"),
  "Exp3_Large" = paste0(base_dir, "CHO_Exp3_large14.h5")
)

# Dataset_X in Exp1_small corresponds to matched-cell data from Dataset_X in  Exp_1Large
head(h5ls(h5_files$Exp1_Small))
head(h5ls(h5_files$Exp1_Large))

# function to deal with the h5 data and convert it into a dataframe
extract_cell_data <- function(file_path, experiment_name, group_name) {
  h5_info <- h5ls(file_path)

  cell_group_names <- h5_info %>%
    filter(group == "/" & otype == "H5I_GROUP") %>% # Ensure it's a group
    pull(name) %>%
    unique()

  cell_data_list <- list()

  for (cell_h5_group_name in cell_group_names) {
    sqd_path <- paste0("/", cell_h5_group_name, "/SortedSquaredDisp")
    data_exists <- sqd_path %in% paste0(h5_info$group, "/", h5_info$name)
    if (data_exists) {
      sqd_raw_data <- h5read(file_path, sqd_path)

      median_sqd_cell <- median(as.vector(sqd_raw_data), na.rm = TRUE)

      cell_data_list[[cell_h5_group_name]] <- data.frame(
        Experiment = experiment_name,
        Group = group_name,
        Cell_H5_GroupName = cell_h5_group_name,
        Cell_TrueID_for_Pairing = cell_h5_group_name,
        sqd_Summary = median_sqd_cell
      )
    } else {
      warning(paste("Missing sqd for cell group", cell_h5_group_name, "in file", file_path))
    }
  }
  return(bind_rows(cell_data_list))
}

all_raw_data_from_h5 <- bind_rows(
  extract_cell_data(h5_files$Exp1_Small, "Experiment 1", "Small"),
  extract_cell_data(h5_files$Exp1_Large, "Experiment 1", "Large"),
  extract_cell_data(h5_files$Exp2_Small, "Experiment 2", "Small"),
  extract_cell_data(h5_files$Exp2_Large, "Experiment 2", "Large"),
  extract_cell_data(h5_files$Exp3_Small, "Experiment 3", "Small"),
  extract_cell_data(h5_files$Exp3_Large, "Experiment 3", "Large")
) %>%
  mutate(
    Experiment = factor(Experiment, levels = paste("Experiment", 1:3)),
    Group = factor(Group, levels = c("Small", "Large"))
  )

str(all_raw_data_from_h5)
head(all_raw_data_from_h5)

# Restructure for Paired Analysis
paired_data_summary <- all_raw_data_from_h5 %>%
  pivot_wider(
    id_cols = c(Experiment, Cell_TrueID_for_Pairing), # pairing ID
    names_from = Group,
    values_from = sqd_Summary
  ) %>%
  filter(!is.na(Small) & !is.na(Large)) %>%
  mutate(CellID_Global_for_Plot = paste0(Experiment, "_", Cell_TrueID_for_Pairing))

str(paired_data_summary)
head(paired_data_summary)

# convert to a long format suitable for ggplot's paired lines
all_data_long_for_plots_clean <- paired_data_summary %>%
  pivot_longer(
    cols = c(Small, Large),
    names_to = "Group",
    values_to = "sqd_Summary"
  ) %>%
  mutate(Group = factor(Group, levels = c("Small", "Large")))

str(all_data_long_for_plots_clean)
head(all_data_long_for_plots_clean)

wilcoxon_ci_results_pool <- wilcox.test(
  x = paired_data_summary$Large,
  y = paired_data_summary$Small,
  paired = TRUE,
  conf.int = TRUE,      # Request confidence interval
  conf.level = 0.95,    # Set confidence level (e.g., 95%)
)
print(wilcoxon_ci_results_pool)
# Wilcoxon test
wilcoxon_results_pool <- all_data_long_for_plots_clean %>% # easier format for plotting
  wilcox_test(sqd_Summary ~ Group, paired = TRUE) %>%
  add_significance("p") %>%
  add_xy_position(x = "Group") 

  # print(wilcoxon_results_pool)

median_iqr_summary <- all_data_long_for_plots_clean %>%
  group_by(Group) %>%
  get_summary_stats(sqd_Summary, type = "median_iqr") 

print(median_iqr_summary)
# Boxplot with Wilcoxon statistic
paired_boxplot_pool <- ggplot(all_data_long_for_plots_clean, aes(x = Group, y = sqd_Summary, fill = Group)) +
  geom_boxplot(outlier.shape = NA, fill = NA, color = "black", width = 0.3) +
  geom_line(aes(group = CellID_Global_for_Plot), color = "gray", alpha = 0.6) +
  geom_point(aes(color = Group), size = 1.5, alpha = 0.8) +
  labs(
    title = expression("Square Displacements (" ~ r^2 ~ ") per Cell:"),
    subtitle = "Small vs. Large Localizations pooled from three independent experiments",
    x = expression(PSF ~ sigma),
    y = expression(log10(r^2)), # "Log10(median r^2 Value/cell)"
    fill = "Group",
    color = "Group"
  ) +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  stat_pvalue_manual(
    wilcoxon_results_pool,
    label = "p.signif",
    y.position = max(all_data_long_for_plots_clean$sqd_Summary) * 1.1,
    tip.length = 0.01
  ) +
  scale_y_log10() +
  theme(legend.position = "none")

print(paired_boxplot_pool)

# Save as a PNG
# ggsave("./plots/paired_boxplot_pool.png", plot = paired_boxplot_pool, width = 8, height = 6, units = "in", dpi = 300)

# Wilcoxon test, if considering each experiment as a separate factor
wilcoxon_results <- all_data_long_for_plots_clean %>%
  group_by(Experiment) %>%
  wilcox_test(sqd_Summary ~ Group, paired = TRUE) %>%
  add_significance("p") %>%
  add_xy_position(x = "Group")

print(wilcoxon_results)
# Boxplot of each experiment with Wilcoxon statistic
paired_boxplot <- ggplot(all_data_long_for_plots_clean, aes(x = Group, y = sqd_Summary, fill = Group)) +
  geom_boxplot(outlier.shape = NA, fill = NA, color = "black", width = 0.3) +
  geom_line(aes(group = CellID_Global_for_Plot), color = "gray", alpha = 0.6) +
  geom_point(aes(color = Group), size = 1.5, alpha = 0.8) +
  facet_wrap(~Experiment, ncol = 3) +
  labs(
    title = expression("Square Displacements (" ~ r^2 ~ ") per Cell:"),
    subtitle = "Small vs. Large Localizations in three independent experiments",
    x = expression(PSF ~ sigma),
    y = expression(log10(r^2)), # "Log10(median r^2 Value/cell)"
    fill = "Group",
    color = "Group"
  ) +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  stat_pvalue_manual(
    wilcoxon_results,
    label = "p.signif",
    y.position = max(all_data_long_for_plots_clean$sqd_Summary) * 1.1,
    tip.length = 0.01
  ) +
  scale_y_log10() +
  theme(legend.position = "none")

print(paired_boxplot)

# Save as a PNG
# ggsave("./plots/paired_boxplot.png", plot = paired_boxplot, width = 8, height = 6, units = "in", dpi = 300)


# Overall K-S Test (Small vs Large, all experiments pooled)
small_data_pooled <- all_data_long_for_plots_clean %>%
  filter(Group == "Small") %>%
  pull(sqd_Summary)

large_data_pooled <- all_data_long_for_plots_clean %>%
  filter(Group == "Large") %>%
  pull(sqd_Summary)

# Perform the two-sample Kolmogorov-Smirnov test
ks_test_overall <- ks.test(small_data_pooled, large_data_pooled, alternative = "two.sided")

print(ks_test_overall)

# p-value formatting function
format_p_value_for_plot <- function(p_value, accuracy = 0.001) {
  if (is.na(p_value)) {
    return("NA")
  }
  if (p_value < accuracy) {
    return(paste0("p < ", formatC(accuracy, format = "f", digits = nchar(sub(".*\\.", "", accuracy)))))
  } else {
    return(paste0("p = ", formatC(p_value, format = "f", digits = nchar(sub(".*\\.", "", accuracy)))))
  }
}
# Plotting the Overall K-S Test Result (All Experiments Pooled)
ecdf_KS <- ggplot(all_data_long_for_plots_clean, aes(x = sqd_Summary, color = Group)) +
  stat_ecdf(geom = "step", size = 1) +
  labs(
    title = "Empirical Cumulative Distribution Function",
    subtitle = expression("for" ~ r^2 ~ " in 3 experiments"),
    x = expression("median" ~ r^2),
    y = "Cumulative Probability",
    color = expression(PSF ~ sigma~"Group")
  ) +
  scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  annotate("text",
    x = 0.02,
    y = 0.8,
    label = paste0(
      "D = ", round(ks_test_overall$statistic, 3),
      "\n", format_p_value_for_plot(ks_test_overall$p.value, accuracy = 0.001)
    ),
    color = "black", size = 8
  ) +
  scale_x_log10() +
  theme(legend.position = c(0.8, 0.2), plot.title = element_text(size = 18, face = "bold", hjust = 0.5, vjust = 0.8))

print(ecdf_KS)

# ggsave("./plots/ecdf_KS.png", plot = ecdf_KS, width = 8, height = 6, units = "in", dpi = 300)


# Density Plot
overall_density_plot <- ggplot(all_data_long_for_plots_clean, aes(x = sqd_Summary, fill = Group)) +
  geom_density(alpha = 0.6) +
  labs(
    title = expression("Density plot of" ~ r^2 ~ " in 3 experiments"),
    x = expression(log10 ~ "median" ~ r^2),
    y = "Probability density",
    fill = expression(PSF ~ sigma ~ "Group")
  ) +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  scale_x_log10() +
  theme(legend.position = c(0.75, .75))

print(overall_density_plot)
# ggsave("./plots/density_plot.png", plot = overall_density_plot, width = 8, height = 6, units = "in", dpi = 300)



faceted_density_plot <- ggplot(all_data_long_for_plots_clean, aes(x = sqd_Summary, fill = Group)) +
  geom_density(alpha = 0.6) +
  facet_wrap(~Experiment, scales = "free_y", ncol = 3) +
  labs(
    title = expression("Density plot of" ~ r^2 ~ "separated by experiment"),
    x = expression(log10 ~ "median" ~ r^2),
    y = "Probability density",
    fill = expression(PSF ~ sigma ~ "Group")
  ) +
  scale_fill_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  scale_x_log10()

print(faceted_density_plot)
# ggsave("./plots/faceted_density_plot.png", plot = faceted_density_plot, width = 8, height = 6, units = "in", dpi = 300)
# faceted_density_html <- ggplotly(faceted_density_plot, width = 900, height = 600)%>% suppressWarnings()
# print(faceted_density_html)

library(stats) # For shapiro.test

# Normality tests
small_data_pooled <- all_data_long_for_plots_clean %>%
  filter(Group == "Small") %>%
  pull(sqd_Summary)

shapiro_small_pooled <- shapiro.test(small_data_pooled)

print(shapiro_small_pooled)

large_data_pooled <- all_data_long_for_plots_clean %>%
  filter(Group == "Large") %>%
  pull(sqd_Summary)

shapiro_large_pooled <- shapiro.test(large_data_pooled)


print(shapiro_large_pooled)

overall_qq_plot <- ggplot(all_data_long_for_plots_clean, aes(sample = sqd_Summary, color = Group)) +
  geom_qq(size = 1.5, alpha = 0.8) +
  geom_qq_line(linetype = "dashed", color = "red") +
  facet_wrap(~Group, ncol = 2, scales = "free") +
  labs(
    title = expression("Q-Q Plot of median" ~ r^2 ~ "from three experiments"),
    x = "Theoretical Quantiles (Normal)",
    y = expression("Sample Quantiles (" ~ r^2 ~ ")"),
    color = expression(PSF ~ sigma ~ "Group")
  ) +
  scale_color_manual(values = c("Small" = "darkblue", "Large" = "lightblue")) +
  annotate("text",
    x = 0.02,
    y = 0.8,
    label = paste0(
      "small PSFs:", expression(p < 0.0001),
      "\n", "large PSFs:", expression(p < 0.0001)
    ),
    color = "black", size = 8
  ) +
  theme(plot.title = element_text(hjust = 0.5), legend.position = "none")

print(overall_qq_plot)
# ggsave("./plots/QQ_plot.png", plot = overall_qq_plot, width = 8, height = 6, units = "in", dpi = 300)

