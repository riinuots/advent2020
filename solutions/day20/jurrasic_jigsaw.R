library(tidyverse)

input = tibble(tiles = read_lines("solutions/day20/input"))

# Part I only ----

n_columns = str_count(input$tiles[2])

tiles = input %>% 
  mutate(id = parse_number(tiles)) %>% 
  fill(id, .direction = "down") %>% 
  filter(str_detect(tiles, "\\.|#")) %>% 
  group_by(id) %>% 
  mutate(row = row_number()) %>% 
  separate(tiles, into = c(NA, paste0("col_", 1:n_columns)), sep = "") %>% 
  pivot_longer(contains("col_"), names_to = "col") %>% 
  mutate(col = parse_number(col))

n_rows = max(tiles$row)

# Part I ---- 
edge1 = tibble(row = 1,        col = 1:n_columns, edge_id = 1) # North
edge2 = tibble(row = 1:n_rows, col = n_columns,   edge_id = 2) # East
edge3 = tibble(row = n_rows,   col = 1:n_columns, edge_id = 3) # South
edge4 = tibble(row = 1:n_rows, col = 1,           edge_id = 4) # West

edge_indexes = bind_rows(edge1, edge2) %>% 
  bind_rows(edge3) %>% 
  bind_rows(edge4)
rm(edge1, edge2, edge3, edge4)

edges = tiles %>% 
  left_join(edge_indexes) %>% 
  drop_na() %>% 
  arrange(id, edge_id, row, col) %>% 
  group_by(id, edge_id) %>% 
  summarise(pattern = paste(value, collapse = "")) %>% 
  ungroup() %>% 
  mutate(pattern_rev = stringi::stri_reverse(pattern)) %>% 
  pivot_longer(contains("pattern"), names_to = "drop", values_to = "pattern") %>% 
  # don't know why fct_anon() doesn't work here...
  mutate(pattern_id = factor(pattern) %>% as.numeric()) %>% 
  # each edge has no more than 1 match: (n = 2)
  add_count(pattern_id, "n_matches") %>% 
  group_by(id) %>% 
  mutate(matching_edges = sum(n > 1)/2) %>% 
  ungroup()

options(scipen = 999)
edges %>% 
  filter(matching_edges == 2) %>% 
  distinct(id) %>% 
  summarise(result = prod(id)) %>% 
  pull(result)
  

# Part II ----

corners = edges %>% 
  filter(matching_edges == 2) %>% 
  distinct(id, edge_id, pattern_id)


other_tiles = edges %>% 
  filter(matching_edges > 2, n > 1) %>% 
  distinct(id, edge_id, pattern_id)


