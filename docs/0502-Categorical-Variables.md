## Categorical Variables

### Manipulate String Columns

`reg_dict %>% mutate(def = sapply(strsplit(def,"\\."), "[[", 2) )` split a string column and select the 2nd item.

```r
# alternatively, use separate(def, into, sep, remove=TRUE)
reg_dict %>% separate(def, c("cli_key", "yr_key"), ".")
```

`separate()` function does the opposite of `unite()`: it splits one column into multiple columns using either a regular expression or character positions.

```r
world_separate = world_unite %>% 
  separate(con_reg, c("continent", "region_un"), sep = ":")
```

`unite()`  <span style='color:#008B45'>pastes</span> together existing string columns.

```r
world_unite = world %>%
  unite("con_reg", continent:region_un, sep = ":", remove = TRUE)
# remove indicates if the original columns should be removed
```

--------------------------------------------------------------------------------

### Factors

`forcats` is one of the components package in tidyverse; it is useful for working with categorical variables (factors). 

- `fct_expand`: add additional levels to a factor.
- `fct_drop`: drop unused levels.
- `fct_relevel`: change the order of a factor by hand.


`fct_expand(f, ..., after = Inf)` add additional levels to a factor.

- `f` 	a factor
- `...`     additional levels to add to the factor.
- `after` position to place the new level(s).

```r
f <- factor(sample(letters[1:3], 20, replace = TRUE))
f
#>  [1] c a b a b b a c c b b b b c c c a b b c
#> Levels: a b c
fct_expand(f, "d", "e", "f")
#>  [1] c a b a b b a c c b b b b c c c a b b c
#> Levels: a b c d e f
fct_expand(f, letters[1:6])
#>  [1] c a b a b b a c c b b b b c c c a b b c
#> Levels: a b c d e f
fct_expand(f, "Z", after = 0)
#>  [1] c a b a b b a c c b b b b c c c a b b c
#> Levels: Z a b c
```

`fct_drop(f, only = NULL)` drop unused levels.

```R
f <- factor(c("a", "b"), levels = c("a", "b", "c"))
f
#> [1] a b
#> Levels: a b c
fct_drop(f)
#> [1] a b
#> Levels: a b

# Set only to restrict which levels to drop
fct_drop(f, only = "a")
#> [1] a b
#> Levels: a b c
fct_drop(f, only = "c")
#> [1] a b
#> Levels: a b
```


