library(tidyverse)

input = read_csv("solutions/day05/input", col_names = "seat")

# Part I
tickets = input %>% 
  mutate(seat_binary = str_replace_all(seat, "F|L", "0") %>% 
                       str_replace_all("B|R", "1"),
         row    = str_sub(seat_binary, 1,  7) %>% strtoi(base = 2),
         column = str_sub(seat_binary, 8, 10) %>% strtoi(base = 2)) %>% 
  mutate(seat_id = row*8 + column)

tickets %>% 
  slice_max(seat_id)

# Part II
seats_range = min(tickets$seat_id):max(tickets$seat_id)
seats_range[! seats_range %in% tickets$seat_id]

