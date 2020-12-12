library(tidyverse)

input_orig = tibble(seats = read_lines("solutions/day11/input"))

width = input_orig$seats[1] %>% str_count(".")
height = nrow(input_orig)


input = input_orig %>% 
  add_row(seats = paste0(rep(".", width), collapse = ""), .before = 1) %>% 
  add_row(seats = paste0(rep(".", width), collapse = "")) %>% 
  mutate(seats = paste0(".", seats, ".")) %>% 
  separate(seats, into = c(NA, paste0("column", 1:(width+2))), sep = "") %>% 
  as.matrix()

# Part I ----
people_move = function(mylayout){
  changes =  0
  current_layout = mylayout
  new_layout = mylayout
  for (i in 2:(height+1)){
    #print("i:")
    #print(i)
    for (j in 2:(width+1)){
      #print("j:")
      #print(j)
      #browser()
      myseat = current_layout[i, j]
      if (myseat == "."){next}
      adjacent_seats = current_layout[(i-1):(i+1), (j-1):(j+1)]
      n_filled = sum(adjacent_seats == "#") - if_else(myseat == "#", 1, 0)
      
      if (myseat == "L" & n_filled == 0){
        #print(paste("changing seat at ", mylocation, "from", myseat, "to #"))
        new_layout[i, j] = "#"
        changes = changes + 1
      } else if (myseat == "#" & n_filled >= 4 ){
        #print(paste("changing seat at ", mylocation, "from", myseat, "to L"))
        new_layout[i, j] = "L"
        changes = changes + 1
      } else {
        next
      }
      
    }}
  return(lst(changes, new_layout))
}
n_times = 0
start_time = Sys.time()
while (TRUE){
  print(n_times)
  if (n_times == 0){
    layout = people_move(input)
    n_times = 1
  } else{
    layout = people_move(layout$new_layout)
    n_times = n_times + 1
  }
  #print(layout)
  if (layout$changes == 0){
    sum(layout$new_layout == "#") %>% print()
    break
  }
  #if (n_times > 5){break}
}
Sys.time() - start_time

# Part II ----

directions = tribble(
  ~dir, ~di, ~dj,
  "N",   -1,   0,
  "NE",  -1,   1,
  "E",    0,   1,
  "SE",   1,   1,
  "S",    1,   0,
  "SW",   1,  -1,
  "W",    0,  -1,
  "NW",  -1,  -1
)

people_move2 = function(mylayout){
  changes =  0
  current_layout = mylayout
  new_layout = mylayout
  for (i in 2:(height+1)){
    #print("i:")
    #print(i)
    for (j in 2:(width+1)){
      #print("j:")
      #print(j)
      #browser()
      myseat = current_layout[i, j]
      if (myseat == "."){next}
      
      adjacent_seats = NULL
      for (dir in 1:8){
        #print("dir:")
        #print(dir)
        try = 1
        while (TRUE){
          #if (i == 2 & j == 2 & dir == 6 & try == 2){browser()}
          #print("try:")
          #print(try)
          myi = i + try*directions$di[dir]
          myj = j + try*directions$dj[dir]
          #print("looking_at:")
          #print(looking_at)
          
          if (myi < 1 | myj < 1 | myi > nrow(current_layout) | myj > ncol(current_layout)){
            adjacent_seats = c(adjacent_seats, ".")
            break
          } else if (current_layout[myi, myj] %in% c("L", "#")){
            adjacent_seats = c(adjacent_seats, current_layout[myi, myj])
            break
          } else{
            try = try + 1
            #if (try > 13){browser()}
          }
        }
      }
      
      
      n_filled = sum(adjacent_seats == "#")
      #browser()
      if (myseat == "L" & n_filled == 0){
        #print(paste("changing seat at ", mylocation, "from", myseat, "to #"))
        new_layout[i, j] = "#"
        changes = changes + 1
      } else if (myseat == "#" & n_filled >= 5){
        #print(paste("changing seat at ", mylocation, "from", myseat, "to L"))
        new_layout[i, j] = "L"
        changes = changes + 1
      } else {
        next
      }
      
    }}
  return(lst(changes, new_layout))
}

n_times = 0
start_time = Sys.time()
while (TRUE){
  print(n_times)
  if (n_times == 0){
    #print(input)
    layout = people_move2(input)
    n_times = 1
  } else{
    layout = people_move2(layout$new_layout)
    n_times = n_times + 1
  }
  #print(layout)
  if (layout$changes == 0){
    sum(layout$new_layout == "#") %>% print()
    break
  }
  #if (n_times > 2){break}
}
Sys.time() - start_time
