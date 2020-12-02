library(tidyverse)

# Part I ----
input = tibble(expense = scan("solutions/day01/input"))

input %>% 
  filter((2020 - expense) %in% expense) %>% 
  summarise(prod(expense))

# Part II ----

input2 = rename(input, expense2 = expense)
input3 = rename(input, expense3 = expense)

# by = character() performs a cross join:
inputs = full_join(input, input2, by = character()) %>% 
  full_join(input3, by = character())

inputs %>% 
  filter(expense + expense2 + expense3 == 2020) %>% 
  distinct(expense) %>% 
  summarise(prod(expense))
