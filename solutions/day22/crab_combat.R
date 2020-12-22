library(tidyverse)

input = tibble(input = read_lines("solutions/day22/input-test"))

cards = input %>% 
  mutate(player = str_extract(input, "Player [:digit:]:")) %>% 
  fill(player, .direction = "down") %>% 
  filter(str_detect(input, "^\\d+$")) %>% 
  mutate(card = parse_number(input)) %>% 
  select(-input)

stopifnot(nrow(cards) + 3 == nrow(input))

player1 = cards %>% 
  filter(player == "Player 1:") %>% 
  select(me = card) %>% 
  rowid_to_column()

player2 = cards %>% 
  filter(player == "Player 2:") %>% 
  select(crab = card) %>% 
  rowid_to_column()

while (nrow(player1) > 0 & nrow(player2) > 0){
  max_deck = max(c(nrow(player1), nrow(player2)))
  match = left_join(
    slice(player1, 1:max_deck),
    slice(player2, 1:max_deck)) %>% 
    mutate(result = if_else(me > crab, "me", "crab")) %>% 
    pivot_longer(matches("me|crab"), names_to = "drop", values_to = "card") %>% 
    select(-drop)
  
  if (! max_deck == nrow(player1)){
    remained1 = slice(player1, (max_deck+1):nrow(player1))
  } else{
    remained1 = slice(player1, NA)
  }
  if (! max_deck == nrow(player2)){
    remained2 = slice(player2, (max_deck+1):nrow(player2))
  } else{
    remained2 = slice(player2, NA)
  }
  
}








