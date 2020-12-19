library(tidyverse)
library(glue)

input = tibble(input = read_lines("solutions/day19/input-test"))

split_at = which(input$input == "")

messages = input %>% 
  slice((split_at + 1):n()) %>% 
  rename(message = input)


rules_orig = input %>% 
  slice(1:(split_at-1)) %>% 
  separate(input, into = c("id", "rule"), sep = ": ") %>% 
  mutate(rule = str_remove_all(rule, "\\\"") %>% 
           str_remove_all(" ")) %>% 
  #separate_rows(rule, sep = "\\|") %>% 
  arrange(id)

zero  = slice(rules_orig,  1)$rule
rules = slice(rules_orig, -1)
loc = 1
while (TRUE){
  current_rule = str_sub(zero, loc, loc)
  while (! str_detect(current_rule, "[:digit:]")){
    loc = loc + 1
    current_rule = str_sub(zero, loc, loc)
  }
  replacement = filter(rules, id == current_rule)$rule
  if (str_detect(replacement, "\\|")){
    replacement = paste0("(", replacement, ")")
  }
  zero = str_replace(zero, fixed(current_rule), fixed(replacement))
  if (! str_detect(zero, "[:digit:]")){
    return(zero)
    break
  }
  loc = loc + 1
  #stopifnot(loc < 10)
  #print(zero)
  #if (loc %% 10 == 0){print(zero)}
}

zero = paste0("^", zero, "$")
messages %>% 
  mutate(is_valid = str_detect(message, zero)) %>% 
  summarise(sum(is_valid))




