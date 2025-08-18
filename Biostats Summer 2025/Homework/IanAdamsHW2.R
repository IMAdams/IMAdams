# 1. We assume that the probability distribution of blood pressure, X, is N(μ,σ2) distribution. Suppose that we did not
# know σ and estimated it using the sample standard deviation s = 6.5. To estimate μ (population mean blood
# pressure), we randomly selected n=100 people and measured their blood pressure. The sample mean is x= 110. Use
# R, we found that the critical value based on t distribution with degree of freedom =99 is t0.975,99 = 1.984.
# (a) Find the standard error of the sample mean (SEM).

s = 6
n = 100
sem = s/sqrt(n)
print(paste("the SEM of the sample mean is", sem))

# (b) Find the 95% confidence interval estimate for population mean μ based on this sample. Round the values to 2
# decimal places. Hint: use formula for the 95% CI.
# (20 points, 10 points for each item)

n <- 100
df <- n-1
t_crit <- 1.984
x_bar <- 110
s <- 6.5

ci <- c(x_bar - t_crit * sem, x_bar + t_crit * sem)
print(paste("The 95% CI is", round(ci[1], digits=2),"to" ,round(ci[2],digits=2)))
# 2. Download the “BodyTemperature.txt” data set from the textbook website
# (https://www.ics.uci.edu/~babaks/BWR/Home_files/BodyTemperature.txt ). The dataset is also available on UNM
# canvas. Suppose that the heart rate and body temperature are normally distributed in the population.

bodyTempData <- read.table("BodyTemperature.txt", header = TRUE)
nBT <- length(bodyTempData$HeartRate)
# (a) Use R to find the sample mean for the heart rate.
HR_x_bar <- mean(bodyTempData$HeartRate)
print(paste("The sample mean for heartrate is", HR_x_bar))
# (b) Use R to find the 95% confidence interval estimate for the population mean of heart rate.
HR_s <- sd(bodyTempData$HeartRate)
HR_sem <- HR_s/sqrt(nBT)
HR_crit <- qt(0.975, nBT-1)
HR_CI <- c(HR_x_bar-(HR_crit*HR_sem), HR_x_bar+(HR_crit*HR_sem))

print(paste("the 95% CI for heartrate is", round(HR_CI[1], digits=2),round(HR_CI[2], digits=2)))
# (c) Use R to find the sample mean for the body temperature.
temp_xbar <- mean(bodyTempData$Temperature)
temp_xbar
# (d) Use R to find the 95% confidence interval estimate for the population mean of body temperature.

temp_s <- sd(bodyTempData$Temperature)
temp_sem <- HR_s/sqrt(nBT)
temp_crit <- qt(0.975, nBT-1)
temp_CI <- c(temp_xbar-(temp_crit*temp_sem), temp_xbar+(temp_crit*temp_sem))
print(paste("the 95% CI for body temperature is", round(temp_CI[1], digits=2),"to",round(temp_CI[2], digits=2)))

# (40 points, 10 points for each item)
# 3. Load the birthwt data from the MASS package into R. The ftv variable describes the number of physician visits
# during the first trimester. Use R to find the sample mean and the 95% confidence interval for the population mean
# of the number of physician visits during the first trimester.
# (20 points)
library(MASS)
data(birthwt)
head(birthwt)
ftv_xbar <- mean(birthwt$ftv)
ftv_xbar
ftv_n <- length(birthwt$ftv)
ftv_s <- sd(birthwt$ftv)
ftv_sem <- ftv_s/sqrt(ftv_n)
ftv_crit <- qt(0.975, ftv_n-1)
ftv_ci <- c(ftv_xbar-(ftv_crit*ftv_sem),ftv_xbar/+(ftv_crit*ftv_sem) )

print(paste("the 95% CI for first trimester visits is", round(ftv_ci[1], digits=2),"to",round(ftv_ci[2], digits=2)))
# 4. A study is conducted to estimate the proportion of people who smoke regularly. Suppose that the researchers
# interviewed a random sample of 2000 people and found that 320 of them smoke regularly. The proportion of regular
# smokers in this sample is p=0.16. Find the 95% confidence interval for the population proportion of regular
# smokers. Round the values to 2 decimal places.
# (20 points)
smoker_n <- 2000
p_smoker <- 0.16
smoker_se <- sqrt(p_smoker*(1-p_smoker)/n)
smoker_crit <- qnorm(0.975)
smoker_ci <- c(p_smoker-(smoker_crit*smoker_se),p_smoker+(smoker_crit*smoker_se))
print(paste("the 95% CI for smoker proportion is", round(smoker_ci[1], digits=2),"to",round(smoker_ci[2], digits=2)))

# Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools")
# rmarkdown::render("IanAdamsHW2.R")
getwd()
