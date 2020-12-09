library(tidyverse)

input = scan("solutions/day09/input")

# Part I ----
check_sum = function(preamble_length = 5, current_location = preamble_length + 1){
  result     = input[current_location]
  stopifnot(current_location <= length(input))
  leading = input[(current_location-preamble_length-1):(current_location-1)]
  addends = leading[(result - leading) %in% leading]
  # exclude addends that are exactly half of the result
  final_addends = addends[addends != result/2]
  
  # do we have a result?
  if (length(final_addends) == 0){return(result)}
  # if not, go again:
  check_sum(preamble_length, current_location + 1)
}

check_sum(25)

# Part II ----

# using global variables instead of function arguments:
# (as otherwise exceed stack limit with recursive arguments)
starting_location = 1
current_location  = starting_location + 1
result            = check_sum(25)
addends_sum       = 0

check_contiguous = function(){
  print(paste("starting_location:", starting_location))
  print(paste("current_location:", current_location))
  # note the <<- for assignment into the global environment
  # this ensures each function does not add to the stack with its own version of this variable
  addends_sum <<- sum(input[starting_location:current_location])
  if (addends_sum == result){
    return(sum(range(input[starting_location:current_location])))
  } else if (addends_sum < result){
    starting_location <<- starting_location
    current_location <<- current_location + 1
    check_contiguous()
  } else if (addends_sum > result){
    starting_location <<- starting_location + 1
    check_contiguous()
  }  else{
    stop("okou, this shouldn't happen")
  }
}
check_contiguous()
