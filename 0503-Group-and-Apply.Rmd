## Group and Apply Functions

### `group_by()`

`group_by` grouping *doesn't change how the data looks*, it changes how it acts with the other dplyr verbs.

```r
by_cyl <- mtcars %>% group_by(cyl)
# conflict with plyr, specify which to use
summarise <- dplyr::summarise
summarize <- dplyr::summarize
by_cyl %>% 
    summarise(
        disp = mean(disp),
        hp = mean(hp),
        count = n() # count the size of each group
        )
# A tibble: 3 × 4
    cyl  disp    hp count
  <dbl> <dbl> <dbl> <int>
1     4  105.  82.6    11
2     6  183. 122.      7
3     8  353. 209.     14
```

`n()` gives the current group size. Only works inside `summarise()`.

<span class="env-green">**Information about the "current" group or variable**</span>

These functions return information about the "current" group or "current" variable, so only work inside specific contexts like `summarise()` and `mutate()`.

- `n()` gives the current group size.

  > Error in `n()`:
  > ! Must only be used inside data-masking verbs like `mutate()`, `filter()`, and
  > `group_by()`.

  Cause: R’s confused with which summarize function (`dplyr` vs. `plyr`) it should use.

  Fix: Explicitly specify `dplyr::summarise()`

- `cur_group()` gives the group keys, a tibble with one row and one column for each grouping variable.

  Equivalent to `.BY` in `data.table`.

- `cur_group_id()` gives a unique numeric identifier for the current group.

  Equivalent to `.GBP` in `data.table`.

- `cur_group_rows()` gives the row indices for the current group.

  Equivalent to `.I` in `data.table`.

- `cur_column()` gives the name of the current column (in `across()` only).

```r
# prioritize functions in `dplyr` to avoid conflicts with `plyr`
> needs::prioritize(dplyr)
> by_cyl %>% mutate(id = cur_group_id())
# A tibble: 32 × 12
# Groups:   cyl [3]
     mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb    id
   <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <int>
 1  21       6  160    110  3.9   2.62  16.5     0     1     4     4     2
 2  21       6  160    110  3.9   2.88  17.0     0     1     4     4     2
 3  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1     1
 4  21.4     6  258    110  3.08  3.22  19.4     1     0     3     1     2
 5  18.7     8  360    175  3.15  3.44  17.0     0     0     3     2     3
 6  18.1     6  225    105  2.76  3.46  20.2     1     0     3     1     2
 7  14.3     8  360    245  3.21  3.57  15.8     0     0     3     4     3
 8  24.4     4  147.    62  3.69  3.19  20       1     0     4     2     1
 9  22.8     4  141.    95  3.92  3.15  22.9     1     0     4     2     1
10  19.2     6  168.   123  3.92  3.44  18.3     1     0     4     4     2
# ℹ 22 more rows
# ℹ Use `print(n = ...)` to see more rows

> by_cyl %>% summarise(id = cur_group_id())
# A tibble: 3 × 2
    cyl    id
  <dbl> <int>
1     4     1
2     6     2
3     8     3

> by_cyl %>% summarise(data = cur_group())
# A tibble: 3 × 2
    cyl data$cyl
  <dbl>    <dbl>
1     4        4
2     6        6
3     8        8
```



```r
> df <- tibble(
    g = sample(rep(letters[1:3], 1:3)),
    x = runif(6),
    y = runif(6)
		)
> gf <- df %>% group_by(g)
> gf
# A tibble: 6 × 3
# Groups:   g [3]
  g          x     y
  <chr>  <dbl> <dbl>
1 b     0.0246 0.143
2 c     0.478  0.415
3 a     0.758  0.414
4 c     0.216  0.369
5 c     0.318  0.152
6 b     0.232  0.139

# get row indices for the current group
> gf %>% reframe(row=cur_group_rows())
# A tibble: 6 × 2
  g       row
  <chr> <int>
1 a         3
2 b         1
3 b         6
4 c         2
5 c         4
6 c         5
```

`group_by` then count `non-NA` values

```r
gdp_df %>% group_by(year) %>% summarise_all(~ sum(!is.na(.)))
```

`group_split()` split `data.frame` by groups, good friend with `group_by`, i.e. it used grouping structure from `group_by()` and therefore  is subject to the data mask. 

It returns a list of tibbles. Each tibble contains the rows of `.tbl` for the associated group and all the columns, including the grouping variables.

```r
ir <- iris %>%
	group_by(Species) 

# returns a list of groups
ir %>% group_split()

# returns a tibble of group keys
ir %>% group_keys()
# A tibble: 3 x 1
  Species   
  <fct>     
1 setosa    
2 versicolor
3 virginica 

# get group_keys() with index, so you can access each specific group with group info
df %>% group_by(ID) %>% group_keys() %>% as.data.frame() %>% t()
df %>% group_by(ID) %>% group_keys() %>% pull(Species)

# assgin a index column to indicate the group number
df %>% group_by(ID) %>% group_keys() %>% mutate(id = row_number())
# equivalently
df %>% group_by(ID) %>% group_keys() %>% mutate(id = 1:n() )
```



Group by and count the number of observations in each group with `tally`

```r
# count the number of rows per group
ir %>% tally(sort=TRUE) #  same as ir %>% summarize(count=n())
# A tibble: 3 × 2
  Species        n
  <fct>      <int>
1 setosa        50
2 versicolor    50
3 virginica     50
```


`dplyr::row_number(x)`  gives every input a unique rank to a vector `x`, so that `c(10, 20, 20, 30)` would get ranks `c(1, 2, 3, 4)`. From smallest to largest.

- To rank by multiple columns at once, supply a data frame `x`.

  Rank by value, ascending:

  ```r
  data %>% mutate(rank = row_number(value) )
  ```

- If want descending, use `row_number(desc(.)`

  ```r
  data %>% mutate(rank = row_number(desc(value) ) )
  # equivalently, with a - before value
  data %>% mutate(rank = row_number(-value) )
  ```

- Another use is to add row number to a data frame.

  Here, we assign row number to a variable or column name “row_id”.

  ```r
  data %>% mutate(row_id = row_number())
  ```

  

### Subset rows

- `slice_head(.data, n)` and `slice_tail(.data, n)` select the first or last `n` rows in `.data`.
- `slice_sample()` randomly selects rows.
- `slice_min(.data, order_by, n)` and `slice_max()` select rows with the smallest or largest values of a variable.



```r
# Similar to head(mtcars, 1):
mtcars %>% slice(1L)
# first two rows every group
df %>% group_by(group) %>% slice_head(n = 2)
# first row
mtcars %>% filter(row_number() == 1L)
# last row
mtcars %>% filter(row_number() == n())
# Rows with minimum values of a variable
mtcars %>% slice_min(mpg, n = 5) 
```



### Summarize

Scoped verbs (`summarize_if`, `summarize_at`, `summarize_all`) have been superseded by the use of `across(.var, .fun)` inside `summarize()`. 

`summarize_at(.tbl, .var, .fun, ...)` $\rightarrow$ `summarize(.tbl, across(.var, .fun) )`

-    `.tbl` 	a `tbl` object, eg. a groupped `tibble`	
-    `.var`      A list of columns generated by vars(), a `character` vector of column names, a `numeric` vector of column positions, or NULL. 可以用变量名字 (character) 或者位置 (numeric)。
     -    Note that `numeric` position start with the group *keys*, and then followed by ordinary columns.

-    `.fun`      A function fun, a quosure style lambda `~ fun(.)` or a list of either form.
-    `...`        Additional arguments for the function calls in `.funs`.

```R
# `summarize_at` affects variables selected with a character vector or vars()
error_continent_all %>% 
    group_by(pct, CON) %>% 
    summarize(across(-r_no, ~mean(.x, na.rm=TRUE)) )

starwars %>%
  summarise_if(is.numeric, mean, na.rm = TRUE)
starwars %>%
  summarise(across(where(is.numeric), ~ mean(.x, na.rm = TRUE)))

by_species <- iris %>%
  group_by(Species)
by_species %>%
  summarise_all(list(min, max))
by_species %>%
  summarise(across(everything(), list(min = min, max = max)))
```



```R
# Count size of group
by_species %>% summarize(count=n())

# Or use `tally()`
by_species %>% tally(sort=TRUE)
```



Select one group

```R
# Select one element from a list
iris %>%
  `[[`("Species")
# select one group
by_species %>% group_split() %>% `[[`(1)  # can extract by either position or name
```



`across(.cols = everything(), .fns = NULL, ..., .names = NULL)` makes it easy to apply the same transformation to multiple columns, allowing you to use `select()` semantics inside in `summarise()` and `mutate()`. 

- `.cols` 	Columns to transform.

  could use functions to select columns, eg, `starts_with("Sepal")`, `where(is.factor)`

- `.fns` 	  Functions to apply to each of the selected columns.

- `.names`  A glue specification that describes how to name the output columns.



```R
# code snippet for counting non-NA values for multiple select columns
data_desp %>% 
    group_by(ISO_C3) %>% 
    summarise(across(c("logDiff","tmp","pre","dtr"), ~sum(!is.na(.))) ) %>% 
    arrange(logDiff)
```

### split-apply-combine

Here is a summary of the split-apply-combine approach:

- `dplyr::group_map()`, `dplyr::group_modify()` ...
- `split` → `purrr::map()` / `purrr::map_dfr` / `purrr::map_dfc` 
- `plyr::ddply()`
- `data.table::setDT()`

```r
# with `dplyr`
df %>% group_by(type) %>% group_map(~tibble(trivial_func(.)))

# must do `group_split` before your can `map_dfr`
df %>% 
  split(type) %>%    # equivalent to `group_by(type)` then `group_split()`
  purrr::map_dfr(trivial_func)

# with `data.table`
library(data.table)
setDT(df)[, trivial_func(.SD), type]

# with `plyr`
plyr::ddply(df, .(type), trivial_func)
```

--------------------------------------------------------------------------------

Apply regression to each group with <span class="env-green">`purrr::map`</span>

```r
# A more realistic example: split a data frame into pieces, fit a
# model to each piece, summarise and extract R^2
mtcars %>%
  split(.$cyl) %>%
  map(~ lm(mpg ~ wt, data = .x)) %>%
  map(summary) %>%
  map_dbl("r.squared")

# If each element of the output is a data frame, use
# map_dfr to row-bind them together:
mtcars %>%
  split(.$cyl) %>%
  map(~ lm(mpg ~ wt, data = .x)) %>%
  map_dfr(~ as.data.frame(t(as.matrix(coef(.)))))
# (if you also want to preserve the variable names see
# the broom package)
```

--------------------------------------------------------------------------------

### `dplyr::group_modify()`

`dplyr::group_modify()` and `dplyr::group_map()` are purrr-style functions that can be used to iterate on <span class="env-green"><u>grouped tibbles</u></span>. 

- Note that `purrr::map`, `purrr::map_dfr`, and `purrr::map_dfc` does NOT work on groupped tibbles. You must do `group_split` to a list, then you can apply the purrr-style functions.

  - Convenient for multistep operations, **easy to debug**.
  - `map` is the main mapping function and returns a list
  - `map_dfr` stacks data frames by rows, `map_dfc` stacks data frames by columns.
    
    `map_dfr()` aligns the columns of the individual tibbles by name.

    `map_dfc` aligns the rows of the individual tibbles by position. → Difficult to check if the data in each row is aligned correctly. → Prone to error. 

- `group_modify` takes in a groupped tibble; returns a groupped tibble and `.f` must return a data frame.

  - `group_map` takes in a groupped tibble and returns a <span class="env-green">list</span>.
  - They takes in groupped tibbles, not good at multistep operations, **hard to debug** because you need to wrap up your whole calculation in one function.

<span style='color:red'>`group_modify(.data, .f, ..., .keep = FALSE)` </span> returns a grouped **tibble**.

- `.data`  A **grouped tibble**

- `.f`  A function, formula, or vector to apply to each group. It <span style='color:#FF9900'>**MUST return a data frame or a tibble**</span>! Matices do not work.

  A workaround is to use <span class="env-green">`tibble::enframe`</span> to convert named atomic vectors or lists to one- or two-column data frames.

  - If a **function**, it is used as is. It should have **at least 2 formal arguments**.

    - <u>If your costum function has only one argument</u>, you use the formula specification `~f(.x)`.

      ```R
      econ_data %>% group_by(year) %>% group_modify(~funPer_group(.x))
      ```

  - If a **formula**, e.g. `~ head(.x)`, it is converted to a function.

    In the formula, you can use

  - <span class="env-green">**`.`**</span> or <span class="env-green">**`.x`**</span> to refer to the subset of rows of `.tbl` for <span class="env-green">**the given group**</span>

    - <span class="env-green"> **`.y`**</span> to refer to the <span class="env-green">**group key**</span>, a one row `tibble` with one column per grouping variable that identifies the group

- `...`        Additional arguments passed on to `.f`

- `.keep=FALSE`  whether the grouping variables are kept in `.x`. 

  - Default to <span class="env-green">drop</span>> the grouping variable. Be mindful of this when you want to subset columns by position.


```R
cntry_group <- cntry_agg_df %>% group_by(as.numeric(ISO_N3), year)

groups <- cntry_group %>% group_split()
cntry_key <- group_keys(cntry_group)

# use a lambda function which includes a sequence of calculations
cntry_stat <- cntry_group %>% 
    group_modify(~ {
        .x %>% select(var_vec) %>%
            map_dfc(cal_stat) %>%  					# calculate stat
            mutate(stat = c("mean", "std")) # assign stat names
    		}) %>% 
		ungroup()
```

When using a lambda function inside `group_modify`:

- `.x` <u>can only be used once at the first function</u>; <span class="env-green">for later use, use `.`</span>

  `.x` and `.` are useful when the argument being assigned is NOT the first argument.

  If you use `.x` instead of `.`, you will encounter the following error:

  > Error in xj[i] : invalid subscript type 'language'


`enframe(x, name = "name", value = "value")` use examples:


- Convert named atomic vectors to a tibble with one row per element.
  ```r
  > enframe(c(a = 5, b = 7))
  # A tibble: 2 × 2
    name  value
    <chr> <dbl>
  1 a         5
  2 b         7
  ```

- Convert named list to a tibble with one row per element.
  ```r
  > enframe(list(one = 1, two = 2:3, three = 4:6))
  # A tibble: 3 × 2
    name  value    
    <chr> <list>   
  1 one   <dbl [1]>
  2 two   <int [2]>
  3 three <int [3]>
  ```

--------------------------------------------------------------------------------

**Apply CAPM to each company**

```r
# Apply CAPM to each company
# start with `.x`
# clearer logic flow, I prefer this approach ✓
data_group <- data %>% group_by(ISIN)
data_group %>% 
    # filter(cur_group_id() %in% c(1,2)) %>% 
    filter(cur_group_id() == 1) %>% 
    group_modify(~ {
        .x %>% 
            filter(between(p_date, estimation_start, estimation_end)) %>% 
            lm(eRi~rmrf, data=.) %>% 
            tidy(.)
    })

# ------------------------------------------------
# Equivalently, plug in `.x` in the first func
# one line shorter, more concise
data_group %>% 
    filter(cur_group_id() == 1) %>% 
    group_modify(~ {
            filter(.x, between(p_date, estimation_start, estimation_end)) %>% 
            lm(eRi~rmrf, data=.) %>% 
            tidy(.)
    })
```

- `filter(cur_group_id() == 1)` select the 1st group to test run your function

✅ Can also <span class="env-green">**define a function and pass to `group_modify`**</span> 

- This approach is easier to debug, whereas long sequence of lambda is hard to debug.

```r
factor_model <- function(company_data){
    company_data <- company_data %>% 
        filter(between(p_date, estimation_start, estimation_end))
    reg_ml <- lm(eRi~rmrf, data=company_data)
    coef_est <- tidy(reg_ml)
    return (coef_est)
}
# Debug with one group
groups <- data_group %>% group_split()
factor_model(groups[[1]])
# A tibble: 2 × 5
  term        estimate std.error statistic p.value
  <chr>          <dbl>     <dbl>     <dbl>   <dbl>
1 (Intercept)    0.114    0.0784      1.45 0.147  
2 rmrf           0.280    0.0945      2.97 0.00331

# Apply to all groups
data_group %>% 
    filter(cur_group_id() %in% c(1,2)) %>%
    group_modify(~factor_model(.x))
```

- `group_modify` requires at least 2 formal arguments for the function.
- Since the custom function `factor_model` has only 1 argument, we must use the lambda formula to pass to `group_modify`.

<span style='color:red'>`group_map(.data, .f, ..., .keep = FALSE)`</span> returns a **list** of results.



**More examples of `group_modify`**

- Apply a regression

  What I like most about `group_modify` is that it automatically <span class="env-green">adds the group key to the returned results</span>. You don't need to specify identifiers by yourself then.

- Calculate summary statistics

`group_modify` code snippets

```r
# Apply a regression
iris %>%
  group_by(Species) %>%
  group_modify(~ broom::tidy(lm(Petal.Length ~ Sepal.Length, data = .x)))
#> # A tibble: 6 × 6
#> # Groups:   Species [3]
#>   Species    term         estimate std.error statistic  p.value
#>   <fct>      <chr>           <dbl>     <dbl>     <dbl>    <dbl>
#> 1 setosa     (Intercept)     0.803    0.344      2.34  2.38e- 2
#> 2 setosa     Sepal.Length    0.132    0.0685     1.92  6.07e- 2
#> 3 versicolor (Intercept)     0.185    0.514      0.360 7.20e- 1
#> 4 versicolor Sepal.Length    0.686    0.0863     7.95  2.59e-10
#> 5 virginica  (Intercept)     0.610    0.417      1.46  1.50e- 1
#> 6 virginica  Sepal.Length    0.750    0.0630    11.9   6.30e-16

# ---------------------------------------------------------------
# descriptive statistics
# to use group_modify() the lambda must return a data frame
iris %>%
  group_by(Species) %>%
  group_modify(~ {
     quantile(.x$Petal.Length, probs = c(0.25, 0.5, 0.75)) %>%
     tibble::enframe(name = "prob", value = "quantile")
  })
#> # A tibble: 9 × 3
#> # Groups:   Species [3]
#>   Species    prob  quantile
#>   <fct>      <chr>    <dbl>
#> 1 setosa     25%       1.4 
#> 2 setosa     50%       1.5 
#> 3 setosa     75%       1.58
#> 4 versicolor 25%       4   
#> 5 versicolor 50%       4.35
#> 6 versicolor 75%       4.6 
#> 7 virginica  25%       5.1 
#> 8 virginica  50%       5.55
#> 9 virginica  75%       5.88

# `fivenum()` returns min, lower-hinge (Q1), median (Q1), 
# 	upper-hinge (Q3), and max
iris %>%
  group_by(Species) %>%
  group_modify(~ {
    .x %>%
      purrr::map_dfc(fivenum) %>%
      mutate(nms = c("min", "Q1", "median", "Q3", "max"))
  })
#> # A tibble: 15 × 6
#> # Groups:   Species [3]
#>    Species    Sepal.Length Sepal.Width Petal.Length Petal.Width nms   
#>    <fct>             <dbl>       <dbl>        <dbl>       <dbl> <chr> 
#>  1 setosa              4.3         2.3         1            0.1 min   
#>  2 setosa              4.8         3.2         1.4          0.2 Q1    
#>  3 setosa              5           3.4         1.5          0.2 median
#>  4 setosa              5.2         3.7         1.6          0.3 Q3    
#>  5 setosa              5.8         4.4         1.9          0.6 max   
#>  6 versicolor          4.9         2           3            1   min   
#>  7 versicolor          5.6         2.5         4            1.2 Q1    
#>  8 versicolor          5.9         2.8         4.35         1.3 median
#>  9 versicolor          6.3         3           4.6          1.5 Q3    
#> 10 versicolor          7           3.4         5.1          1.8 max   
#> 11 virginica           4.9         2.2         4.5          1.4 min   
#> 12 virginica           6.2         2.8         5.1          1.8 Q1    
#> 13 virginica           6.5         3           5.55         2   median
#> 14 virginica           6.9         3.2         5.9          2.3 Q3    
#> 15 virginica           7.9         3.8         6.9          2.5 max   

```



`group_walk(.data, .f)` calls `.f` for side effects and returns the input `.tbl`, invisibly. 

Can be used to write dplyr groups to separate files.

```r
# `.x` refers to the group
# `.y` refers to the key
# `.keep = TRUE` keeps the key column
all_df %>% 
    group_by(ISO_C3) %>% 
    group_walk(~ write_csv(.x, sprintf("./data/reg_result/bootstrap/%s/pathway_country/country-impact_bootstrap1000_tmp_%s.csv", ssp, .y$ISO_C3) ), .keep = TRUE)
```



**Suset specific groups**

```r
mtcars %>%
  group_by(cyl) %>%
  select_first_n_groups(2) %>%
  do({'complicated expression'})
```

`data.table` implementation 

```r
setDT(mtcars)[, .SD[.GRP %in% 1:2], by=cyl]
```

`dplyr` implementation

```r
mtcars %>%
  group_by(cyl) %>%
  filter(cur_group_id() %in% c(1,2))
```









