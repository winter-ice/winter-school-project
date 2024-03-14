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
                    "lat", "lon", "depth_m_785110")
head(agg_all)

agg_all$date_time <- lubridate::as_datetime(agg_all$date_time)
agg_all$zone <- factor(substr(agg_all$wbody, 13, 13))
agg_all$holeID <- factor(substr(agg_all$wbody, 13, 14))
agg_all$event <- factor(substr(agg_all$wbody, 16, 17))
temp <- data.frame(NULL)
temp <- substr(agg_all$wbody, 7,8)
agg_all$event <- paste0(temp, agg_all$event)
agg_all$wbody <- factor(substr(agg_all$wbody, 1, 3))

