---
#title: "Lecture Notes Day 1"
#author: "IM Adams"
#date: "`r Sys.Date()`"
#output: html_document
---

# Introduction

#These are the lecture notes for Day 1 of Biostats Summer 2025.

## R Code Example


10*3
50/4
10^4
log10(100)
log(25,5)
sum(1,2,3,4)

(5^3+5)/4
log10(90+5^4)
sum(log(32),8^4,6+5,12/4)


## clean out workspace
rm(list-ls())

## setwd
# setwd("path/to/yer/dir/")

Age=25
Age+10
BMI <- c(24,35,20,18,27,29,26)
BMI
mean(BMI)
var(BMI)

Ages=c(25,30,40,45)

Ages+10

ht<-c(150,150,169,182,193)
colors<-c("red","green","blue","brown","black")
df<-data.frame(ht=ht,colors=colors)
df$ht
df$colors
class(df)
class(df$ht)
class(df$colors)
str(df)
dim(df)

fuel=read.csv("FuelEconomyData.csv")
dim(fuel)

library(readxl)
fuel2=read_excel("FuelEconomyData.xlsx")
dim(fuel2)

fuel3=read.table("FuelEconomyData.txt",sep="\t",head=TRUE)
dim(fuel3)

# install.packages("ggplot2")
library(ggplot2)