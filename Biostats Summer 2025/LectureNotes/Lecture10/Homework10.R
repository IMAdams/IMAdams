## Homework 10
## 15 July 2025 Ian Adams 
MAPdata <- read.csv('Homework10/Hypertension.csv')
summary(MAPdata)
# 1
with(MAPdata, plot(X1,Y,main='Age relationship with MAP'))
with(MAPdata, cor.test(Y,X1,alternative='two.sided',method='pearson'))
with(MAPdata, cor.test(Y,X1,alternative='two.sided',method='spearman'))
# 2
fit1 <- lm(Y ~ X1, data=MAPdata)
summary(fit1)
coef(fit1)
confint(fit1)
par(mfrow=c(2,2))
plot(fit1)
library(car)
durbinWatsonTest(fit1)
length(MAPdata$X1)
# minimum of dataset
MAPdata$X1[which(rank(MAPdata$X1) == min(rank(MAPdata$X1)))]
# Next highest below maximum
MAPdata$X1[which(rank(MAPdata$X1) == max(rank(MAPdata$X1)-1))]
max(MAPdata$X1)
library(ggplot2 )
ggplot(MAPdata, aes(x=X1, y=Y))+geom_point()+stat_smooth(method = "lm")
# code from https://sejohnston.com/2012/08/09/a-quick-and-easy-function-to-plot-lm-results-in-r/
ggplotRegression <- function (fit) {

require(ggplot2)

ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
  geom_point() +
  stat_smooth(method = "lm", col = "red") +
  labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                     "Intercept =",signif(fit$coef[[1]],5 ),
                     " Slope =",signif(fit$coef[[2]], 5),
                     " P =",signif(summary(fit)$coef[2,4], 5)))
}
ggplotRegression(fit1)
# 3
library(psych)
pairs.panels(MAPdata[2:8], gap = 0, pch = 21)
# 4
fit2 <- lm(Y ~ X1+X2+X3+X4+X5+X6, data=MAPdata)
summary(fit2)
par(mfrow=c(2,2))
plot(fit2,main='Assumptions: linear')
coef(fit2)
confint(fit2)

summary(fit2)
par(mfrow=c(2,2))
plot(fit2)
durbinWatsonTest(fit2)

resids <- fit2$resid
par(mfrow=c(6,1), mar=c(1,1,1,1))
plot(MAPdata$X1,resids,xlab='X1',ylab='Residuals')
abline(0,0,col='red',lwd=2)
plot(MAPdata$X2,resids,xlab='X2',ylab='Residuals')
abline(0,0,col='red',lwd=2)
plot(MAPdata$X3,resids,xlab='X3',ylab='Residuals')
abline(0,0,col='red',lwd=2)
plot(MAPdata$X4,resids,xlab='X4',ylab='Residuals')
abline(0,0,col='red',lwd=2)
plot(MAPdata$X5,resids,xlab='X5',ylab='Residuals')
abline(0,0,col='red',lwd=2)
plot(MAPdata$X6,resids,xlab='X6',ylab='Residuals')
abline(0,0,col='red',lwd=2)

fit3 <- lm(Y ~ X1+X2+X3, data=MAPdata)
summary(fit3)
par(mfrow=c(2,2))
plot(fit3,main='Assumptions: linear')
coef(fit3)
confint(fit3)