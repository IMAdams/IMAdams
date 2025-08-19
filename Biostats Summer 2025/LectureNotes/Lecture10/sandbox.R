library(datarium)
library(psych)
# library(splines)

cat('\n','Summary of marketing Data Frame','\n')
summary(marketing)

with(marketing, plot(youtube,sales,main='youtube relationship with sales'))
with(marketing, plot(facebook,sales,main='facebook relationship with sales'))
with(marketing, plot(newspaper,sales,main='newspaper relationship with sales'))

cat('\n\n','Pearson correlation: sales by youtube','\n')
with(marketing, cor.test(sales,youtube,alternative='two.sided',method='pearson'))
cat('\n\n','Pearson correlation: sales by facebook','\n')
with(marketing, cor.test(sales,facebook,alternative='two.sided',method='pearson'))
cat('\n\n','Pearson correlation: sales by newspaper','\n')
with(marketing, cor.test(sales,newspaper,alternative='two.sided',method='pearson'))

cat('\n\n','Correlation Matrix - all variables in marketing','\n')
cor(marketing)

cat('\n\n','Spearman correlation: sales by youtube','\n')
with(marketing, cor.test(rank(sales),rank(youtube),alternative='two.sided',method='pearson'))
cat('\n\n','Spearman correlation: sales by facebook','\n')
with(marketing, cor.test(rank(sales),rank(facebook),alternative='two.sided',method='pearson'))
cat('\n\n','Spearman correlation: sales by newspaper','\n')
with(marketing, cor.test(rank(sales),rank(newspaper),alternative='two.sided',method='pearson'))


pairs.panels(marketing, gap = 0, pch = 21)   

cat('\n\n','Simplest Multiple Linear Regression','\n')           
fit1 <- lm(sales ~ youtube + facebook + newspaper, data=marketing)
summary(fit1)
par(mfrow=c(2,2))
plot(fit1,main='Assumptions: linear')

cat('\n\n','Simplest Multiple Linear Regression + Log Transformation','\n')           
fit1.log <- lm(log(sales) ~ youtube + facebook + newspaper, data=marketing)
summary(fit1.log)
par(mfrow=c(2,2))
plot(fit1.log,main='Assumptions: linear on log-transformed')

cat('\n\n','Simplest Multiple Linear Regression + Square root Transformation','\n')           
fit1.sqrt <- lm(sqrt(sales) ~ youtube + facebook + newspaper, data=marketing)
summary(fit1.sqrt)
par(mfrow=c(2,2))
plot(fit1.sqrt,main='Assumptions: linear on square root')

cat('\n\n','Simplest Multiple Linear Regression + Rank Transformation','\n')           
fit1.rank <- lm(rank(sales) ~ youtube + facebook + newspaper, data=marketing)
summary(fit1.rank)
par(mfrow=c(2,2))
plot(fit1.rank,main='Assumptions: linear on rank')

cat('\n\n','Simplest Multiple Linear Regression + Normal Transformation','\n')           
fit1.norm <- lm(qnorm(rank(sales)/(length(sales)+1)) ~ youtube + facebook + newspaper, data=marketing)
summary(fit1.norm)
par(mfrow=c(2,2))
plot(fit1.norm,main='Assumptions: linear on normal')


cat('\n\n','Complex Multiple Linear Regression','\n')           
fit2 <- lm(sales ~ poly(youtube,4)*poly(facebook,4)*poly(newspaper,4), data=marketing)
anova(fit2)
summary(fit2)
par(mfrow=c(2,2))
plot(fit2,main='Assumptions: 4th order polynomial')

cat('\n\n','Complex Multiple Linear Regression - with transformation','\n')           
fit3 <- lm(qnorm(rank(sales)/(length(sales)+1)) ~ poly(youtube,4)*poly(facebook,4)*poly(newspaper,4), data=marketing)
anova(fit3)
summary(fit3)
par(mfrow=c(2,2))
plot(fit3,main='Assumption Check')


cat('\n\n','Complex Multiple Linear Regression - cubic','\n')           
fit2.1 <- lm(sales ~ poly(youtube,3)*poly(facebook,3)*poly(newspaper,3), data=marketing)
anova(fit2.1)
summary(fit2.1)
par(mfrow=c(2,2.1))
plot(fit2,main='Assumption Check')

cat('\n\n','Compare cuartic and cubic complex Multiple Linear Regression models','\n')           
anova(fit2.1,fit2)  #Significant difference?
AIC(fit2.1,fit2)    #Smaller AIC is better

cat('\n\n','Complex Multiple Linear Regression - Splines','\n')           
fit4 <- lm(sales ~ ns(youtube,df=4)*ns(facebook,df=4)*ns(newspaper,df=4), data=marketing)
anova(fit4)
summary(fit4)
par(mfrow=c(2,2.1))
plot(fit4,main='Assumption Check')

cat('\n\n','Complex Multiple Linear Regression - Splines, 3df','\n')           
fit4.1 <- lm(sales ~ ns(youtube,df=3)*ns(facebook,df=3)*ns(newspaper,df=3), data=marketing)
anova(fit4.1)
summary(fit4.1)
par(mfrow=c(2,2))
plot(fit4.1,main='Assumption Check')

cat('\n\n','Complex Multiple Linear Regression - Splines, 3df','\n')           
fit4.2 <- lm(sales ~ ns(youtube,df=2)*ns(facebook,df=2)*ns(newspaper,df=2), data=marketing)
anova(fit4.2)
summary(fit4.2)
par(mfrow=c(2,2))
plot(fit4.2,main='Assumption Check')


cat('\n\n','Summary of marketing variables','\n')           
summary(marketing)
cat('\n\n','New data frame containing points for prediction','\n')           
mdat2 <- data.frame(youtube=c(0,0,355.68,176.45),facebook=c(0,59.52,0,27.92),newspaper=c(136.9,0,0,36.66))
print(mdat2)

cat('\n\n','Confidence intervals for predictions at selected points','\n')           
predict(fit2,newdata=mdat2,interval=c('confidence'))

cat('\n\n','Prediction intervals for predictions at selected points','\n')           
predict(fit2,newdata=mdat2,interval=c('prediction'))

