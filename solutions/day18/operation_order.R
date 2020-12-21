library(tidyverse)

# Part I ----
input = tibble(input = read_lines("solutions/day18/input")) %>% 
  mutate(calc_mod = paste0(" ", input, " ") %>% 
           str_replace_all("\\(", "( ") %>% 
           str_replace_all("\\)", " )"))


resolve_calculation = Vectorize(function(line){
  loc = 2
  line_mod = line
  n_words = str_count(line, " ")
  while (loc <= (n_words - 2)){
    while (! str_detect(word(line_mod, loc, loc + 2),
                        "[:digit:] (\\+|\\*) [:digit:]")
    ){
      if (loc >= (n_words - 2) ){
        loc = 2
      } else{
        loc = loc + 1
      }
    }  
    calculation  = word(line_mod, loc, loc + 2)
    #if (calculation == "120 + 6"){browser()}
    result = as.character(eval(parse(text = calculation)))
    line_mod = str_replace(line_mod, fixed(paste0(" ", calculation, " ")), paste0(" ", result, " "))
    
    if (str_detect(line_mod, paste0("\\( ", result, " \\)"))){
      #browser()
      line_mod = str_replace(line_mod, paste0("\\( ", result, " \\)"), result)
      loc = 2
    }
    
    n_words = str_count(line_mod, " ")
    if (n_words == 1){
      break
    }
    if (loc >= (n_words - 2) | ! str_detect(line_mod, "\\(|\\)")){
      loc = 2
    }
  }
  return(line_mod)
})

input_calculated = input %>% 
  mutate(result = resolve_calculation(calc_mod))


input_calculated %>% 
  summarise(sum(parse_number(result)))
