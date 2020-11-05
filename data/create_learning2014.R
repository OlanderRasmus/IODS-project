#Rasmus Olander 5.11.2020. Script for datawrangling exercise 2.

library(dplyr)

learning2014 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                           sep="\t", header=TRUE)

str(learning2014)

dim(learning2014)

#The data consists of 183 observations of 60 variables (60,180).
#All observations are coded as integers, except for learning2014$gender.
#This column consists of characters.

keep_columns <- c("gender", "Age", "Attitude", "Points")

lrn2014 <- select(learning2014, one_of(keep_columns))

deep_questions <- c("D03","D11","D19", "D27", 
                    "D07","D14", "D22", "D30",
                    "D06","D15", "D23", "D31")
deep_cols <- select(learning2014, one_of(deep_questions))

lrn2014$deep <- rowMeans (deep_cols)

surface_questions <- c("SU02","SU10","SU18","SU26", 
                       "SU05","SU13","SU21","SU29",
                       "SU08","SU16","SU24","SU32")

surf_cols <- select(learning2014, one_of(surface_questions))

lrn2014$surf <- rowMeans (surf_cols)

strategic_questions <- c("ST01","ST09","ST17","ST25",
                         "ST04","ST12","ST20","ST28")

stra_cols <- select(learning2014, one_of(strategic_questions))

lrn2014$stra <- rowMeans (stra_cols)

lrn2014 <- filter(lrn2014, Points > 0)

dim(lrn2014)

setwd("~/Desktop/IODS2020/IODS-project")

write.table (lrn2014, file = "learning2014.txt")

learning2014 <- read.table (file = "learning2014.txt")

str(learning2014)
head(learning2014)
