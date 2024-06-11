### Load libraries
library(readxl)
library(tidyverse)
library(readr)
library(sys)
library(glue)
library(c40tools)
library(googledrive)

### Extract data
year <- 2023
extract_version <- "1st Extract"
user_path <- get_googledrive_path()

url_long <- glue("{user_path}Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/CDP_Data_{year}/")
#url_wide <- "/Users/pablotiscornia/Google Drive/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/CDP_Data_2023/2nd Extract/C40 CitiesTabbedExtract 18082023.xlsx"

list.files(url_long)

df_cdp <- read_excel(path = glue("{url_long}/{extract_version}/C40 CitiesFlatExtract 18082023.xlsx"), 
                     sheet = 2) |>
  janitor::clean_names()
