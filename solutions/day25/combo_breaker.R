#library(tidyverse)

card_public = 7573546
door_public = 17786549

# test
# card_public = 5764801
# door_public = 17807724

# Part I ----

loopsize = function(public_keys, value = 1, loop_size = 0, subject_number = 7){
  while (! value %in% public_keys){
    loop_size = loop_size + 1
    value = value*subject_number
    value = value %% 20201227
  }
  return(loop_size)
}


card_loopsize = loopsize(card_public)
door_loopsize = loopsize(door_public)


encryption_key = function(subject_number, loop_size, value = 1){
  for(i in 1:loop_size){
    value = value*subject_number
    value = value %% 20201227
  }
  return(value)
}
encryption_key(door_public, card_loopsize)
encryption_key(card_public, door_loopsize)

