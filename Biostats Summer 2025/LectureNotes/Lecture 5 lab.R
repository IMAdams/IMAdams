#' ---
#' title:  Biostats Lecture 5 R Lab 
#' author: Your name   
#' date:   06/17/2025
#' ---

## clean out workspace 
rm(list=ls() )

## Set up working directory
# setwd("~/my/working/directory/biostats/Lecture5/")

#' ## probability that a random sample of size 100 will have a mean greater than 128
#1-P(xbar<=128)
1-pnorm(128,mean=125, sd=1.5)

#' ## critical values
# 95% CI
# find critical value upper tail 2.5%=0.025
qnorm(0.025,mean=0,sd=1,lower.tail = FALSE)
qt(0.025,df=100-1,lower.tail = FALSE)
# 99%CI
# find critical value upper tail 0.01/2=0.005
qnorm(0.005,mean=0,sd=1,lower.tail = FALSE)


#' ## SAMPLING from a non-normal(poisson) distribution

library(car)
poisSamples15 <- as.data.frame(matrix(rpois(1000*15, lambda = 3),ncol=15))
poisSamples15 <- within(poisSamples15, {mean <- rowMeans(poisSamples15[,1:15])})
hist(poisSamples15$mean)
qqPlot(poisSamples15$mean)

poisSamples500 <- as.data.frame(matrix(rpois(1000*500, lambda = 3),ncol=500))
poisSamples500 <- within(poisSamples500, {mean <- rowMeans(poisSamples500[,1:500])})
hist(poisSamples500$mean)
qqPlot(poisSamples500$mean)


#' ## confidence intervals
library(MASS)
data(Pima.tr)
mean(Pima.tr$bmi)
sd(Pima.tr$bmi)

tcrit=qt(0.025,df=200-1,lower.tail = FALSE)
## Lower 95% CI
mean(Pima.tr$bmi)-tcrit*sd(Pima.tr$bmi)/sqrt(200)

## Upper 95% CI
mean(Pima.tr$bmi)+tcrit*sd(Pima.tr$bmi)/sqrt(200)

## use R to find 95% confidence interval
t.test(Pima.tr$bmi,conf.level = 0.95)

## use R to find 99% confidence interval
t.test(Pima.tr$bmi,conf.level = 0.99)

#' ## confidence interval for a population proportion
library(binom)
binom.confint(68,200,0.95,methods="asymptotic")

