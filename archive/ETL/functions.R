
### Questions related to Transport
q_number_transport <- c("3.5", "3.6", "9.1")
#q_section_transport <- c("Actions")

df_cdp_transport <- df_cdp |> 
  filter(question_number %in% q_number_transport) |> 
  mutate(response_answer_status = NA_real_,
         response_answer_cleaned = NA_real_,
         response_answer_comment = NA_real_)

list_df_transport <- list()

for (i in seq_along(1:3)) {
  
  list_df_transport[[q_number_transport[i]]] <- df_cdp_transport |> 
    filter(question_number == q_number_transport[i])
}


writexl::write_xlsx(list_df_transport, glue::glue("output/cdp_transport_2023-{extract_version}_cleaned.xlsx"))
writexl::write_xlsx(list_df_transport, glue::glue("output/cdp_transport_2023-{extract_version}_raw.xlsx"))
