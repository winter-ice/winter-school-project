### Title: Data Aggregation for Winter School Project
### Created by: Braden DeMattei
### Created on: March 13, 2024
### Last Updated: March 13, 2024

#### Packages & Functions
library(tidyverse)
library(lubridate)
library(data.table)
library(plyr)
library(ggplot2)

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

agg_all <- as_tibble(x) #rename dataset
rm(x)
###Because of different CTD probes being used, there are different variable names
#####This will have to be dealt with at a later date

names(agg_all) <- c("date_time", "turb_ntu_803671", "bga_pc_fluoro_rfu_797015",
                    "act_cond_mscm_803397", "spec_cond_mscm_803397",
                    "sal_psu_803397", "resis_ohmcm_803397",
                    "dens_gcm_803397", "tot_diss_solids_ppt_803397",
                    "chl_a_fluoro_rfu_803397", "temp_c_804550",
                    "baro_press_mmhg_804550", "press_psi_785112",
                    "depth_m_785112", "surf_elev_m_785112",
                    "ext_volt_v_804550", "batt_capa_804550",
                    "baro_press_mbar_868976", "temp_c_868976",
                    "marked", "wbody", "act_cond_mscm_801689",
                    "spec_cond_mscm_801689", "sal_psu_801689",
                    "resis_ohmcm_801689", "dens_gcm_801689",
                    "tot_diss_solids_ppt_801689", "turb_ntu_805029",
                    "chl_a_fluoro_rfu_804424", "bga_pc_fluoro_rfu_864349",
                    "temp_c_804569", "baro_press_mmhg_804569",
                    "press_psi_785110", "depth_ft_785110",
                    "ext_volt_v_804569", "batt_capa_804569",
                    "baro_press_mbar_791538", "temp_c_791538",
                    "lat", "lon", "depth_m_785110", "depth_ft_785112")
head(agg_all)

agg_all$date_time <- lubridate::as_datetime(agg_all$date_time) #May need to open LakMar13CTD-L3-01d and mess with date time formatting
agg_all$zone <- factor(substr(agg_all$wbody, 13, 13))
agg_all$holeID <- factor(substr(agg_all$wbody, 13, 14))
agg_all$event <- factor(substr(agg_all$wbody, 16, 17))
temp <- data.frame(NULL)
temp <- substr(agg_all$wbody, 7,8)
agg_all$event <- factor(paste0(temp, agg_all$event))
agg_all$wbody <- factor(substr(agg_all$wbody, 1, 3))

levels(agg_all$event) <- c("12a", "12a", "13a", "13b", "13c", "13d")

temp_agg1 <- agg_all[,c(1:21,42:45)]
temp_agg2 <- agg_all[,c(1, 20:45)]

x <- list()
y <- names(temp_agg1)

for(i in 1:length(y)){
  if(nchar(y[i]) > 9){
    x[i] <- substr(y[i], 1, nchar(y[i])-7)
  }else{x[i] <- y[i]}
  if(x[i] %in% "temp_c" & i > 13){
    x[i] <- paste0("temp_c", 20)}else{next}
}

names(temp_agg1) <- x


k <- list()
l <- names(temp_agg2)

for(i in 1:length(l)){
  if(nchar(l[i]) > 9){
    k[i] <- substr(l[i], 1, nchar(l[i])-7)
  }else{k[i] <- l[i]}
  if(k[i] %in% "temp_c" & i > 13){
    k[i] <- paste0("temp_c", 20)}else{
  if(k[i] %in% "depth_ft" & i > 19){
    k[i] <- paste0("depth_ft", 2)}else{next}
  }
}


names(temp_agg2) <- k

agg_all_2 <- temp_agg1 %>%
  full_join(temp_agg2, by = intersect(colnames(temp_agg1), colnames(temp_agg2)))

agg_all_f <- agg_all_2[!is.na(agg_all_2$temp_c),]

names(agg_all_f)

View(agg_all_f)
#####
# 
# eliz_data <- read.csv("~/Desktop/trout_CDT_compiled_data.csv", header= T)
# 
# names(eliz_data) <- c("wbody", "zone", "holeID", "event", "date_time",
#                      "turb_ntu", "bga_pc_fluoro_rfu", "act_cond_mscm",
#                      "spec_cond_mscm", "sal_psu", "resis_ohmcm", "dens_gcm", 
#                      "tot_diss_solids_ppt", "chl_a_fluoro_rfu", 
#                      "temp_c", "baro_press_mmhg", "press_psi",
#                      "depth_ft", "depth_m", "surf_elev_m",
#                      "ext_volt_v", "batt_capa", "baro_press_mbar",
#                      "temp_c20", "lat", "lon", "marked")
# eliz_data$date_time <- lubridate::as_datetime(eliz_data$date_time)
# eliz_data$zone <- factor(eliz_data$zone)
# levels(eliz_data$zone) <- c("l", "p")
# eliz_data$wbody <- factor(eliz_data$wbody)
# levels(eliz_data$wbody) <- c("Bog", "Lak")
# eliz_data$holeID <- factor(eliz_data$holeID)
# levels(eliz_data$holeID) <- c("L1", "L2", "L3", "L4", "L5", "L6", "P1", "P2", "P3", "P4", "P5", "P6")
# eliz_data$event <- factor(eliz_data$event)
# levels(eliz_data$event) <- c("12a", "13b", "13a", "13b", "13c", "13d")
# eliz_data$depth_ft2 <- NA
# eliz_data <- eliz_data %>% as_tibble()
# eliz_data <- eliz_data[names(agg_all_f)]
# 
# test_agg <- agg_all_f[,-1]
# test_eliz <- eliz_data[,-1]

#####



