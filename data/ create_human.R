#Rasmus Olander 19.11.2020. Script for datawrangling for the data for week 48.

library(dplyr)

#Task 2.

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Task 3.
str(hd)
dim(hd)
summary(hd)

str(gii)
dim(gii)
summary(gii)

#Task 4. 

colnames(hd)

hd <- hd %>% 
  rename(
    hdirank = HDI.Rank,
    country = Country,
    hdi = Human.Development.Index..HDI.,
    lifeexp = Life.Expectancy.at.Birth,
    eduexp = Expected.Years.of.Education,
    edumean = Mean.Years.of.Education,
    gnipc = Gross.National.Income..GNI..per.Capita,
    rankdiff = GNI.per.Capita.Rank.Minus.HDI.Rank
  )



colnames(gii)

gii <- gii %>% 
  rename(
    giirank = GII.Rank,
    country = Country,
    matmor = Maternal.Mortality.Ratio,
    adolbirth = Adolescent.Birth.Rate,
    reprparl = Percent.Representation.in.Parliament,
    edu2f = Population.with.Secondary.Education..Female.,
    edu2m = Population.with.Secondary.Education..Male.,
    labf = Labour.Force.Participation.Rate..Female.,
    labm = Labour.Force.Participation.Rate..Male.
  )

#Task 5. 

gii$edu2r <- gii$edu2f / gii$edu2m
gii$labfm <- gii$labf / gii$labm

#Task 6.

human <- inner_join(hd, gii, by = "country")
dim(human)

#Data checks out, 195 observations and 19 variables.

setwd("~/Desktop/IODS2020/IODS-project")
write.csv(human, file="data/human.csv", row.names = FALSE)