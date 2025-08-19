#' ---
#' title: Lecture 2 Part 1 -Summary statistics and graphical visualization
#' subtitle: R scripts for generating numbers, graphs and tables 
#' author: Li Luo, Ph.D.
#' date: 06/05/2025
#' ---

## ------------------------------------------------------------------------------------------- #

rm(list=ls())
library(MASS)
library(car)
library(ggplot2)
library(pander)
library(RcmdrMisc)

#' ## Structure of Pima.tr dataset
str(Pima.tr)
dim(Pima.tr)
summary(Pima.tr$age)
numSummary(Pima.tr$Age)
head(Pima.tr)
tail(Pima.tr)

#' ## Table -categorical variable type
tbl=table(Pima.tr$type)
tbl

#' ## Table -categorical variable type
props=prop.table(tbl)


#' ## graphs -categorical variable type
par(mfrow=c(1,3))
barplot(tbl)
barplot(props)
pie(tbl)


#' ## recode bmigrp- tables 
Pima.tr$bmigrp=recode(Pima.tr$bmi,"0:18.5='underwt';18.6:25='normal';
                                  25.1:30='overwt';30.1:50='obese'")

#' ## bmigrp- tables 
bmi_tbl=table(Pima.tr$bmigrp)
bmi_tbl
bmi_prop=prop.table(bmi_tbl)
bmi_prop

#' ## bmigrp- graphs
par(mfrow=c(1,3))
barplot(bmi_tbl)
barplot(bmi_prop)
pie(bmi_tbl)

#' ## Summary -continuous variables
summary(Pima.tr$bmi)
summary(Pima.tr$age)

#' ## Summary -continuous variables 
numSummary(Pima.tr$bmi)
numSummary(Pima.tr$age)

#' ## Box plots Example- MASS package Pima.tr dataset
par(mfrow=c(1,2))
boxplot(Pima.tr$bmi,main="bmi")
boxplot(Pima.tr$age,main="age")

#' ## Histogram -Age
Pima.tr <- within(Pima.tr, { AgeCat <- recode(age, '21:25="21-25"; 26:30="26-30"; 31:35="31-35"; 36:40="36-40"; 41:45="41-45"; 46:50="46-50"; 51:55="51-55"; 56:60="56-60"; 61:100="61+"', as.factor=TRUE) })
hist(Pima.tr$age)
barplot(table(Pima.tr$AgeCat))

#' ## Relative Frequency Distribution (Age in Pima.tr)
freqs=table(Pima.tr$AgeCat)
freqs
prop.table(freqs)

#' ## Histogram -Age, use ggplot
ggplot(Pima.tr,aes(x=age))+geom_histogram(breaks=seq(20,70, by=5),
                                          closed="right")+theme_bw()

#' ## Histograms -ped
par(mfrow=c(1,2))
hist(Pima.tr$ped,main="right-skewed")
hist(log(Pima.tr$ped),main="log transform")

#' ## qq plot- MASS package Pima.tr dataset
#' diastolic blood pressure (mm Hg)
qqPlot(Pima.tr$bp)

#' ## qq plot- MASS package Pima.tr dataset
#' bmi
qqPlot(Pima.tr$bmi)

#' ## diabetes pedigree function.
par(mfrow=c(1,2))
qqPlot(Pima.tr$ped)
qqPlot(log(Pima.tr$ped)) # IMA: test normality assumption with qqplot

#' ## Relationship between one continuous variable and one categorical variable
boxplot(bmi~type,data=Pima.tr)

#' ## Relationship between two continuous variables 
install.packages('mfp')
library(mfp)
data(bodyfat)
with(bodyfat,plot(weight,wrist))
abline(14.08,0.023)

#' ## Relationship between two continuous variables
install.packages('HSAUR2')
library(HSAUR2)
with(USmelanoma, plot(latitude,mortality))
abline(389.189, -5.978)

#' ## use ggplot2
ggplot(USmelanoma, aes(x = latitude,y = mortality))+
  geom_smooth(method = "lm")+geom_point()+theme_bw()

#' ## use ggplot2- add color groups
ggplot(USmelanoma, aes(x=latitude,y=mortality,col=ocean))+
  geom_smooth(method="lm")+geom_point()+theme_bw()

