#Rasmus Olander 19.11.2020. Script for datawrangling for the data for week 48.

library(dplyr)

#Task 2.

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", 
               stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", 
              stringsAsFactors = F, na.strings = "..")

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


#Data wrangling continues, exercise 5.

#Task 1.

library(stringr)

human$gnipc <- str_replace(human$gnipc, pattern=",", replace ="") %>% as.numeric()

#Task 2.

#I'll start by renaming my columns according to the metafile.
human <- human %>% 
  rename(
    Country = country,
    Edu2.FM = edu2r, 
    Labo.FM = labfm,
    Edu.Exp = eduexp,
    Life.Exp = lifeexp,
    GNI = gnipc,
    Mat.Mor = matmor,
    Ado.Birth = adolbirth,
    Parli.F = reprparl
  )

#And then keep said columns
keep_columns <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp",
                  "GNI","Mat.Mor", "Ado.Birth", "Parli.F")

human <- select(human, one_of(keep_columns))

#Task 3.
#Removing all rows with missing values.

human <- human[complete.cases(human),]

#Task 4.
#Removing observations which relate to regions instead of countries.
#By looking at thed ata, we know that the alst 7 entries are regions.

last <- nrow(human) - 7
human <- human[1:last,]

#Task 5. 
#Country names as row names, remove the country variable and saving.

rownames(human) <- human$Country
keep_columns2 <- c("Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp",
                  "GNI","Mat.Mor", "Ado.Birth", "Parli.F")
human <- select(human, one_of(keep_columns2))

dim(human)
#155 observations and 8 variables. Checks out.

setwd("~/Desktop/IODS2020/IODS-project")
write.csv(human, file="data/human.csv", row.names = TRUE)

#Checking.
human <- read.csv("data/human.csv", row.names = 1)
"Everything works!"
