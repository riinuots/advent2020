library(tidyverse)

input = tibble(instruction = read_lines("solutions/day12/input-test")) %>% 
  separate(instruction, into = c("action", "value"), sep = 1, convert = TRUE)

# check that it only turns 90/180/270  degrees at a time:
input %>% 
  filter(action %in% c("R", "L")) %>% 
  count(value)

# Part I ----

directions = tribble(
  ~dir, ~degree,
  "N",    270,
  "E",    0,
  "S",    90,
  "W",   180
)

move = function(loc, action, value, facing){
  if (action == "F"){
    #browser()
    action = filter(directions, degree == facing) %>% pull(dir)
  }
  loc$x = loc$x + value*case_when(! action %in% c("W", "E") ~ 0,
                                  action == "W"             ~ -1,
                                  action == "E"             ~  1)
  
  loc$y = loc$y + value*case_when(! action %in% c("N", "S") ~ 0,
                                  action == "S"             ~ -1,
                                  action == "N"             ~  1)
  return(loc)
}

turn = function(facing, action, value){
  new_facing = facing + if_else(action == "R", +1, -1)*value
  if (new_facing > 270){new_facing = new_facing - 360}
  if (new_facing < 0){new_facing = new_facing + 360}
  return(new_facing)
}

actions = pull(input, action)
values = pull(input, value)
for (i in 1:nrow(input)){
  print(i)
  #if (i == 12){browser()}
  #stopifnot(i < 100)
  if (i == 1){
    facing = 0
    loc = lst(x = 0, y = 0)
  }
  
  action = actions[i]
  value  = values[i]
  if (action %in% c("R", "L")){
    facing = turn(facing, action, value)
  } else if (action %in% c("N", "S", "E", "W", "F")){
    loc = move(loc, action, value, facing)
  } else{
    stop("OKOU")
  }
  #print(loc)
  if (i == nrow(input)){
    print(abs(loc$x) + abs(loc$y))
  }
}










