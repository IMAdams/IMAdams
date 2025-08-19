# lecture 13
hcvdata <- read.csv("Hcv_data_lab.csv")
summary(hcvdata)
head(hcvdata)
hcvdata$genoHCV=factor(hcvdata$genoHCV)
hcvdata$stage=cut(hcvdata$TE_value,breaks=c(0,7.0,17.1,100),lables=c('no fibrosis','fibrosis','cirrhosis'))
head(hcvdata)
hcvdata$status = ifelse(hcvdata$stage=='cirrhosis',1.0, 0.0)
summary(hcvdata)
ggqqplot(hcvdata, "TE_value", facet.by = "genoHCV")
# non-parametric Kruskal-Wallis
tev_kw <- hcvdata %>% kruskal_test(TE_value ~ genoHCV)
tev_kw
# Pairwise comparisons
pwc <- hcvdata %>% 
  dunn_test(TE_value ~ genoHCV, p.adjust.method = "bonferroni") 
pwc
pwc <- pwc %>% add_xy_position(x = "genoHCV")
ggboxplot(data=hcvdata, "genoHCV", "TE_value") +
  stat_pvalue_manual(pwc, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(tev_kw, detailed = TRUE),
    caption = get_pwc_label(pwc)
    )

with(hcvdata, chisq.test(table(genoHCV,stage)))
with(hcvdata, table(genoHCV,stage), by=stage) %>% add()

model=with(hcvdata,glm(table(cirrhosis~genoHCV),family='binomial'))

library(ggplot2)
ggplot(data=hcvdata, aes(group = genoHCV,y=TE_value))+geom_boxplot()
library(tidyverse)
library(ggpubr)
library(rstatix)
hcvmodel <- anova_test(TE_value ~ genoHCV)




hcvmodel
library(tidyverse)
library(ggpubr)
library(rstatix)

hcvdata <- hcvdata %>%
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


