library(tidyverse)
library(R.utils)

input = tibble(programs = read_lines("solutions/day14/input")) %>% 
  separate(programs, into = c("component", "value"), sep = " = ") %>% 
  separate(component, into = c("component", "mem_location"), sep = "\\[", fill = "right") %>% 
  mutate(program_id = if_else(component == "mask", row_number(), NA_integer_)) %>% 
  fill(program_id, .direction = "down")

# all of this is input wrangling
masks = input %>% 
  filter(component == "mask") %>% 
  select(-mem_location, -component) %>% 
  separate_rows(value, sep = "") %>% 
  group_by(program_id) %>% 
  mutate(location = row_number()) %>% 
  ungroup() %>% 
  arrange(program_id) %>% 
  filter(value != "X") %>% 
  rename(mask = value)

mems = input %>% 
  filter(component == "mem") %>% 
  rowid_to_column("mem_id") %>% 
  select(-component) %>% 
  mutate_at(c("mem_location", "value"), parse_number) %>% 
  mutate(value_binary = intToBin(value) %>% 
           str_pad(width = 36, side = "left", pad = "0")) %>% 
  separate_rows(value_binary, sep = "") %>% 
  group_by(mem_id) %>% 
  mutate(location = row_number()) %>% 
  ungroup() %>% 
  arrange(program_id)

# Part I ----

options(scipen = 999)
mems %>% 
  left_join(masks) %>% 
  mutate(value_binary = if_else(is.na(mask), value_binary, mask)) %>% 
  group_by(mem_id, mem_location) %>% 
  summarise(value_binary = paste0(value_binary, collapse = "")) %>% 
  # strtoi() can only do up to 32 bits, not 36...
  # couldn't find a function to do binary to numeric (64-bit)
  # so manually removed the extra bits, calculated their contributions
  # added them back on
  # SORRY, NOT SORRY
  mutate(vb36 = str_sub(value_binary, 1, 1)) %>% 
  mutate(vb35 = str_sub(value_binary, 2, 2)) %>% 
  mutate(vb34 = str_sub(value_binary, 3, 3)) %>% 
  mutate(vb33 = str_sub(value_binary, 4, 4)) %>% 
  mutate(vb32 = str_sub(value_binary, 5, 5)) %>% 
  mutate_at(vars(contains("vb")), parse_number) %>% 
  mutate(value_top = vb36*2^35 + vb35*2^34 + vb34*2^33 + vb33*2^32 + vb32*2^31) %>% 
  mutate(value_binary321 = str_sub(value_binary, 6, 36)) %>% 
  mutate(value = strtoi(value_binary321, base = 2) %>% as.numeric() + value_top) %>% 
  group_by(mem_location) %>% 
  slice_max(mem_id) %>% 
  ungroup() %>% 
  summarise(result = sum(value)) %>% 
  pull(result)
  


