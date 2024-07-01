
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                  Read Data                               ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

library(janitor)
library(dplyr)
source("R/functions_targets.R")


options(gargle_oauth_email = "ptiscornia@c40.org")

var_year <- 2023

path_cdp_datasets <- "/Users/pablotiscornia/Library/CloudStorage/GoogleDrive-ptiscornia@c40.org/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/"
path_cdp_datasets_year <- glue::glue("{path_cdp_datasets}CDP_Data_{var_year}/")

path_1st_extract <- paste0(path_cdp_datasets_year, "1st Extract/")
file_1st_extract <- list.files(path_1st_extract, pattern = "Flat")

path_file <- paste0(path_1st_extract, file_1st_extract)

### Step01
df_step01 <- step01_read_data_raw_1st_extract(path_file)


## Step 02
path_cdp_datasets <- "/Users/pablotiscornia/Library/CloudStorage/GoogleDrive-ptiscornia@c40.org/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/"
file <- "cdp_questionnaire_map.xlsx"

questions_selection <- readxl::read_xlsx(paste0(path_cdp_datasets, file), sheet = 2) |> 
  janitor::clean_names() |> 
  filter(team_involved_1 == "Waste" | team_involved_2 == "Waste" | team_involved_3 == "Waste") |> 
  pull(question_number)

df <- step01_read_raw_1st_extract |> 
  filter(`Question Number` %in% questions_selection)

# Test
df_step02 <- extract02_select_questions(df_step01)

## Step 03 - Select columns




options(gargle_oauth_email = "ptiscornia@c40.org")
path_df <- "https://docs.google.com/spreadsheets/d/1zABLSeJWC-soHltS5oac94iz8sWm9xMFW3jZ6QemY8c/edit#gid=0"

############# OLD Workflow
df_waste <- step01_read_data_raw(path_df)

## Clean column names
step02_clean_colnames <- df_waste |> 
  clean_names()

# Filter rows of interes
step03_select_questions <- step02_clean_colnames |> 
  filter(question_number == 3.7,
         column_number %in% c(2, 3))

## select variables of interes
step04_select_variables <- step03_select_questions |> 
  select(account_name, question_number, column_number, row_number, row_name, response_answer, comments, suggested_correction)

## Remove columns as lists (cause of merged cells in the google sheet)
step05_process_merged_cols <- step04_select_variables %>%
  mutate(across(where(is.list), ~ sapply(., toString)))

## Add NA values where missing value
step06_replace_missing_values <- step05_process_merged_cols |> 
  mutate(across(c(response_answer, suggested_correction), \(x) na_if(x, "")))


### Render Quality Report
rmarkdown::render(input = "QA_checks.Rmd", 
                  output_file = glue::glue("QA_output/QA_checks-{lubridate::today()}"))

