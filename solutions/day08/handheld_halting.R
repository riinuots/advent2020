library(tidyverse)


input = tibble(instruction = read_lines("solutions/day08/input")) %>% 
  separate(instruction, into = c("operation", "argument"), sep = " ", convert = TRUE)

# Part I
accumulator = 0
location = 1
input$ran = FALSE
while (TRUE){
  op = input$operation[location]
  ar = input$argument[location]
  if(input$ran[location]){return(print(accumulator))}
  
  if(op == "acc"){
    accumulator = accumulator + ar
    input$ran[location] = TRUE
    location = location + 1
  } else if (op == "jmp"){
    input$ran[location] = TRUE
    location = location + ar
  } else if (op == "nop"){
    input$ran[location] = TRUE
    location = location + 1
  } else {
    stop(paste("unknown command found:", op))
  }
  
}

# Part II 
# very similar to Part I: copied into a function and included a case_when for change:
program = function(input, change = NA){
  accumulator = 0
  location = 1
  input$ran = FALSE
  while (TRUE){
    op = input$operation[location]
    ar = input$argument[location]
    if (location == change & op %in% c("jmp", "nop")){
      op = case_when(op == "jmp" ~ "nop",
                     op == "nop" ~ "jmp",
                     TRUE ~ "fault")
    }
    if(location > nrow(input)){return(accumulator)}
    if(input$ran[location]){return("Not a fix")}
    if(op == "acc"){
      accumulator = accumulator + ar
      input$ran[location] = TRUE
      location = location + 1
    } else if (op == "jmp"){
      input$ran[location] = TRUE
      location = location + ar
    } else if (op == "nop"){
      input$ran[location] = TRUE
      location = location + 1
    } else {
      stop(paste("unknown command found:", op))
    }
    
  }}


potential_fixes = input %>% 
  rowid_to_column() %>% 
  filter(operation %in% c("jmp", "nop")) %>% 
  pull(rowid)

# loop through potential fixes:
for (mychange in potential_fixes){
  result = program(input, change = mychange)
  if (result == "Not a fix"){
    next
  } else{
    print(result)
    break
  }
}



