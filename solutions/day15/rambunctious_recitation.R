# Same solution for Parts I and II
input = scan("solutions/day15/input", sep = ",") + 1

n_turns = 30000000
starting = length(input) + 1
last_spoken = rep(NA_integer_, n_turns)
prev_spoken = rep(NA_integer_, n_turns)
last_spoken[input] = seq_along(input)

last_number = input[starting-1]
for (turn in starting:n_turns){
  if (is.na(prev_spoken[last_number])){
    new_number = 0 + 1 # just so I remember..
  } else {
    new_number = last_spoken[last_number] - prev_spoken[last_number] + 1
  }
  prev_spoken[new_number] = last_spoken[new_number]
  last_spoken[new_number] = turn
  last_number = new_number
}
print(last_number-1)


