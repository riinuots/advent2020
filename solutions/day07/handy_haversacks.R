library(tidyverse)
library(igraph)


input = tibble(rule = read_lines("solutions/day07/input")) %>% 
  separate(rule, into = c("outer", "content"), sep = " bags contain") %>% 
  separate_rows(content, sep = ",") %>% 
  # drop those that don't contain any other bags:
  filter(content != " no other bags.") %>% 
  # extract number
  extract(content, into = c("quantity", "content"), regex = "([[:digit:]]+) (.*)", convert = TRUE) %>% 
  mutate(content = str_remove_all(content, "bags|bag|\\.") %>% str_trim())

# Part I
bags_distances = input %>% 
  select(from = content, to = outer) %>% 
  graph_from_data_frame(directed = TRUE) %>% 
  distances(to = "shiny gold", mode = "in")

bags_distances[bags_distances > 0 & is.infinite(bags_distances)] %>%
  length()

# Part II
get_content = function(current_bag){
  input %>% 
    filter(outer == current_bag) %>% 
    uncount(quantity) %>% 
    pull(content)
}

no_content = input %>% 
  filter(! content %in% outer) %>% 
  distinct(content) %>% 
  pull(content)

# initialise content/bag counts:
current_bag = "shiny gold"
current_content = get_content("shiny gold")
bags = length(current_content)

while (length(current_content) != 0){
  new_content = NULL
  for (current_bag in current_content){
    if (current_bag %in% no_content){next}
    new_content = c(new_content, get_content(current_bag))
  }
  bags = bags + length(new_content)
  current_content = new_content
}
bags


