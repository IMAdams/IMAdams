# Lecture 8 lecture activities


# type I & II error
n=20 # sample size
s=15 # sample standard deviation
SE=s/sqrt(n) # standard error estimate
alpha=0.01 # significance level
muO=65 # hypothetical lower bound

# find t critical values
t_crit <- qt(p=alpha, df=n-1, lower.tail=TRUE)
print(t_crit)
crit= muO +qt(alpha, df=n-1)*SE
print(crit)

mu=55 # assumed actual mean
type_II_error <- pt((crit-mu)/SE,df=n-1,lower.tail=FALSE)
print(type_II_error)

# working example
n2=30
SD2=1.25
SE2=SD2/sqrt(n)
muO2=1
mu2=9.95
alpha2 = 0.05
t_crit2 <- qt(p=alpha2, df=n2-1, lower.tail=TRUE)
print(t_crit2)
crit2= muO2 +qt(alpha2, df=n2-1)*SE2
print(crit2)
type_II_error2 <- pt((crit2-mu2)/SE2,
df=n2-1,lower.tail=FALSE)
print(type_II_error2)

# Cohen's effect size (d): difference in means/sd

##------------------------
library(pwr)
pwr.t.test(n=, d=(9-11)/2, sig.level = 0.05, power = 0.9, type = "two.sample", alternative = "two.sided")



p.z<- pwr.norm.test(d=(55-65)/15, sig.level=0.01,power=0.95,alternative="less")
print(p.z)
plot(p.z)
mu3 = -2.5
muX = -3.2
s3=1.5
power3= 0.8
alpha3=0.05
p.z3 <- pwr.norm.test(d=mu3-muX/s3, sig.level=alpha3, power=power3, alternative = "two.sided")
print(p.z3)
plot(p.z3)

# Cohen's H
# h=2*asin(sqrt(0.65))-2*asin(sqrt(0.5))
h=ES.h(0.65,0.5)
pwr.p.test(h=h,n=, sig.level=0.05, power=0.8, alternative= "two.sided")

# sample sie for testing two minutes

muX4=9
mu4=11
power4=0.9
pwr.t.test(n=, d=(muX4-mu4)/2, power=power4, alternative = "two.sided")
muX5 <- 10
s1 <- 15
s2 <- 17
s_pool <- sqrt((s1^2 + s2^2) / 2)
alpha5 <- 0.05
power5 <- 0.8
p.z5 <- pwr.t.test(n = , d = muX5 / s_pool, power = power5, alternative = "two.sided")
print(p.z5)
plot(p.z5)
