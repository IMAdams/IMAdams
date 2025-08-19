waist <- read.csv('waist_AT.csv')
# correlation is the strength of a linear relationship between two variables 
# the numerator of Pearson r shows direction and magnitude of covariance 
# assumptions say something abut the statistics we get out, and what we can say about them 
# key assumption: there is meaning in the values being correlated
# X values fall along a meaningful continuum or Gaussian dist 
# for each X we assume a distribution of Y values. Vatiability of Y does not change accordign to X values. 
waist <- read.csv('waist_AT.csv')
plot(x=waist$X, y=waist$Y, col="blue", xlab="Waist circumference (cm)", 
ylab="Deep abdominal AT area (cm^2)", main="Scatter Plot")

library(ggplot2)
p.w <- ggplot(data=waist,aes(x=X,y=Y)) + geom_point(col="blue")
p.w + labs(x="Waist circumference (cm)", y="Deep abdominal AT area (cm^2)", title="Scatter Plot")

with(waist, cor.test(X,Y,alternative='two.sided',method='pearson'))
with(waist, cor.test(X,Y,alternative='greater',method='pearson'))
with(waist, cor.test(X,Y,alternative='two.sided',method='spearman'))

with(waist, cor.test(rank(X),rank(Y),alternative='two.sided',method='pearson')) # use pearson's of the rank(x), rank(y) to get spearman's that has a confidence interval 

# distribution of Y residuals should be normally distributed. This is the assumption of linear regression 

fit1 <- lm(Y ~ X, data=waist)
coef(fit1)
confint(fit1)
summary(fit1)
plot(x=waist$X, y=waist$Y, col="blue", xlab="Waist circumference (cm), X",     ylab="Deep abdominal AT area (cm^2)", main="Scatter Plot with Regression Line", pch=16)

abline(fit1, col='red', lwd=2)

p.w <- ggplot(data=waist,aes(x=X,y=Y))+geom_point(col="blue")
p.w + labs(x="Waist circumference (cm)", y="Deep abdominal AT area (cm^2)", title="Scatter Plot")+geom_smooth(method="lm")+theme_bw()

par(mfrow=c(2,2)); plot(fit1)

fit1.w <- lm(Y ~ X, data=waist, weight=(1/X))
coef(fit1.w)
confint(fit1.w)
summary(fit1.w)
plot(x=waist$X, y=waist$Y, col="blue", xlab="Waist circumference (cm), X",     ylab="Deep abdominal AT area (cm^2)", main="Scatter Plot with Regression Line", pch=16)

p.w <- ggplot(data=waist,aes(x=X,y=Y))+geom_point(col="blue")
p.w + labs(x="Waist circumference (cm)", y="Deep abdominal AT area (cm^2)", title="Scatter Plot")+geom_smooth(method="lm")+theme_bw()

fit1 <- lm(Sales ~ TV, data=sales) # simple linear regression
summary(fit1)
fit2 <- lm(Sales ~ Radio, data=sales)
summary(fit2)
fit3 <- lm(Sales ~ Newspaper, data=sales) 
summary(fit3)
fit <- lm(Sales ~ TV + Radio + Newspaper, data=sales) # multiple regression
summary(fit)

fit <- lm(Sales ~ TV + Radio + Newspaper, data=sales) # assumption check
summary(fit)
par(mfrow=c(2,2))
plot(fit)

fit0 <- lm(Sales ~ TV + Radio, data=sales)
summary(fit0)



# Lab question 1 marketing dataset
# Using the “marketing” dataset in the R “datarium” library
library(datarium)

## How does it compare to the “Advertising” data set used in today’s lecture?
summary(marketing)
length(marketing$sales)
print("It is a similar dataset. There are 3 predictor variables and 1 response variable. There are 200 samples in the dataset")
## Generate scatter plots and compute pairwise correlation coefficients for each predictor variable against the “sales” outcome variable
library(ggplot2)
p.1 <- ggplot(data=marketing,aes(x=sales,y=youtube))+geom_point(col="blue")+ labs(x="sales($)", y="Youtube ad budget * $1000", title="simple linear regression")+geom_smooth(method="lm")+theme_bw()

p.2 <- ggplot(data=marketing,aes(x=sales,y=facebook))+geom_point(col="blue")+ labs(x="sales($)", y="Facebook ad budget * $1000", title="simple linear regression")+geom_smooth(method="lm")+theme_bw()

p.3 <- ggplot(data=marketing,aes(x=sales,y=newspaper))+geom_point(col="blue")+ labs(x="sales($)", y="Newspaper ad budget * $1000", title="simple linear regression")+geom_smooth(method="lm")+theme_bw()
library(ggpubr)
ggarrange(p.1, p.2, p.3, labels = c("Youtube", "Facebook", "Newspaper"), ncol = 1, nrow = 3)
## Can you fit a multiple linear regression model to the data that:
### Adequately meets regression LINE assumptions?
### Predicts sales better than the simple, 3-variable multivariable regression model?
## Predict sales at a variety of combinations of the predictor variables. What do these predictions tell you?  


fit <- lm(sales ~ youtube + facebook + newspaper, data=marketing); 
summary(fit); plot(fit)

fit2 <- lm(sales ~ poly(youtube,4)*poly(facebook,4)*poly(newspaper,4),data=marketing)
mdat2 <- data.frame(youtube=c(0,0,355.68,176.45),facebook=c(0,59.52,0,27.92),newspaper=c(136.9,0,0,36.66))
predict(fit2,newdata=mdat2,interval=c('confidence')) # how confident we are the regression line falls in this interval. 
predict(fit2,newdata=mdat2,interval=c('prediction'))
