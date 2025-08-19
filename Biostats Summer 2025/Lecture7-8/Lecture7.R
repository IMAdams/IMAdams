# Code activities with Lecture 7
# Ian Adams
rm(list = ls())
# two-sided t-test example 1
bpdata <- c(118, 117, 119, 121,120,118,125,123,121,119,126,122,122,124,120)
mu_bp = 120
bpttest<-t.test(bpdata, mu=mu_bp)
print(bpttest)

# two-sided t-test example 2

days <- c(14,9,18,26,12,0,10,4,8,21,28,24,24,2,3,14,9)
mu_days <- 15
daysttest<-t.test(days, mu=mu_days)
print(daysttest)

# one-sided t-test example 3
xbar = 98.4
s =1

tempdatasim <- rnorm(25, mean = xbar, sd = s)
tempttest<-t.test(tempdatasim, mu=98.6, alternative = "less")
print(tempttest)

# one-sided t-test example 4
library(MASS)
data(Pima.tr)
head(Pima.tr)
result <- t.test(Pima.tr$bmi, alternative="greater", mu=31, conf.level=0.95)
print(result)

# proportional hypothesis example 5
p_alt = 0.4
n=length(Pima.tr$type)
PimDi <- Pima.tr$glu[which(Pima.tr$type=="Yes")]
PimHealthy <- Pima.tr$glu[which(Pima.tr$type=="No")]
propDi = length(PimDi)/n
prop_results <- prop.test(length(PimDi), n, p_alt)
print(prop_results)

# example 7  ΔBMI in diabetic and non-diabetic? 

bmi_di <- Pima.tr$bmi[which(Pima.tr$type=="Yes")] 
bmi_Ndi <- Pima.tr$bmi[which(Pima.tr$type=="No")]
n_di = length(bmi_di)
n_Ndi =length(bmi_Ndi)
sd_di = sd(bmi_di)
sd_Ndi = sd(bmi_Ndi)
se= sqrt(sd_di^2/n_di+sd_Ndi^2/n_Ndi)
se
t_prime = (mean(bmi_Ndi)-mean(bmi_di))/se
t_prime

var.test(bmi ~ type, alternative="two.sided", conf.level=0.95, data=Pima.tr)
t.test(bmi~type, alternative = "two.sided", var.equal = FALSE, data=Pima.tr)


# example 8

glu_di <- Pima.tr$glu[which(Pima.tr$type=="Yes")] 
glu_Ndi <- Pima.tr$glu[which(Pima.tr$type=="No")]
n_di_glu = length(glu_di)
n_Ndi_glu =length(glu_Ndi)
sd_di_glu = sd(glu_di)
sd_Ndi_glu = sd(glu_Ndi)
se_glu= sqrt(sd_di_glu^2/n_di+sd_Ndi_glu^2/n_Ndi_glu)
se_glu
var_pool = ((n_di_glu-1)*sd_di_glu^2+(n_Ndi_glu-1)
*sd_Ndi_glu^2)/(n_di_glu+n_Ndi_glu-2)
var_pool
var.test(glu~type, alternative='two.sided', conf.level=0.95, data=Pima.tr)
t.test(glu~type, alternative='two.sided', conf.level=0.95, data=Pima.tr, var.equal=TRUE )

# example 9
platelet=read.table("Platelet.txt",head=T)
head(platelet)
platelet$diff=platelet$After-platelet$Before
print(platelet)
with(platelet, t.test(x=Before, y=After, alternative='two.sided', conf.level=0.95, var.equal=FALSE,paired=TRUE))

# R lab

rm(list=ls())
library(car)
library(RcmdrMisc)
library(multcomp)
library(gtsummary)
library(ggplot2)
library(ggpubr)
library(datarium)
library(rstatix)
help(package="datarium")

# Question 1: Does the average woman's weight differ from the average man's weight?

data(genderweight)
head(as.data.frame(genderweight))

var.test(weight ~ group, alternative="two.sided", conf.level=0.95, data=genderweight)
print("the results of the F-test (p=0.0016) indicate equal variances should not be assumed")
t.test(weight ~ group, alternative="two.sided", conf.level=0.95, data=genderweight, var.equal=FALSE)

print("The t-test indicates very strong support for the alternative hypothesis that there is a difference in weight between genders (p<0.0001)")

# Question 2: Are there changes in mice weight before and after treatment?

mices <- as.data.frame(mice2)
mices$diff <- mices$after-mices$before
head(mices)

with(mices, t.test(x=before, y=after, alternative='two.sided', conf.level=0.95, paired=TRUE))
print("The t-test indicates strong support for the alternative hypothesis that there is a decrease in mouse depression scores (p<0.0001)")

# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools")
# rmarkdown::render("Lecture7.R")

