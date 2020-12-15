library(tidyverse)

input = scan("solutions/day15/input-test", sep = ",")
chr = function(x){as.character(x)}

H <- new.env()
for (location in seq_along(input)) {
  H[[as.character(input[location])]] = location
}
last_value = last(input)
start_time = Sys.time()
for (turn in (length(input) + 1):2020){
  #turn = 5
  #print(turn)
  previous_locations = H[[chr(last_value)]]
  if (length(previous_locations) == 1){
    new_value = 0
    
  } else {
    new_value = last(previous_locations) - nth(previous_locations, -2)
  }
  #print(new_value)
  H[[chr(new_value)]] = c(last(H[[chr(new_value)]]), turn)
  last_value = new_value
}
Sys.time() - start_time
print(last_value)



