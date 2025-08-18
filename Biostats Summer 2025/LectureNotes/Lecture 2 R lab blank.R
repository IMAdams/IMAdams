#' ---
#' title:  Biostats Lab
#' author: Ian Adams
#' date:   06/09/2025
#' ---

##  Purpose of this script: Introduction to Rstudio
##  Any notes you would like to highlight:
##  Commented lines (shown in green font color) are for your own information and will not run in R

## clean out workspace

## Set up working directory
# Windows
# setwd("c:/Documents/my/working/directory")

## Mac and Linux
setwd("/Users/ianadams/Documents/IMAdams/Biostats Summer 2025")

## Alternatively use Files tab to set working directory

## Good Practice, Create an R project

## check working directory
getwd()
## check existing variables in the workspace
ls()
## R as a calculator
y=pi*35^2
print(y)
## Use keyboard shortcuts (tab auto completion, show previous commands)
### Run one line at a time
### CTRL+Enter (Windows)
### Command+Enter (Mac)


### Best way to learn: trials and errors


## load R packages
rm(list=ls())
library(RcmdrMisc)
library(ggplot2)
library(readxl)
# install.packages('glue')
library(gtsummary)

#' ## R basics


#' ## Reading and writing data

## Read an mice wt text file dataset into R 
micewt<-read.table("mice.wt.txt",header=TRUE,sep="\t")
dim(micewt)
micewt[1,2]=19.8

## Write Data into a local file
write.table(micewt,file="mice.wt.corrected.txt",sep="\t",
             row.names = FALSE,quote=FALSE)
write.csv(micewt,file="mice.wt.corrected.csv",row.names = FALSE,quote=FALSE)

#' ## Conversion among objects, create a matrix, convert to dataframe

#' ## Subsetting a dataframe

## extract rows and columns
names(micewt)
micewt$name
micewt$weight
micewt[1:6,]
head(micewt)
tail(micewt)

#' ## Read an SBP EXCEL dataset into R, and assign to an object named dataset 
## Description: Systolic blood pressure, age and gender in a sample of 70 subjects. 1 subject has missing data. 


## Data clean and variable recoding
## remove missing data NA

## Manage Variables in R
## Recode variable
install.packages("readxl")
library(readxl)
dataset <- read_excel("SBP.Dataset.xlsx")
dim(dataset)
names(dataset)
head(dataset)

dataset$sbp

dataset$sbpgrp=car::recode(dataset$sbp,"110:140='low';140.01:185='high'")
dataset$sbpgrp

## variable transformation
dataset<-within(dataset, {agesq=age^2})

#' ## Exercise: summarize the sbp data using graphs and numbers. 
#' ### 1. summary statistics for Dataset sbp, age, and gender
## ----------------------------------------------
summary(dataset$sbp)
summary(dataset$age)
table(dataset$gender)

#' ### 2. Histogram for sbp,age 
## ----------------------------------------------
par(mfrow=c(1,2))
hist(dataset$age)
hist(dataset$sbp)
#' ### 3. qqplot for sbp,age
## ----------------------------------------------
par(mfrow=c(1,2))
qqPlot(dataset$age)
qqPlot(dataset$sbp)
#' ### 4. Summary statistics for sbp,age by gender
## ----------------------------------------------
# method 1
summary(dataset$sbp[1:29]) #females
summary(dataset$sbp, by(dataset$gender)) #males
# method 2
datasetM <- dplyr::filter(dataset, dataset$gender == "male")
datasetM
datasetF <- dplyr::filter(dataset, dataset$gender == "female")
datasetF
summary(datasetM$sbp)
summary(datasetM$age)
summary(datasetF$sbp)
summary(datasetF$age)
summary(dataset$age ~ dataset$gender)

#' For publication purpose, use tbl_summary in the gtsummary package
## ----------------------------------------------
gtsummary::tbl_summary(dataset)

#' ### 5. Boxplot for sbp age, by groups 
## ----------------------------------------------

dataset$binarygender = recode(dataset$gender, "'male'=0; 'female'=1")
par(mfrow=c(1,2))
boxplot(dataset$age ~ dataset$gender)
boxplot(dataset$sbp ~ dataset$gender)

#' ## link to references on R: 
#' https://rstudio-education.github.io/hopr/r-objects.html#atomic-vectors
#' 
#' http://www.danieldsjoberg.com/gtsummary/articles/tbl_summary.html 


## ----------------------------------------------
#' # Start of student assignment #######################
## ----------------------------------------------
#' ## Instructions: Work in groups of 3-4 members. Join a group through Canvas.  Each group submits a report (including R scripts and output in the format of html or pdf files) to Canvas.  

#' ## 1. Read one of your datasets into R: 
## ----------------------------------------------
data(mtcars)
head(mtcars)

#' ## 2. Describe the dataset and check the contents, provide information on the size of the dataset (number of records, and number of variables)
## ----------------------------------------------

dim(mtcars)
length(mtcars[,1]) #number of records
length(mtcars[1,]) #number of variables

#' ## 3. Select a continuous variable in your dataset and complete the following tasks:
#' ### a. Summary statistics for the selected variable 
## ----------------------------------------------
summary(mtcars$mpg)


#' ### b. Histogram for the selected variable and comment on the distribution  
## ----------------------------------------------
par(mfrow=c(1,2))
hist(mtcars$mpg, breaks = 15)
# the distrbution has skew-left

#' ### c. qqplot for the selected variable 
## ----------------------------------------------
qqnorm(mtcars$mpg)


#' ### d. Summary statistics for selected variable by groups of your choice in your dataset
## ----------------------------------------------
summary(mtcars$mpg ~ mtcars$cyl)


#' ### e. Boxplot for the selected variable by groups of your choice in your datase and describe the group differences
## ----------------------------------------------
boxplot(mtcars$mpg ~ mtcars$cyl)


#' ## - Compile and upload your report to UNM canvas 
#' ### Go to file>Compile Report...>HTML>Compile
#' ### Upload your completed report to canvas  by Tuesday, June 10, 11:59pm

rmarkdown::render("Lecture 2 R lab blank.R")

