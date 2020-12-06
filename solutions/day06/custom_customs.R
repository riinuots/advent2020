library(tidyverse)

input = tibble(forms = read_file("solutions/day06/input"))
answers = input %>% 
  separate_rows(forms, sep = "\n\n") %>% 
  rowid_to_column("group") %>% 
  separate_rows(forms, sep = "\n") %>% 
  rename(answers = forms) %>% 
  # seq_along() to give each form a person ID
  # before splitting into individual answers:
  group_by(group) %>% 
  mutate(person = seq_along(group)) %>% 
  separate_rows(answers, sep = "") %>% 
  rename(answer = answers) %>% 
  select(group, person, answer)

# Part I 
answers %>% 
  distinct(group, answer) %>% 
  nrow()

# Part II
answers %>% 
  group_by(group, answer) %>% 
  mutate(n = n()) %>% 
  group_by(group) %>% 
  filter(n == max(person)) %>% 
  distinct(group, answer) %>% 
  nrow()



