
### Libraries needed
library(targets)
library(tarchetypes)


# Set target options:
tar_option_set(
  packages = c("here", "c40tools", "googlesheets4", "tidyverse", "janitor", "glue", 
               "DBI", "pointblank")
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source("R/functions_targets.R")
#tar_source("../AUTH.R")


### Define Targets
# Get raw data
var_year <- 2023

path_cdp_datasets <- "/Users/pablotiscornia/Library/CloudStorage/GoogleDrive-ptiscornia@c40.org/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/"
path_cdp_datasets_year <- glue::glue("{path_cdp_datasets}CDP_Data_{var_year}/")

path_1st_extract <- paste0(path_cdp_datasets_year, "1st Extract/")
file_1st_extract <- list.files(path_1st_extract, pattern = "Flat")
path_file <- paste0(path_1st_extract, file_1st_extract)



# path_df_raw <- "https://docs.google.com/spreadsheets/d/1zABLSeJWC-soHltS5oac94iz8sWm9xMFW3jZ6QemY8c/edit#gid=0"
# path_df_reviews <- "https://docs.google.com/spreadsheets/d/1zABLSeJWC-soHltS5oac94iz8sWm9xMFW3jZ6QemY8c/edit#gid=0"

list(
  #tarchetypes::tar_file(data_file, path_df),
  tar_target(data_raw, step01_read_data_revied_1st_extract(path_df)),
  tar_target(data_step02, step02_clean_colnames(data_raw)),
  tar_target(data_step03, step03_select_questions(data_step02)),
  tar_target(data_step04, step04_select_variables(data_step03)),
  tar_target(data_step05, step05_process_merged_cols(data_step04)),
  tar_target(data_step06, step06_replace_missing_values(data_step05)),
  tar_render(name = step07_report,
             path = here("QA_checks.Rmd"),
             output_file = here(glue::glue("QA_output/QA_checks-{lubridate::today()}")))
)
