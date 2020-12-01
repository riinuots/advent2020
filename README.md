Diary: Advent of Code 2020
================
  
Notes about functions/arguments I’d not come across before. And any
other thoughts. Full solutions can be found in, e.g., `01.R`, `02.R`,
etc.

Previous year: https://github.com/riinuots/advent2019

# Day 1

In part II, used used `full_join()` to combine three duplicates of the input lists, essentially creating permutations. To achieve that using `full_join()`, you'll have to join "by" nothing: `by = character()`.

I used a `full_join()` because it's quick and easy, and worked fine for the very small number of permutations this created: 200^3 so 8 million. I could have reduced the "computational burden" by using combinations instead of permutations. But this way was easy to type in, and evaluated in 1.1 seconds. So no reason to optimise it just now. I hope this doesn't become the basis of the whole month :D 

