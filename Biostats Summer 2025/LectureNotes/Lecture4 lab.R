#' ---
#' title:  Biostats Lecture 3-4 R Lab 
#' author: Your name   
#' date:   06/12/2025
#' ---

## clean out workspace 
rm(list=ls() )

## Set up working directory
# setwd("~/my/working/directory/biostats/Lecture4/")

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
p1=ggplot(Pima.tr,aes(x=type,y=bmi,col=type))+geom_boxplot()
p1

#' scatterplot
p2=ggplot(Pima.tr,aes(x=bmi,y=bp))+geom_point()+geom_smooth(method='lm')
# Add color
ggplot(Pima.tr,aes(x=bmi,y=bp,col=type))+geom_point()+geom_smooth(method='lm')
# Add shape
p2=ggplot(Pima.tr,aes(x=bmi,y=bp,col=type,shape=type))+geom_point()+geom_smooth(method='lm')
p2

#' ## Put multiple graphs on the same panel
library(gridExtra)
## ?grid.arrange
## grid.arrange(p1,p2, nrow=1)
## grid.arrange(p1,p2, ncol=1)

#' ## R basics and programming
## use the help menu

## Arithmetic operation
# 1 + exp(1.7) - sin(3/2*pi) 

## Logical operation
## There are only two logical values: TRUE (T) and FALSE (F)

## Review Objects in R: vector(numeric/character/logical/factor), matrix, data frame

## Vector functions: sort,rev,table,unique

## Math functions: log,exp,max,min,sum, mean, sd,var

## Selecting vector elements; x[4],x[-(1:3)],x[c(1,5)]


#' vectors
c(1,3,5,6)
1:6
seq(1,11,by=3)
seq(21,11,by=-2)

## cheat sheet: https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://iqss.github.io/dss-workshops/R/Rintro/base-r-cheat-sheet.pdf&ved=2ahUKEwjv0fOdotuNAxX0LUQIHcmBKG0QFnoECAwQAQ&usg=AOvVaw0SscDPwnZKOdSbyyH2E5qO

#' ## Use R  for calculating probabilities 

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

#' ## Use R to plot probability distributions
library(RcmdrMisc) 

#' ## Probability mass function(pmf) for 𝑌∼Binomial(50,0.8)
df=data.frame(y=c(0,1:50),   probs=dbinom( c(0,1:50),50,0.8) )
barplot(probs ~ y, data=df)
plotDistr(df$y, df$probs, discrete=TRUE)

#' ## Example 2. Toss a coin for 10 times
#' ## binomial distribution Binomial (10,0.5)
x <- 0:10
plotDistr(x, dbinom(x, 10,0.5), discrete=TRUE)
plotDistr(x, pbinom(x, 10,0.5), discrete=TRUE,cdf=TRUE)


#' ## Poisson Distribution with mean=3 
x <- 0:15
plotDistr(x, dpois(x,3), discrete=TRUE, main='Poissson distribution: mean=3')
plotDistr(x, ppois(x,3), discrete=TRUE,cdf=TRUE,main='Poissson distribution: mean=3')

#' ## Continuous Random Variables

## SBP~ normal distribution: N(125,15*15)

## probability density function
xx=70:170
plot(xx,dnorm(xx,mean=125,sd=15),type='l',xlab='SBP',ylab='probability',main='Distribution of SBP')

# P(X<=140)-P(X<=110)
pnorm(140,mean=125,sd=15,lower.tail = TRUE)-pnorm(110,mean=125,sd=15,lower.tail = TRUE)
pnorm(155,mean=125,sd=15,lower.tail = TRUE)-pnorm(95,mean=125,sd=15,lower.tail = TRUE)
pnorm(170,mean=125,sd=15,lower.tail = TRUE)-pnorm(80,mean=125,sd=15,lower.tail = TRUE)

# probability of hypotension
pnorm(90,mean=125,sd=15,lower.tail = TRUE)

# probability of hypertension
# P(X>140)=1-P(X<=140)
1-pnorm(140,mean=125,sd=15,lower.tail = TRUE)

# probability of sbp between 110 and 130
# P(110<X<=130)=P(X<=130)-P(X<=110)
pnorm(130,mean=125,sd=15,lower.tail = TRUE)-pnorm(110,mean=125,sd=15,lower.tail = TRUE)


## BMI N(25,25)
## probability density function
xx=8:42
plot(xx,dnorm(xx,mean=25,sd=5),type='l',xlab='BMI',ylab='probability',main='Distribution of BMI')

# probability of underweight
pnorm(18.5,mean=25,sd=5,lower.tail = TRUE)

# probability of obese
# P(X>30)=1-P(X<=30)
1-pnorm(30,mean=25,sd=5,lower.tail = TRUE)

# upper tail probability
pnorm(30,mean=25,sd=5,lower.tail = FALSE)

# probability of BMI between 25 and 30
# P(25<X≤30)=P(X<=30)-P(X<=25)
pnorm(30,mean=25,sd=5,lower.tail = TRUE)-pnorm(25,mean=25,sd=5,lower.tail = TRUE)

# probability of normal weight BMI between 18.5 and 25
# P(18.5<X≤25)=P(X<=25)-P(X<=18.5)
pnorm(25,mean=25,sd=5,lower.tail = TRUE)-pnorm(18.5,mean=25,sd=5,lower.tail = TRUE)

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



## ----------------------------------------------
#' # R lab group assignment      #######################
#' # Start of student assignment #######################
## ----------------------------------------------
#' ## Instructions: Work in groups of 2-4 members. Each group submits a report (including R scripts and output in the format of html or pdf files) to Canvas.  

#' ### 1. Identify the coding problems below and fix the coding , change eval = TRUE in your R script
#+ echo=TRUE, eval = FALSE
my variable <- 3

a=seq(1, 10 by = 2)

b=c(1,3,4,5 6)

numsummary(c(1:11))

Library(cars)

mean(c(0,2,3,NA))  # check na.omit option in help menu for mean function

table(iris$species) 

summary(iris$sepal.length) 

##

#' ### 2. Read one of your datasets into R and complete the following tasks: 
#' ### - a. Identify a continuous variable in your dataset, provide summary statistics and graphs to describe the variable, and comment on the variable distribution 
#' ### - b. Recode the selected variable into a new categorical variable based on biologically or clinically meaningful definitions, provide summary statistics and graphical summary of the new categorical variable 
## ----------------------------------------------


#' ### 3. Download the “Survival.csv” data set from Canvas and read the dataset into R (try to use different internet browser if there are issues downloading the data file). This data set appeared in Haberman (1976) and was obtained from the UCI Machine Learning Repository. The dataset contains cases from a study that was conducted between 1958 and 1970 at the University of Chicago’s Billings Hospital on the survival of patients who had undergone surgery for breast cancer. The variables are:
#' ### - Age: Age of patient at the time of operation.
#' ### - Nodes: Number of positive axillary nodes detected.
#' ### - Status: Survival status. 1 = the patient survived 5 years or longer;    2 = the patient died within 5 year.
#' ### Complete the tasks below use ggplot: 
#' ### a. Use graphs to summarize each variable: Age, Nodes, and Status.
#' ### b. Plot the histograms for Nodes and $\sqrt{Nodes}$. Are the distributions skewed and in which direction? Which one is more skewed?
#' ### c. Use graph to visualize the relationship between Status and Age
#' ### d. Use graph to visualize the relationship between Age and Nodes.
## ----------------------------------------------
## dataset<-read.csv("survival.csv")


#' ### 4. Assume that BMI in US has the Normal (26, 36) distribution (mean=26, sd=6). 
#' ### a. Use R to find the probability of being underweight (BMI ≤ 18.5).
#' ### b. Use R to find the probability of being normal weight (18.5 < BMI ≤ 25).
#' ### c. Use R to find the probability of being overweight(25 < BMI ≤ 30)
#' ### d. Use R to find the probability of being obese (BMI>30).
#' ### e. Use R to plot the probability density function of BMI ~ Normal(26,36).
## ----------------------------------------------



#' ## - Compile and upload your report to UNM canvas 
#' ### Go to file>Compile Report...>HTML>Compile
#' ### Upload your completed report to canvas by Friday, June 20

