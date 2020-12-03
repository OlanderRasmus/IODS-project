#Rasmus Olander 3.11.2020. Script for datawrangling exercise 6.

library(dplyr)
library(tidyr)

#Task 1
#Load the datasets and create the files.
#Note that the separator for BPRS is a space.

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", 
                    sep=" ", header=TRUE)
RATS <- read.table ("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
                    sep="\t", header=TRUE)

getwd()
write.csv (BPRS, file = "data/BPRS.csv", row.names = F)
write.csv (RATS, file = "data/RATS.csv", row.names = F)

BPRS <- read.csv("data/BPRS.csv")
RATS <- read.csv("data/RATS.csv")         

#Checking and viewing the data.
         
dim(BPRS)
#40 rows, 11 columns.
str(BPRS)
#all currently coded as integers.
summary(BPRS)

#The BPRS data gives information about how patients responded to 2 treatments.
#First column, treatment, gives information about which treatment was used.
#Second column, subject, gives information about which subject the row is for.
#The next columns, week0-8, give information about the patient's symptoms.
#This is from onset to 8 weeks, ranked on he BPRS scale.

dim(RATS)
#16 rows, 13 columns.
str(RATS)
#all currently coded as integers.

#The RATS data tells us about how three different groups of rats grow.
#First column, ID, is the rat's id, the second, Group, the group.
#The next 11, show the rat's weight every seven days.

#Both datasets are now in the wide format.

#Task 2
#Convert the categorical variables of both data sets to factors.

BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

#Task 3
#Convert the data sets to long form.
#Add a week variable to BPRS and a Time variable to RATS.
BPRSL <-  BPRS %>% 
  gather(key = weeks, value = bprs, -treatment, -subject) %>% 
  mutate(week = as.integer(substr(weeks,5,5)))

RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4))) 


#Task 4.
#Taking a serious look and understanding.
#So the short data has everything from one individual on one row.
#The long data, on the other hand, has one row consisting of one individual.
#But at one instance. This makes the long data a lot longer.

#Lets save the long data as well.
write.csv (BPRSL, file = "data/BPRSL.csv", row.names = F)
write.csv (RATSL, file = "data/RATSL.csv", row.names = F)
