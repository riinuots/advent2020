library(tidyverse)

input = tibble(input = read_lines("solutions/day22/input"))

# Part I ----
cards = input %>% 
  mutate(player = str_extract(input, "Player [:digit:]:")) %>% 
  fill(player, .direction = "down") %>% 
  filter(str_detect(input, "^\\d+$")) %>% 
  mutate(card = parse_number(input)) %>% 
  select(-input) %>% 
  group_by(player) %>% 
  mutate(order = row_number())

stopifnot(nrow(cards) + 3 == nrow(input))


while (cards$player %>% n_distinct() == 2){
  cards = cards %>% 
    group_by(order) %>% 
    mutate(is_winner = card == max(card)) %>% 
    mutate(was_involved = if_else(n_distinct(player) == 2, "2 - Played", "1 - Not Played")) %>% 
    ungroup() %>% 
    mutate(reallocate = if_else(is_winner, player, NA_character_)) %>% 
    arrange(was_involved, order, reallocate) %>% 
    fill(reallocate, .direction = "down") %>% 
    select(player = reallocate, card) %>% 
    group_by(player) %>% 
    mutate(order = row_number()) %>% 
    arrange(player, order)
  

}
cards %>% 
  ungroup() %>% 
  arrange(-order) %>% 
  rowid_to_column("score") %>% 
  summarise(result = sum(score*card)) %>% 
  pull(result)




