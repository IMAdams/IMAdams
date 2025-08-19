# Ian Adams
# Lecture 12 lab activity
# 22 July 2025
# 1. Comment on the distribution of the viral load (RNA_IU_ml)
library(tidyverse);
library(readxl);
library(ggpubr);
library(rstatix);

hcvdata12 = read_excel("Hcv_data.xlsx")
print("data retrieved from https://datadryad.org/stash/dataset/doi:10.5061/dryad.0q524")

head(hcvdata12)

hcvdata12$genoHCV=factor(hcvdata12$genoHCV)

head(hcvdata12)

ggqqplot(data=subset(hcvdata12, !is.na(RNA_IU_ml)), "RNA_IU_ml", facet.by = 
"genoHCV")

cat("QQ plots of viral load grouped by genotype show diverge from the reference line, especialy on the right side.")

ggdensity(data=subset(hcvdata12, !is.na(RNA_IU_ml)), "RNA_IU_ml", facet.by = "genoHCV")+ scale_x_log10()

cat("Plotting the density function of the viral load data with a log transformation allows us to see the distribution. Even with the transform, the distribtions appear skewed")

# KW test
RNA_IU_ml_kw <- hcvdata12 %>% kruskal_test(RNA_IU_ml ~ genoHCV)
RNA_IU_ml_kw

# pairwise comparisons
RNA_IU_ml_pwc <- hcvdata12 %>% 
  dunn_test(RNA_IU_ml ~ genoHCV, p.adjust.method = "bonferroni") 
RNA_IU_ml_pwc

RNA_IU_ml_pwc <- RNA_IU_ml_pwc %>% add_xy_position(x = "genoHCV")
ggboxplot(data=subset(hcvdata12, !is.na(RNA_IU_ml)), "genoHCV", "RNA_IU_ml") +
  stat_pvalue_manual(RNA_IU_ml_pwc, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(RNA_IU_ml_kw, detailed = TRUE),
    caption = get_pwc_label(RNA_IU_ml_pwc)
  )  + geom_jitter()
# 5. Submit R html report to canvas




