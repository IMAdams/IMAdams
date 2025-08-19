dataset <- read.table("Platelet.txt")
head(dataset)
bp <- c(118, 117, 119, 121,120,118,125,123,121,119,126,122,122,124,120)
bp <- as.table(bp)
bp
bpxbar <- mean(bp)
bpsd<- sd(bp)

tstat <- t.test(bp, mu = 120)
tstat
library(MASS)
data(Pima.tr)
# hyp mean BMI in pima women > 31

head(Pima.tr)
t.test(Pima.tr$bmi, alternative = c("greater"), mu = 31)

prop.test(x=Pima.tr$, n=200, p=0.4, alternative = 'two.sided', conf.level = 0.95, correct=FALSE)

PimDi <- Pima.tr$glu[which(Pima.tr$type=="Yes")]
PimHealthy <- Pima.tr$glu[which(Pima.tr$type=="No")]

var.test(PimDi, PimHealthy)
t.test(PimDi, PimHealthy, var.equal = FALSE)

library(car)