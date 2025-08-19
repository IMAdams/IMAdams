
# R lab lecture 9
# Ian Adams 15 July 2025
library(datarium)
head(selfesteem )
# Question 1: Did self-esteem improve over time by diet?
# Data source: selfesteem: The dataset contains 10 individuals’ self-esteem score at three time points during a specific diet
# Methods should include One factor repeated measure ANOVA time effect, Greenhouse-Geisser or Huynh-Feldt correction for sphericity and pairwise comparisons

library(tidyverse)
library(ggpubr)
library(rstatix)

selfesteem <- selfesteem %>%
  gather(key = "time", value = "score", t1, t2, t3) %>%
  convert_as_factor(id, time)
head(selfesteem)
# summary stats
selfesteem %>%
group_by(time) %>%
get_summary_stats(score, type = "mean_sd")
bxp <- ggboxplot(selfesteem, x = "time", y = "score", add = "point")
bxp
ggqqplot(selfesteem, "score", facet.by = "time")
score.aov <- anova_test(data = selfesteem, dv = score, wid = id, within = time)
score.aov

# pairwise comparisons
pwc <- selfesteem %>%
  pairwise_t_test(
    score ~ time, paired = TRUE,
    p.adjust.method = "bonferroni"
    )
pwc
pwc <- pwc %>% add_xy_position(x = "time")
bxp +stat_pvalue_manual(pwc)

# Question 2: An experiment was conducted to look at treatment for depression. Two groups of patients (1: control / 2: treatment) have been followed at four different times (0: pre-test, 1: one month post-test, 3: 3 months follow-up and 6: 6 months follow-up). The dependent variable is a depression score.
# Data source: depression
# Methods should include data summary and visualization, checks for normality, Two factor repeated measure ANOVA, Greenhouse-Geisser or Huynh-Feldt correction for sphericity and pairwise comparison. Don’t forget to give a conclusion

head(depression)
depression <- depression %>%
  gather(key = "time", value = "score", t0, t1, t2, t3) %>%
  convert_as_factor(id, time)
head(depression)
# summary stats
depression %>%
group_by(treatment,time) %>%
get_summary_stats(score, type = "mean_sd")
bxp <- ggboxplot(depression, x = "time", y = "score", color="treatment",add = "point")
bxp
ggqqplot(depression, "score", facet.by = c("treatment","time"))
# two-factor-repeated measures anova
score.aov2 <- anova_test(data = depression, dv = score, wid = id, within = time, between = treatment)
score.aov2 
# normality test
depression %>%
group_by(treatment,time) %>%
shapiro_test(score)
# pairwise comparisons
pwc <- depression %>%
  pairwise_t_test(
    score ~ time, paired = TRUE,
    p.adjust.method = "bonferroni"
    )
pwc


# Effect of treatment at each timepoint
one.way <- depression %>%
  group_by(time) %>%
  anova_test(dv = score, wid = id, between = treatment) %>%
  get_anova_table() %>%
  adjust_pvalue(method = "bonferroni")
one.way


# in conclusion, there is a significant (p < 0.05) effect of treatment at t1,t2, and t3.

