#' ---
#' title:  Biostats Lecture 3 Lab 
#' author: Your name   
#' date:   06/10/2025
#' ---

## clean out workspace 
rm(list=ls() )

## Set up working directory
# setwd("~/my/working/directory/biostats/Lecture3/")

#' ## ggplot2 graphs
library(ggplot2)
library(MASS)

#' histogram
ggplot(Pima.tr,aes(x=bmi))+geom_histogram()
ggplot(Pima.tr,aes(x=bmi))+geom_histogram(binwidth=1)
ggplot(Pima.tr,aes(x=bmi))+geom_histogram(binwidth=10)

#' boxplot
ggplot(Pima.tr,aes(y=bmi))+geom_boxplot()
ggplot(Pima.tr,aes(x=type,y=bmi))+geom_boxplot()
ggplot(Pima.tr,aes(x=type,y=bmi,col=type))+geom_boxplot()

#' scatterplot
ggplot(Pima.tr,aes(x=bmi,y=bp))+geom_point()+geom_smooth(method='lm')
ggplot(Pima.tr,aes(x=bmi,y=bp,col=type))+geom_point()+geom_smooth(method='lm')


#' ## R basics and programming

## Arithmetic operation
# 1 + exp(1.7) - sin(3/2*pi) 

## Logical operation
## There are only two logical values: TRUE (T) and FALSE (F)

## Review Objects in R: vector(numeric/character/logical/factor), matrix, data frame

## Vector functions: sort,rev,table,unique

## Math functions: log,exp,max,min,sum, mean, sd,var

## Selecting vector elements; x[4],x[-(1:3)],x[c(1,5)]

## cheat sheet: https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://iqss.github.io/dss-workshops/R/Rintro/base-r-cheat-sheet.pdf&ved=2ahUKEwjv0fOdotuNAxX0LUQIHcmBKG0QFnoECAwQAQ&usg=AOvVaw0SscDPwnZKOdSbyyH2E5qO

#' vectors
c(1,3,5,6)
1:6
seq(1,11,by=3)
seq(21,11,by=-2)

#' ## Probability mass function(pmf) for 𝑌∼Binomial(50,0.8)
df=data.frame(y=c(0,1:50),   probs=dbinom( c(0,1:50),50,0.8) )
barplot(probs ~ y, data=df)

#' ## Example 2. Toss a coin for 10 times
#' ## binomial distribution Binomial (10,0.5)
library(RcmdrMisc) 
x <- 0:10
plotDistr(x, dbinom(x, 10,0.5), discrete=TRUE)
plotDistr(x, pbinom(x, 10,0.5), discrete=TRUE,cdf=TRUE)

#' ## calculate probabilities
x<-0:10
x<-c(0,1,2,3,4,5,6,7,8,9,10)
# pmf =P(X=x)
dbinom(x,size=10,prob=0.5)


# cdf =P(X<=x)
pbinom(x,size=10,prob=0.5)

# P(Y>=8)=1-P(Y<=7)
1-pbinom(7,size=10,prob=0.5)

# complementary of P(Y<=7)
pbinom(7,size=10,prob=0.5, lower.tail = FALSE)


#P (4<Y<=6)=P(Y<=6)-P(Y<=4) , P(Y equals 5, 6)
pbinom(6,size=10,prob=0.5,lower.tail = TRUE)-pbinom(4,size=10,prob=0.5,lower.tail=TRUE)


#P (7=<Y<=9)=P(Y<=9)-P(Y<=6)
pbinom(9,size=10,prob=0.5)-pbinom(6,size=10,prob=0.5)



#' ## Poisson Distribution with mean=3 
x <- 0:15
plotDistr(x, dpois(x,3), discrete=TRUE, main='Poissson distribution: mean=3')
plotDistr(x, ppois(x,3), discrete=TRUE,cdf=TRUE,main='Poissson distribution: mean=3')

#' ## Random sampling

# set.seed(10)
# result=sample(1:20,10)
# result

#' ### Random sample from a poisson distribution
samples100=rpois(n=100,lambda = 3)
# hist(samples100)
# samples2000=rpois(n=2000,lambda = 3)
# hist(samples2000)
# table(samples2000)
# prop.table(table(samples2000))


