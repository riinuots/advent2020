library(tidyverse)

input = read_delim("solutions/day02/input", delim = ":", col_names = c("policy", "password")) %>% 
  mutate(password = str_squish(password)) # remove leading space

# Part I 
input %>% 
  separate(policy, into = c("min", "max", "letter"), sep = "-| ", convert = TRUE) %>% 
  mutate(letter_count = str_count(password, letter)) %>% 
  filter(letter_count >= min & letter_count <= max) %>% 
  nrow()

# Part II
input %>% 
  separate(policy, into = c("position1", "position2", "letter"), sep = "-| ", convert = TRUE) %>% 
  # duplicating 'position' as the arguments are start, end
  mutate(letter1 = str_sub(password, position1, position1),
         letter2 = str_sub(password, position2, position2)) %>% 
  rowid_to_column() %>% 
  # columns are doing my head in, let's make it more data sciency
  pivot_longer(matches("letter1|letter2")) %>% 
  mutate(is_match = letter == value) %>% 
  group_by(rowid) %>% 
  filter(sum(is_match) == 1) %>% 
  distinct(rowid) %>% 
  nrow()
  
