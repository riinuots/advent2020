library(tidyverse)

input = tibble(trees = read_lines("solutions/day03/input")) %>% 
  rowid_to_column()

check = input %>%
  separate(trees, into = c(NA, paste0("loc", 0:10)), sep = "")

# Part I
locations = seq(0, length.out = nrow(input), by = 3)
input %>% 
  mutate(location = locations) %>% 
  separate_rows(trees, sep = "") %>% 
  group_by(rowid) %>% 
  mutate(column_id = seq_along(rowid) - 1) %>% 
  ungroup() %>% 
  # using modulo operator (%%) to see where it lands in each repeat batch:
  # (lots of playing around with +-1 and brackets happened before got to the right answer)
  mutate(location_remainder = if_else(location <= max(column_id),
                                      location,
                                      location %% (max(column_id) + 1))) %>% 
  filter(location_remainder == column_id &  trees == "#") %>% 
  nrow()


# Part II

get_slope_trees = function(step_right = 1, step_down = 2){
  
  locations_rows = seq(1, to = nrow(input), by = step_down)
  locations      = seq(0, length.out = length(locations_rows), by = step_right)
  
  input %>% 
    filter(rowid %in% locations_rows) %>% # only new line to this pipeline compared with Part I
    mutate(location = locations) %>% 
    separate_rows(trees, sep = "") %>% 
    group_by(rowid) %>% 
    mutate(column_id = seq_along(rowid) - 1) %>% 
    ungroup() %>% 
    mutate(location_remainder = if_else(location <= max(column_id),
                                        location,
                                        location %% (max(column_id) + 1))) %>% 
    filter(location_remainder == column_id &  trees == "#") %>% 
    nrow() %>% 
    # and this as integers are 32-bit, doubles 64-bit
    as.numeric()
}
# changing scipen option so it prints all digits not scientific notation:
options(scipen = 999)
get_slope_trees(1, 1) * 
get_slope_trees(3, 1) *
get_slope_trees(5, 1) *
get_slope_trees(7, 1) *
get_slope_trees(1, 2)
