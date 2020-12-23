library(tidyverse)

input = read_file("solutions/day23/input") %>% 
  str_split("") %>% 
  unlist() %>% 
  parse_number()

# Part I
cups = input
n_turns     = 100
current_loc = 1
n_cups      = length(cups)

for (turn in 1:n_turns){
  #print(turn)
  print(cups)
  current_lab = cups[current_loc]
  three_cups  = c(cups, cups)[(current_loc+1):(current_loc+3)]
  print(three_cups)
  rem_cups    = cups[! cups%in% c(current_lab, three_cups)]
  rem_cups_smaller = rem_cups[rem_cups < current_lab]
  dest_lab    = if_else(length(rem_cups_smaller) == 0,
                        max(rem_cups),
                        current_lab - min(current_lab - rem_cups_smaller))
  print(dest_lab)
  new_cups0   = c(rem_cups, current_lab)
  dest_loc    = which(new_cups0 == dest_lab)
  new_cups    = c(new_cups0[1:dest_loc], three_cups, new_cups0[(dest_loc+1):length(new_cups0)])
  cups = new_cups
  
}
print(cups)
loc_1 = which(cups == 1)
c(cups, cups)[(loc_1+1):(loc_1 + n_cups -1)] %>% 
  paste(collapse = "")

