library(tidyverse)

input = tibble(input = read_lines("solutions/day13/input")) %>% 
  mutate(type = c("mytime", "schedule")) %>% 
  separate_rows(input, sep = ",")

# Part I ----

mytime = input %>% 
  filter(type == "mytime") %>% 
  pull(input) %>% 
  parse_number()

buses = input %>% 
  filter(input != "x") %>% 
  mutate(input = parse_number(input)) %>% 
  filter(type == "schedule") %>% 
  rename(id = input)

mybus = buses %>% 
  mutate(waiting_time = -1*((mytime %% id) - id)) %>% 
  slice_min(waiting_time)

mybus$id*mybus$waiting_time


# Part II --- not working

# I mean, it runs but would probably take thousands of years to reach the answer

first_bus = input %>% 
  filter(type == "schedule") %>% 
  slice(1) %>% 
  pull(input) %>% 
  parse_number()

buses = input %>% 
  mutate(input = parse_number(input)) %>% 
  filter(type == "schedule") %>% 
  select(id = input) %>% 
  mutate(rule = row_number() - 1) %>% 
  slice(-1) %>% 
  drop_na()

n = 1
while (TRUE){
  if (n %% 1000 == 0){print(n)}
  try = buses %>% 
    mutate(t = n*first_bus) %>% 
    mutate(diff = ceiling(t/id)*id %% t) %>% 
    mutate(compliant = rule == diff)
  
  
  if (all(try$compliant)){
    print(n)
    break
  } else{
      n = n + 1
    }
}



