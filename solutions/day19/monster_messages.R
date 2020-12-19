library(tidyverse)

# Part I only ----
input = tibble(input = read_lines("solutions/day19/input"))

split_at = which(input$input == "")

messages = input %>% 
  slice((split_at + 1):n()) %>% 
  rename(message = input)


rules_orig = input %>% 
  slice(1:(split_at-1)) %>% 
  separate(input, into = c("id", "rule"), sep = ": ", convert = TRUE) %>% 
  mutate(rule = str_remove_all(rule, "\\\"")) %>% 
  arrange(id)

rules = rules_orig %>% 
  mutate(rule = if_else(str_detect(rule, " "), paste0("( ", rule, " )"), rule))

rules_mod = rules %>%
  # this is a hack
  mutate(rule = str_replace_all(rule, " 8 ", " 42 ")) %>%
  filter(id != 8)

while (TRUE){
  
  finals = rules_mod %>% 
    filter(! str_detect(rule, "[:digit:]"))
  
  for (i in 1:nrow(finals)){
    myid = paste0(" ", finals$id[i], " ")
    myrule = paste0(" ", finals$rule[i], " ")
    rules_mod = rules_mod %>% 
      mutate(rule = str_replace_all(rule, myid, myrule))
  }
  rules_mod = rules_mod %>% 
    mutate(rule = if_else(str_detect(rule, "\\|") | str_detect(rule, "[:digit:]"),
                          rule,
                          str_remove_all(rule, "[[:punct:]]| "))) 
  
  if(nrow(finals) == nrow(rules_mod)){break}
}


zero_combine  = rules_mod %>% 
  filter(id == 0) %>% 
  pull(rule) %>% 
  paste0("^", ., "$") %>% str_remove_all(" ")

messages %>% 
  mutate(is_valid = str_detect(message, zero_combine)) %>% 
  summarise(sum(is_valid))

