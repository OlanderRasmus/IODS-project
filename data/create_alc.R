#Rasmus Olander 11.11.2020. Script for datawrangling exercise 3.

#Let's get started by setting and checking the working directory.

setwd("~/Desktop/IODS2020/IODS-project")

getwd()

"And let's set dplyr"
library(dplyr)

#Task 3

#Read both tables.

math <- read.csv("data/student-mat.csv", header = TRUE, sep = ";")
por <- read.csv("data/student-por.csv", header = TRUE, sep = ";")

#Explore structure and dimensions

dim(math)
str(math)

dim(por)
str(por)

#Task 4

#Let's join the two tables, with .math and .por as suffixes.

join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu",
             "Mjob","Fjob","reason","nursery","internet")

math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

dim(math_por)
str(math_por)

#Task 5
#Using the if-else structure from the DataCamp exercise.
#Check the column names
colnames(math_por)

#And add these columns to our new data drame "alc"
alc <-select(math_por, one_of(join_by))

#Then choose the columns that were not used for joining the data and print
notjoined_columns <-colnames(math)[!colnames(math) %in% join_by]
notjoined_columns

#for every column name not used for joining...
for(column_name in notjoined_columns) {
# select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data fram
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#Task 6
#Let's take the average answer related to weekday and weekend alcohol consumption.
#And create a new column 'alc_use' with the mean of these.

alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#Then, let's create a new column, 'high_use', which is TRUE when 'alc-use' > 2.

alc <- mutate(alc, high_use = alc_use > 2)

#Task 7
#Finally, let's glimpse at and save the data.
glimpse(alc)

#Everything looks good. 382 obs. of 35 variables, as it should be.

#Saving in the data folder.
write.csv(alc, file="data/alc.csv", row.names = FALSE)