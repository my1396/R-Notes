## String Operations

`stringr::str_starts(string, pattern)` 

`str_detect(string, pattern)`  returns a logical vector with `TRUE` for each element of `string` that matches `pattern` and `FALSE` otherwise. 

`str_locate(string, pattern)` returns the `start` and `end` position of the first match;

```r
# match a pattern and select
data %>% 
		mutate(end = str_locate(key,"_sd")[1],
    			 name = str_sub(key, 1, end-1))
```



`str_locate_all(string, pattern)` returns the `start` and `end` position of each match.

`str_sub(string, start = 1L, end = -1L)` 	Extract substrings from a character vector.

Negative indices index from end of string.

```r
# replace substring with specific value
str_sub(string, start = 1L, end = -1L, omit_na = FALSE) <- value

# A pair of integer vectors defining the range of characters to extract
hw <- "Hadley Wickham"
str_sub(hw, start=c(1, 8), end=c(6, 14)) # select 1-6 and 8-14
#> [1] "Hadley"  "Wickham"
```



`base::substr(name, start, end)` 

`base::substring(name, start, end=1000000L)`  if not providing `end`, will subset from `start` until the end of the string.

`base::` is to specify using base R function.







