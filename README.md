Diary: Advent of Code 2020
================
  
Notes about functions/arguments I’d not come across before. And any
other thoughts. Full solutions can be found in the solutions folder.

Previous year: https://github.com/riinuots/advent2019

# Day 2 

Today I learned that `between()` from `library(dplyr)` is not currently vectorised meaning it can give unexpected/wrong results.

Little example:
```
library(tidyverse)

tibble(min = c(2, 5), max = c(3, 5), value = c(4, 5)) %>% 
  mutate(is_between = between(value, min, max))
  
#> # A tibble: 2 x 4
#>     min   max value is_between
#>   <dbl> <dbl> <dbl> <lgl>     
#> 1     2     3     4 FALSE     
#> 2     5     5     5 FALSE
```

The second row here should say TRUE - as 5 is between 5 and 5. But since `between()` is not vectorised it's maybe still looking at the min and max values from row 1: so checking it's between 2 and 3...

The GitHub version will no longer let the function run like this and [will error out](https://github.com/tidyverse/dplyr/pull/5501). In the future, the team will vectorise `between()` so it will work as expected.

Meanwhile, two work-arounds:

One to add in `rowwise()`:
```
library(tidyverse)
tibble(min = c(2, 5), max = c(3, 5), value = c(4, 5)) %>% 
  rowwise() %>% 
  mutate(is_between = between(value, min, max))
#> # A tibble: 2 x 4
#> # Rowwise: 
#>     min   max value is_between
#>   <dbl> <dbl> <dbl> <lgl>     
#> 1     2     3     4 FALSE     
#> 2     5     5     5 TRUE
```

Or to spell it out using `>=, &, <=`:
```
tibble(min = c(2, 5), max = c(3, 5), value = c(4, 5)) %>% 
  mutate(is_between = value >= min & value <= max)
```


# Day 1

In part II, used used `full_join()` to combine three duplicates of the input lists, essentially creating permutations. To achieve that using `full_join()`, you'll have to join "by" nothing: `by = character()`.

I used a `full_join()` because it's quick and easy, and worked fine for the very small number of permutations this created: 200^3 so 8 million. I could have reduced the "computational burden" by using combinations instead of permutations. But this way was easy to type in, and evaluated in 1.1 seconds. So no reason to optimise it just now. I hope this doesn't become the basis of the whole month :smiley: