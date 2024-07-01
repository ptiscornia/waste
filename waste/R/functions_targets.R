
source("R/00-libraries.R")
source("../AUTH.R")


# Get raw data
extract01_read_data_raw <- function(file){
  
  options(gargle_oauth_email = "ptiscornia@c40.org")
  
  df_waste <- readxl::read_xlsx(path = file, sheet = "Response")
  return(df_waste)
}

extract02_select_questions <- function(df){
  
  path_cdp_datasets <- "/Users/pablotiscornia/Library/CloudStorage/GoogleDrive-ptiscornia@c40.org/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/"
  file <- "cdp_questionnaire_map.xlsx"
  
  questions_selection <- readxl::read_xlsx(paste0(path_cdp_datasets, file), sheet = 2) |> 
    janitor::clean_names() |> 
    filter(team_involved_1 == "Waste" | team_involved_2 == "Waste" | team_involved_3 == "Waste") |> 
    pull(question_number)
  
  df <- df |> 
    filter(`Question Number` %in% questions_selection)
  
  return(df)
}











step01_read_data_revied_1st_extract <- function(file){
  
  options(gargle_oauth_email = "ptiscornia@c40.org")
  
  df_waste <- googlesheets4::read_sheet(file)
  return(df_waste)
}



## Clean column names
step02_clean_colnames <-function(data){
  df <- data |> 
    clean_names()
  
  return(df)
}

# Filter rows of interes
step03_select_questions <- function(data){
  df <- data |> 
    filter(question_number == 3.7,
           column_number %in% c(2, 3))
  
  return(df)
}

## select variables of interes
step04_select_variables <- function(data){
  df <- data |> 
    select(account_name, question_number, column_name, row_number, row_name, response_answer, comments, suggested_correction)
  
  return(df)
}

## Remove columns as lists (cause of merged cells in the google sheet)
step05_process_merged_cols <- function(data){
  df <- data |> 
    mutate(across(where(is.list), ~ sapply(., toString)))
  
  return(df)
}

## Add NA values where missing value
step06_replace_missing_values <- function(data){
  df <- data |> 
    mutate(across(c(response_answer, suggested_correction), \(x) na_if(x, "")))
  
  return(df)
}