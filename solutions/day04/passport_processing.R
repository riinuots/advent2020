library(tidyverse)

input = tibble(passports = read_file("solutions/day04/input")) %>% 
  separate_rows(passports, sep = "\n\n") %>% 
  rowid_to_column("passport_id")

passport_data = input %>% 
  separate(passports, into = paste0("var_", 1:8), sep = " |\n", fill = "right") %>% 
  pivot_longer(matches("var_")) %>% 
  select(-name) %>% 
  separate(value, into = c("variable", "value"), sep = ":") %>% 
  drop_na()

# Part I

passport_data %>% 
  arrange(variable) %>% 
  group_by(passport_id) %>% 
  summarise(variables = paste0(variable, collapse = "-")) %>% 
  filter(variables %in% c("byr-cid-ecl-eyr-hcl-hgt-iyr-pid", "byr-ecl-eyr-hcl-hgt-iyr-pid")) %>% 
  nrow()

# Part II

# a little helper to check if hair colour is a valid HEX code
is_hex = Vectorize(
  function(x){
    res <- try(col2rgb(x), silent=TRUE)
    return(!"try-error"%in%class(res))
  }
)

passport_data %>% 
  pivot_wider(names_from = "variable", values_from = "value") %>% 
  filter(between(byr, 1920, 2002) &
           between(iyr, 2010, 2020) &
           between(eyr, 2020, 2030) & 
           is_hex(hcl) &
           ecl %in% c("amb", "blu", "brn", "gry", "grn", "hzl", "oth") &
           str_detect(pid, "^[:digit:]{9}$")) %>% 
  drop_na(hcl) %>% 
  mutate(hgt_unit = str_extract(hgt, "[:alpha:]{2}$"),
         hgt = parse_number(hgt)) %>% 
  filter(
    (hgt_unit == "cm" & between(hgt, 150, 193)) |
    (hgt_unit == "in" & between(hgt,  59,  76))
    ) %>% 
  nrow()
