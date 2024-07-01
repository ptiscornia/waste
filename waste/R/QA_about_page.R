

table_n_responses <- 
  df_to_clean |> 
  mutate(has_response = case_when(!is.na(response_orig) | !is.na(response_suggested) ~ 1,
                                  .default = 0)) |> 
  group_by(row_name) |> 
  count(has_response) |> 
  ungroup() |> 
  filter(has_response == 1) |> 
  mutate(percentage = n / length(unique(df_to_clean$account_name))) |> 
  select(-has_response) |> 
  gt() |>
  tab_header(title = md("**Number of cities that responded per indicator**")) |> 
  tab_spanner(md("**Responses**"), columns = c(n, percentage)) |> 
  fmt_percent(columns = percentage, decimals = 1) |> 
  cols_label(
    row_name = "**Indicator**",
    n = "**Amount**",
    percentage = "**Percentage**",
    .fn = md
  )




##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                  ABOUT page.                             ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

about <- list(
  "part_1" = tags$p(
    
    h2("CDP workflow"),
    br(),
    tags$blockquote("This report is meant to run a data quality check through out the CDP questions that are related to **Waste data**."),
    br(),
    "This is the first part of the whole process that ends having the dataset uploaded in the Data Warehouse and with it, 
  available to use by tools like Qlik for data consumption like dashboards or reports.",
    br(),
    tags$img(src = here("img/cdp_workflow-1st_extract.jpg")),
    br(),
    h4("How to read the Quality Checks report?"),
    tags$img(src = here("img/validation.png")),
    br(),
    br(),
    h4("Number of cities that responded per question"),
    br()
  ),
  
  "part_2" = table_n_responses
)


