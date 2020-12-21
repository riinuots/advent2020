library(tidyverse)
library(glue)
library(unglue)
options(dplyr.summarise.inform = FALSE)

input = tibble(food = read_lines("solutions/day21/input"))

# Part I ----

foods = input %>% 
  separate(food, into = c("ingredient", "allergen"), sep = "\\(contains ") %>% 
  rowid_to_column("food_id") %>% 
  separate_rows(ingredient, sep = " ") %>% 
  separate_rows(allergen, sep = ",.") %>% 
  mutate(allergen = str_remove(allergen, "\\)" %>% str_trim())) %>% 
  mutate(alg_ingr = glue("{allergen}-{ingredient}"))


results = tibble(alg_ingr = NA_character_, always_present = NA)
alg_pairs = unique(foods$alg_ingr)
c = 0
for (try in alg_pairs){
  if (c %% 100 == 0){print(c)}
  c = c + 1
  #print(try)
  #try = "dairy-sbzzf"
  looking_at = unglue_data(try, "{allergen}-{ingredient}")
  try_result = foods %>% 
    filter(allergen == looking_at$allergen) %>% 
    group_by(food_id) %>% 
    summarise(exist_infood = looking_at$ingredient %in% ingredient, .group = "drop") %>% 
    ungroup() %>% 
    summarise(always_present = all(exist_infood), .group = "drop") %>% 
    pull(always_present)
  
  results = results %>% 
    add_row(alg_ingr = try, always_present = try_result)
}

must_contain = results %>% 
  drop_na() %>% 
  separate(alg_ingr, into = c("allergen", "ingredient"), sep = "-") %>% 
  filter(always_present) %>% 
  distinct(ingredient) %>% 
  pull(ingredient)

foods %>% 
  filter(! ingredient %in% must_contain) %>% 
  distinct(food_id, ingredient) %>% 
  nrow()

# Part II ----

must_contain = results %>% 
  drop_na() %>% 
  separate(alg_ingr, into = c("allergen", "ingredient"), sep = "-") %>% 
  filter(always_present)


dangerous_list = must_contain %>% 
  add_count(ingredient) %>% 
  filter(n == 1)
remain = must_contain %>% 
  filter(! ingredient %in% dangerous_list$ingredient) %>% 
  filter(! allergen %in% dangerous_list$allergen)

while (nrow(remain) > 0){
  remain = must_contain %>% 
    filter(! ingredient %in% dangerous_list$ingredient) %>% 
    filter(! allergen %in% dangerous_list$allergen)
  
  dangerous_list = remain %>% 
    add_count(ingredient) %>% 
    filter(n == 1) %>% 
    bind_rows(dangerous_list)
  
}
dangerous_list %>% 
  arrange(allergen) %>% 
  summarise(result = paste(ingredient, collapse = ",")) %>% 
  pull(result)
