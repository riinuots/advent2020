library(tidyverse)

input = scan("solutions/day10/input")

adapters = tibble(adapter = c(input, max(input)+3))
# Part I
adapters %>% 
  arrange(adapter) %>% 
  mutate(diff = adapter - lag(adapter, default = 0)) %>% 
  count(diff) %>% 
  summarise(prod(n))


# Part II

# figured the number of combinations out with pen and paper:
arrangements = tibble(group_size = 1:4, arrangements = c(1, 2, 4, 7))

# some wrangling to get group sizes, join with potential arrangements, take the product
adapters %>% 
  arrange(adapter) %>% 
  mutate(diff  = adapter - lag(adapter, default = 0),
         newgroup = if_else(diff != lag(diff, default = 999), "start", NA_character_)) %>% 
  filter(diff == 1) %>% 
  rowid_to_column() %>% 
  mutate(group_id = row_number(newgroup)) %>% 
  fill(group_id) %>% 
  count(group_id, name = "group_size") %>% 
  left_join(arrangements) %>% 
  summarise(prod(arrangements))