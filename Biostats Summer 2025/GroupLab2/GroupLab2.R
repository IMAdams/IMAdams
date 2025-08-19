## ----------------------------------------------
#' # R lab group assignment      #######################
#' # Start of student assignment #######################
## ----------------------------------------------
#' ## Instructions: Work in groups of 2-4 members. Each group submits a report (including R scripts and output in the format of html or pdf files) to Canvas.
#' 
#' Angela Littlefield,  Laura Santos-Median, Hayley Wondra, Ian Adams

#' ### 1. Identify the coding problems below and fix the coding , change eval = TRUE in your R script
rm(list = ls())

echo = TRUE
eval = TRUE
my_variable <- 3
a <- seq(1, 10, by = 2)
b <- c(1, 3, 4, 5, 6)
summary(c(1:11))
library(car)
mean(c(0, 2, 3, NA), na.rm = TRUE) # check na.omit option in help menu for mean function
head(iris)
table(iris$Species)
summary(iris$Sepal.Length)

##

#' ### 2. Read one of your datasets into R and complete the following tasks:
#' ### - a. Identify a continuous variable in your dataset, provide summary statistics and graphs to describe the variable, and comment on the variable distribution

## ----------------------------------------------
library(ggplot2);
library(ggpubr)
data(ToothGrowth)
head(ToothGrowth)
tail(ToothGrowth)
summary(ToothGrowth$len)
summary(ToothGrowth$supp)
summary(ToothGrowth$dose)

len_hist <- ggplot(ToothGrowth, aes(x = len)) +
    labs(x = "Tooth Growth") +
    geom_histogram(aes(y = after_stat(density)), colour = "black", fill = "hotpink", binwidth = 2) + # the histogram is plotted initially as density, then a re-scaled y-axis shows what the count is
    geom_density(alpha = .2, fill = "#FF6666") +
    scale_y_continuous(name = "Density", sec.axis = sec_axis(transform = ~ . * 125, name = "Counts")) +
    geom_vline(aes(xintercept = median(len), color = "median"), linetype = 2) +
    geom_vline(aes(xintercept = mean(len), color = "mean"), linetype = 1) +
    geom_vline(aes(xintercept = quantile(len, prob = 0.25), color = "1st Quantile"), linetype = 3, linewidth = 2) +
    geom_vline(aes(xintercept = quantile(len, prob = 0.75), color = "3rd Quantile"), linetype = 3, linewidth = 2) +
    scale_color_manual(name = "statistics", values = c("1st Quantile" = "orange", "3rd Quantile" = "cyan", median = "blue", mean = "red"), guide = guide_legend(reverse = TRUE))

len_qq <- ggplot(ToothGrowth, aes(sample = len)) +
    stat_qq() +
    stat_qq_line()

ggarrange(len_hist, len_qq, labels = c("Histogram and Density", "QQ plot"), ncol = 1, nrow = 2)
print("The distribution of length of tooth growth is approximately normal")

#' ### - b. Recode the selected variable into a new categorical variable based on biologically or clinically meaningful definitions, provide summary statistics and graphical summary of the new categorical variable

ToothGrowth$dosecat <- recode(ToothGrowth$dose, "0:0.5='Low'; 0.51:1 = 'Med'; 1.1:2.0 = 'High'")
ToothGrowth$dosecat <- factor(ToothGrowth$dosecat, levels = c("Low", "Med", "High"), ordered = TRUE)
summary(ToothGrowth$dosecat)
sort(ToothGrowth$dosecat, levels = c("Low", "Med", "High"));
ggplot(ToothGrowth, aes(x = dosecat, y = len, fill = supp)) +
    geom_boxplot() +
    xlab("Dose Category") +
    ylab("Tooth growth")


#' ### 3. Download the “Survival.csv” data set from Canvas and read the dataset into R (try to use different internet browser if there are issues downloading the data file). This data set appeared in Haberman (1976) and was obtained from the UCI Machine Learning Repository. The dataset contains cases from a study that was conducted between 1958 and 1970 at the University of Chicago’s Billings Hospital on the survival of patients who had undergone surgery for breast cancer. The variables are:
#' ### - Age: Age of patient at the time of operation.
#' ### - Nodes: Number of positive axillary nodes detected.
#' ### - Status: Survival status. 1 = the patient survived 5 years or longer;    2 = the patient died within 5 year.

dataset <- read.csv("survival.csv")
head(dataset)


#' ### Complete the tasks below use ggplot:
#' ### a. Use graphs to summarize each variable: Age, Nodes, and Status.
dataset$StatF <- factor(dataset$Status, levels = c(1,2), labels = c("negative", "positive"))
pAge <- ggplot(dataset, aes(x = Age)) +
    geom_histogram(binwidth=2)
pNode <- ggplot(dataset, aes(x = Nodes)) +
    geom_histogram(binwidth = 2)
pStat <- ggplot(dataset, aes(x = StatF)) +
    geom_bar() + xlab("Node Status")
ggarrange(pAge, pNode, pStat, labels = c("Age", "Nodes", "Status"), ncol = 3, nrow = 1)


#' ### b. Plot the histograms for Nodes and $\sqrt{Nodes}$. Are the distributions skewed and in which direction? Which one is more skewed?
pNode <- ggplot(dataset, aes(x = Nodes)) +
    geom_histogram(binwidth = 1)
prootNode <- ggplot(dataset, aes(x = sqrt(Nodes))) +
    geom_histogram(binwidth = 1)

ggarrange(pNode, prootNode, labels = c("A", "B"), ncol = 2, nrow = 1)
print("The distributions are both left skewed, and both have a similar shape")


#' ### c. Use graph to visualize the relationship between Status and Age

pAgeStat <- ggplot(dataset, aes(x = StatF, y = Age)) +
    geom_violin(adjust = 1/2) + geom_point() +xlab("Node Status")
pAgeStat
#' ### d. Use graph to visualize the relationship between Age and Nodes.

pAgeNode <- ggplot(dataset, aes(x = Age, y = Nodes)) +
    geom_point()
pAgeNode


## ----------------------------------------------

#' ### 4. Assume that BMI in US has the Normal (26, 36) distribution (mean=26, sd=6).
#' ### a. Use R to find the probability of being underweight (BMI ≤ 18.5).

p_underweight <- pnorm(18.5, mean = 26, sd = 6, lower.tail = TRUE)
p_underweight


#' ### b. Use R to find the probability of being normal weight (18.5 < BMI ≤ 25).

p_normweight <- pnorm(25, mean = 26, sd = 6, lower.tail = TRUE) - p_underweight
p_normweight


#' ### c. Use R to find the probability of being overweight(25 < BMI ≤ 30)

p_overweight <- pnorm(30, mean = 26, sd = 6, lower.tail = TRUE) - p_underweight - p_normweight
p_overweight

#' ### d. Use R to find the probability of being obese (BMI>30).
p_obese <- pnorm(30, mean = 26, sd = 6, lower.tail = FALSE)
p_obese


#' ### e. Use R to plot the probability density function of BMI ~ Normal(26,36).
## ----------------------------------------------


bmi_pdf <- data.frame(y = c(0, 1:50), probs = dnorm(c(0, 1:50), 26, 6))
bmiplot <- ggplot(bmi_pdf, aes(x = y, y = probs)) +
    geom_line() + xlab("BMI")
bmiplot

#' ## - Compile and upload your report to UNM canvas
#' ### Go to file>Compile Report...>HTML>Compile
#' ### Upload your completed report to canvas by Friday, June 20

Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/tools")
rmarkdown::render("GroupLab2.R")
