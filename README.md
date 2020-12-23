Diary: Advent of Code 2020
================
  
Notes about functions/arguments I’d not come across before. And any
other thoughts. Full solutions can be found in the solutions folder.

Previous year: https://github.com/riinuots/advent2019

# Day 23

Part I was cute. I like playing with this crab. Part II is repeating Part II 10 million times and on larger input. My solution would take over 300h. Simple profiling/quick ideas would probably reduce it tenfold, which is still very long. Leaving it.


# Day 22

Started off by writing a bunch of loops and filters and slices leading to `bind_rows()`, etc. While doing that the single tidyverse pipeline solution came to me. Still has a while loop for the rounds of course. Part I only.

# Day 21 

Spent some time trying to come up with a clever data-sciency pipeline with group_by, add_count, slice_max etc etc, but with no luck. Looped through allergens and that worked.
Used `library(unglue)` for the first time. 

# Day 20

I thought I was really clever in Part I - realising that I only need to identify the corners and that the input was friendly. So there were exactly 4 tiles with just 2 matching edges, which meant they had to be the corners. So I never did assemble a picture. 

Turns out Part II really did need a picture, not just corners. Anyway, one star is better than nothing.

# Day 19

Loved how much more comfortable I was with regular expressions by the end of this.


# Day 18

This was a cute one overall, although I did spend a lot of time bebugging my solution. Part I only.

# Day 15

Without even trying to solve it with simple vectors, I decided I wanted to try something new. I was alos hoping that the new thing would be superfast. I read this blog post and decided to go with the environments option: https://blog.dominodatalab.com/a-quick-benchmark-of-hashtable-implementations-in-r/
However, since the key has to be a valid R identifier (so can't be a number) it converted all numbers back and forth between characters. This meant my final solution for Part II took 44 minutes.

I then re-wrote it using vectors. Now runs in 10 seconds. But the first solution was cool nevertheless :smiley:

# Day 14

The wrangling bit was very pleasant, and I think my solution using `slice_max()` to grab the latest changes was pretty neat. No need to actually apply the changes to each location. Just keep the last one.

I did have some hassle with the 36-bit numbers, my handy friend `strtoi(..., base = 2)` can only do integers, which in R are 32-bit. And I couldn't find a similar function to do binary to numeric (which is 64-bit). So ended up just grabbing off the extra bits, doing the conversion on 32-bits, adding the extra large numbers on separately. SORRY, NOT SORRY.

Skipping Part II, getting tired. 

# Day 13

Part I was cool, but Part II is beyond me. Skipping.

# Day 12

This one is pretty cool, makes you think about coordinates and directions. I've done Part I and have a pencil&paper plan for Part II. Might finish on a later date if have time.

# Day 11

No clever ideas here, just a bunch of nested loops. For figuring out Part II, used RStudio's debugging tools with the `browser()` function a lot.

I first ran my code on a tibble just because that's what it was after wrangling. The first part took 5 minutes, by just adding ` %>% as.matrix()` to the wrangling bit, Part I ran in 20 seconds. 

How to check how long a bit runs for:
```
start_time = Sys.time()
...
Sys.time() - start_time
```

I didn't time Part II in tibble format properly, but it was about 15 minutes. On a matrix, the exact same code ran in 1 minute. Tibbles have some essential qualities, they are consistent and they work well with tidyverse functions. But after wrangling, I didn't use any tidyverse functions for this solution. So `as.matrix()` is much more appropriate.

# Day 10 

Really wasn't feeling like writing another recursive function, nor a loop. Was going to skip Part II, but after realising how friendly the input is - maximum group length is 4 - figured the possible options within group size out using pen and paper. Then a little bit of tidy wrangling, join in combinations, take product.

# Day 9

I wrote my first recursive function in about 10 years. Had huge success with it for Part I - much simpler than I feared it would be. Worked like a charm.

Wrote another recursive function for Part II, which worked for the test case but exceeded the stack limit for the real input. Thing is, recursive functions don't release stack memory until you heading back up. But my solution didn't do that, it doesn't come back up. 

One potential solution would have been to split my single recursive function into two recursive functions - one that changes the location, the other one that changes the range.

But another viable solution - and the one I ended up with - was avoiding function arguments and defining the location and range variables in the global environment. And then using `<<-` to modify these global variables directly.


# Day 8

This was a pretty standard if-elses typing exercise. At least the way I solved it. Will now head to Twitter to see what other people came up with.

# Day 7

Was able to use `library(igraph)` for the first one, but had to write a loop for Part II.

# Day 6

This was a nice data sciency day again. As usual, wrangling your data into the right format is half the battle. I wrangled the input into a tidy format with my usual best friends: `separate()` and `separate_rows()`. It helped that the format was very similar to Day 4.

Then some grouping, counting and filtering to answer both parts.

# Day 5

This was short and sweet - no need to try and step through the rows/columns, as the name of the puzzle hints, the row and column locations were given as binary numbers. R's function for binary to decimal is `strtoi(..., base = 2)`.

# Day 4

This was a pure data wrangling and cleaning problem so very convenient in R and tidyverse. Thinking I need to figure out the regular expression for `# followed by exactly six characters 0-9 or a-f` phased me for a second, until I realised this is a HEX code. So I searched online for "R hex code checker", which is a built in function. No regular expressions needed for this one.

# Day 3

To solve this one - a forest patch that repeats periodically - module operations/remainders are needed. I never encounter modulos in my work, the only reason I knew this is what to do is because I also did Advent of Code last year. In short, I only use the modulo operator (`%%`) in December :smiley:

The tricky bit to Part II was integer overflow: the result was just too big to be an integer. But the exact same number was fine as a double. So adding `as.numeric()` solved the integer overflow error.

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