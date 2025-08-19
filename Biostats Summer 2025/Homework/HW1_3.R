# Homework question 3
# Biostatistics Summer 2025
# Ian Adams

# 3. Consider a random variable Y~ Binomial (10, 0.6) distribution. The probability mass function is described as in below table: 
#   

# 
# (a) Find the probability that the random variable is less than or equals to 4:  P(Y≤ 4).

threeA <- pbinom(4, 10, 0.6)
threeA


# (b) Find the probability that the random variable is greater than 5 and less than or equals to 8: P(5< Y ≤ 8).  
# (20 points, 10 points for each item)

threeB <- pbinom(8,size=10,prob=0.6,lower.tail = TRUE)-pbinom(5,size=10,prob=0.6,lower.tail=TRUE)
threeB
