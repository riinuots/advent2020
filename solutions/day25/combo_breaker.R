#library(tidyverse)

card_public = 7573546
door_public = 17786549

# test
# card_public = 5764801
# door_public = 17807724

init_subject = 7
value = 1
loop_size = 0
public_keys = c(card_public, door_public)
subject_number = init_subject

trans_subject = function(){
  loop_size <<- loop_size + 1
  value <<- value*subject_number
  value <<- value %% 20201227
  if (value %in% public_keys){
    return(loop_size)
  }
  trans_subject()
}

trans_subject()
card_loopsize = trans_subject(card_public, 7)
door_loopsize = trans_subject(door_public, 7)


encryption_key = function(subject_number, loop_size, value = 1){
  for(i in 1:loop_size){
    value = value*subject_number
    value = value %% 20201227
  }
  return(value)
}
encryption_key(door_public, card_loopsize)
encryption_key(card_public, door_loopsize)

