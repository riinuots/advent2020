library(tidyverse)
options(dplyr.summarise.inform = FALSE)

input = tibble(instruction = read_lines("solutions/day24/input")) %>% 
  rowid_to_column("id") %>% 
  mutate(instructions = str_extract_all(instruction, "ne|se|sw|nw|e|w"))

instructions = input %>% 
  unnest(instructions) %>% 
  select(id, move = instructions)

moves = tribble(
  ~move,  ~dx, ~dy, ~dz,
  "e",     1,  -1,   0,
  "se",    0,  -1,   1,
  "sw",   -1,   0,   1,
  "w",    -1,   1,   0,
  "nw",    0,   1,  -1,
  "ne",    1,   0,  -1
)

# Part I ----
tiles = left_join(instructions, moves) %>% 
  group_by(id) %>% 
  summarise(across(starts_with("d"), sum)) %>% 
  group_by(dx, dy, dz) %>% 
  mutate(n_visits = row_number()) %>% 
  slice_max(n_visits) %>% 
  ungroup()

count(tiles, black = n_visits %% 2 == 1)

# Part II ----

current_black = tiles %>% 
  mutate(black = n_visits %% 2 == 1) %>% 
  filter(black) %>% 
  select(x = dx, y = dy, z = dz, black) %>% 
  rowwise() %>% 
  mutate(id = paste(x, y, z, collapse = "")) %>% 
  ungroup()

for (i in 1:100){
  print(i)

  neighbours = left_join(current_black, moves, by = character()) %>% 
    mutate(nx = x + dx,
           ny = y + dy,
           nz = z + dz) %>% 
    select(x = nx, y = ny, z = nz) %>% 
    distinct(x, y, z) %>% 
    rowwise() %>% 
    mutate(id = paste(x, y, z, collapse = "")) %>% 
    filter(! id %in% current_black$id) %>% 
    mutate(black = FALSE)
  
  looking_at = bind_rows(current_black, neighbours) %>% 
    select(-id)
  
  # nx - neighbour x
  # .c - current
  # .n - neighbour
  
  new_black = looking_at %>% 
    left_join(moves, by = character()) %>% 
    mutate(nx = x + dx,
           ny = y + dy,
           nz = z + dz) %>% 
    left_join(current_black, by = c("nx" = "x", "ny" = "y", "nz" = "z"), suffix = c(".c", ".n")) %>% 
    replace_na(list(black.n = FALSE)) %>% 
    group_by(x, y, z, black.c) %>% 
    summarise(n_black = sum(black.n)) %>% 
    mutate(black = case_when(
      black.c     & (n_black == 0 | n_black > 2) ~ FALSE, # flip to white
      (! black.c) & n_black == 2                 ~ TRUE,  # flip to black
      TRUE ~ black.c)) %>% # keep current colour
    filter(black) %>% 
    select(x, y, z, black) %>% 
    rowwise() %>% 
    mutate(id = paste(x, y, z, collapse = "")) %>% 
    ungroup()
  
  current_black = new_black
  
}

nrow(current_black)


