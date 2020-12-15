# This is really slow - 44 minutes
# I really wanted to use a hash, but the way I went with can only take valid names
# as keys, so can't be a number
# as.character() is what makes it so slow I think
# or something else I did completely wrong...
# my main solution does it in 10 seconds
input = scan("solutions/day15/input", sep = ",")

# shorthand for as.character():
chr = function(x){as.character(x)}

# Parts I and II (modified it for Part II, see previous commit)
H <- new.env()
for (location in seq_along(input)) {
  H[[as.character(input[location])]] = list(last = as.numeric(location))
}
last_value = dplyr::last(input)
start_time = Sys.time()
for (turn in (length(input) + 1):30000000){
  #turn = 8
  #print(turn)
  #print(last_value)
  if (is.null(H[[chr(last_value)]]$prev)){
    new_value = as.numeric(0)
  } else {
    new_value = H[[chr(last_value)]]$last - H[[chr(last_value)]]$prev
  }
  #print(new_value)
  H[[chr(new_value)]]$prev = H[[chr(new_value)]]$last
  H[[chr(new_value)]]$last = turn
  last_value = new_value
}
Sys.time() - start_time
print(last_value)



