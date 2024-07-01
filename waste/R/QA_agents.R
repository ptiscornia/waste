
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                Data import                               ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tar_load(data_step06)


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                              Data Preparation                            ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

df_to_clean <- data_step06 |> 
  #filter(row_name == "Total amount of solid waste generated (tonnes/year)") |> 
  mutate(column_name = case_when(str_starts(tolower(column_name), "response") ~ "answer",
                                 str_starts(tolower(column_name), "year") ~ "year")) |> 
  pivot_wider(names_from = column_name,
              values_from = c(response_answer, suggested_correction)) |> 
  group_by(account_name, row_name) |> 
  fill(c(response_answer_answer, response_answer_year,
         suggested_correction_answer, suggested_correction_year), .direction = "updown") |> 
  distinct(account_name, response_answer_answer, response_answer_year,
           suggested_correction_answer, suggested_correction_year, .keep_all = TRUE) |> 
  ungroup() |> 
  rename("response_orig" = response_answer_answer,
         "year_orig" = response_answer_year,
         "response_suggested" = suggested_correction_answer, 
         "year_suggested" = suggested_correction_year) |> 
  mutate(response_wrong = case_when(str_detect(tolower(comments), "wrong") ~ 1,
                                    .default = 0),
         response_prob_likely_wrong = case_when(str_detect(tolower(comments), "probably|likely") ~ 1,
                                                .default = 0))


al <- action_levels(warn_at = 0.0001)

agent_df_structure <- create_agent(
  tbl = df_to_clean,
  tbl_name = "waste cdp questions",
  label = "QA checks - Check columns structure",
  actions = al
) %>%
  col_vals_not_null(
    columns = c("account_name", "question_number", "row_number"), 
    label = "Check that are no NULL/NA values in column"
  ) |>
  rows_distinct(
    columns = "account_name",
    segments = vars(row_number),
    label = "Unique rows per indicator"
  ) |> 
  col_is_numeric(
    columns = c(question_number, row_number, response_orig, response_suggested),
    label = "Check that columns is numeric"
  ) |>
  col_is_integer(
    columns = c(starts_with("year")),
    label = "Check that column in integer"
  ) |> 
  interrogate()




agent_df_indicators <- create_agent(
  tbl = df_to_clean,
  tbl_name = "Waste cdp questions",
  label = "QA checks - Check question value's quality",
  actions = al
) |>
  col_vals_between(
    columns = starts_with("year"), 
    left = 2000, right = year(today()), 
    na_pass = TRUE,
    label = glue("Check that year col is between 2000 and current {year(today())}")
  ) |> 
  col_vals_regex(columns = c("response_orig", "response_suggested", "year_orig", "year_suggested"),
                 regex = "^[0-9]",
                 na_pass = TRUE,
                 label = "Check that values containg numbers only"
  ) |> 
  col_vals_equal(columns = vars(response_wrong, response_prob_likely_wrong), 
                 value = 0,
                 label = "Check comments where the word wrong or probably/likely wrong is mentioned") |> 
  col_vals_between(columns = vars(response_orig, response_suggested), 
                   left = 0, right = 100, 
                   na_pass = T, 
                   preconditions = 
                     ~ . %>% 
                     dplyr::filter(str_detect(row_name, "Percentage|percentage")) %>%
                     dplyr::mutate(response_orig = parse_number(response_orig)),
                   label = "Check that percentage indicator's values are between 0 and 100") |> 
  interrogate()
