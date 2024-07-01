
library(targets)
#use_targets()

Sys.setenv(TAR_WARN = "false")
options(scipen = 999)

### To start from scratch
#targets::use_targets()

### Check if everything works
targets::tar_manifest(fields = command)

### How the workflow looks like?
targets::tar_visnetwork()


### Run the pipeline
targets::tar_make()

### How the workflow looks like?
targets::tar_visnetwork()


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                               Upload dataset                             ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# qa_checks_log <- readr::read_csv("QA_output/qa_checks_log.csv") |> 
#   pull(x)
# 
# qa_checks_log

# if(qa_checks_log){
#   # Set DW connection
#   ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   ##                            Data Warehouse upload                         ----
#   ##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   # Set DW connection
#   con <- get_dw_connection()
#   
#   ### Upload dataset to the DataWarehouse
#   schema <- "public"
#   table <- "fact_city_aq_o3_concentrations_mortality"
#   
#   ### Drop table
#   query_drop_table <- glue("
#                          DROP TABLE IF EXISTS {schema}.{table};")
#   
#   dbSendQuery(con, query_drop_table)
#   
#   ### Create SQL table
#   query <- glue("
#             CREATE TABLE public.{table} (
#                 city_id SERIAL,
#                 city VARCHAR(50),
#                 year NUMERIC NOT NULL,
#                 clean_air_declaration_city BOOLEAN NULL,
#                 population_weighted_o3_partsperbillion NUMERIC NULL,
#                 mortality_copd NUMERIC NULL,
#                 mortality_chronic_respiratory_diseases NUMERIC NULL,
#                 years_life_lost_copd NUMERIC NULL,
#                 years_productive_life_lost_15to64_copd NUMERIC NULL,
#                 o3burden_copd_usd NUMERIC NULL,
#                 o3burden_copd_local_currency NUMERIC NULL,
#                 years_life_lost_chronic_respiratory_diseases NUMERIC NULL,
#                 years_productive_life_lost_15to64_chronic_respiratory_diseases NUMERIC NULL,
#                 o3burden_crd_usd NUMERIC NULL,
#                 o3burden_crd_local_currency NUMERIC NULL,
#                 mortality_total NUMERIC NULL,
#                 c40_member BOOLEAN NULL,
#                 created_at TIMESTAMP(0) WITH TIME ZONE DEFAULT NOW(),
#                 PRIMARY KEY (city_id)
#             );
#           ")
#   
#   dbSendQuery(con, query)
#   
#   ### Dataset upload
#   copy_to(con, 
#           tar_read(cleaned_data), 
#           dbplyr::in_schema("public", table), 
#           overwrite = TRUE, 
#           temporary = FALSE)
#   
#   DBI::dbExecute(con, glue("COMMENT ON TABLE public.{table} IS 'NO2 concentrations and asthma incidence'"))
#   
#   cat(green("The dataset was succesfully uploaded \n"))
#   
# } else {
#   
#   cat(yellow("Check the QA check file, there is something wrong. Once you've fixed it, run againg lines 16 to 26"))
#   
# }
