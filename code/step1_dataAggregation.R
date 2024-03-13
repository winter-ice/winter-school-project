### Title: Data Aggregation for Winter School Project
### Created by: Braden DeMattei
### Created on: March 13, 2024
### Last Updated: March 13, 2024

#### Packages & Functions
library(tidyverse)
library(lubridate)
library(data.table)
library(plyr)

### CTD CSV Preparation Bog & Lake

filenames <- list.files(path = "./data") ## Get filenames

##Create list of data frame names without the ".csv" part 
names <-substr(filenames, 1, nchar(filenames)-4)

###Load all files
for(i in names){
  filepath <- file.path("./data",paste(i,".csv",sep=""))
  assign(i, as_tibble(read.csv(file.path(filepath), skip = 18, header = T)))
} ##Read csv files in and assign variables based off names of files

for(i in names){
  x <- list()
  for(j in nrow(get(i))){
    x$wbody <- i
    x <- data.frame(x)
    }
   assign(i, cbind(get(i), x))
} ##Assign the waterbody, zone, holeID, & sampleEventID (combined)

x <- data.frame(NULL) #create empty dataframe for row-binding all datasets

for(i in names){
  x <- rbind.fill(x, get(i))
} #row bind all data sets

aggregated_all_bog_lake <- x #rename dataset

###Because of different CTD probes being used, there are different variable names
#####This will have to be dealt with at a later date



