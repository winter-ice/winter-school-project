### Title: Data Aggregation for Winter School Project
### Created by: Braden DeMattei
### Created on: March 13, 2024
### Last Updated: March 13, 2024

#### Packages
library(tidyverse)
library(lubridate)
library(data.table)

name_to_string <- function(z){
  nm <-deparse(substitute(z))
  print(nm)
}
### CTD CSV Preparation Bog Mar12

filenames <- list.files(path = "./data")

##Create list of data frame names without the ".csv" part 
names <-substr(filenames, 1, nchar(filenames)-4)

###Load all files
for(i in names){
  filepath <- file.path("./data",paste(i,".csv",sep=""))
  assign(i, as_tibble(read.csv(file.path(filepath), skip = 18, header = T)))
}

for(i in names){
  x <- list()
  for(j in nrow(get(i))){
    x$wbody <- i
    x <- data.frame(x)
    }
   assign(i, cbind(get(i), x))
   
}



###Add Differentiation Columns



