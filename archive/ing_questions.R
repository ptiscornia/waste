### Load libraries
library(readxl)
library(tidyverse)
library(readr)
library(sys)
library(glue)

### Extract data
year <- 2023
user <- Sys.getenv("USER")

url_long <- paste0("/Users/", user, "/Google Drive/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/CDP_Data_{year}")
#url_wide <- "/Users/pablotiscornia/Google Drive/Shared drives/BPMI/Business Planning and Reporting/CDP_City Reporting/04_CDP_Datasets/CDP_Data_2023/2nd Extract/C40 CitiesTabbedExtract 18082023.xlsx"

df_cdp <- read_excel(path = glue("{url_long}/2nd Extract/C40 CitiesFlatExtract 18082023.xlsx"), 
                     sheet = 2) |>
  janitor::clean_names()
# 
# readr::write_rds(df_cdp, "data/cdp_data.rds")
#readr::write_rds(df_cdp, "cdp_app/data/cdp_data.rds")

#df_cdp <- read_rds("data/cdp_data.rds")


### List of questions
list_questions <- df_cdp |> 
  select(parent_section, starts_with(c("question", "column", "row"))) |> 
  #distinct(question_number, .keep_all = T) |> 
  mutate(order = case_when(str_starts(question_number, "10") ~ "99",
                           .default = question_number))

writexl::write_xlsx(x = list_questions |> select(-order), 
                    path = glue("{url_long}/cdp_questionnaire_map.xlsx")

