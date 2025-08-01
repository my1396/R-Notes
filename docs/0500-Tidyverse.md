# Tidyverse

`tidyverse` is a collection of packages for data analyses. This package is designed to make it easy to install and load multiple `tidyverse` packages in a single step. The following packages are included in the core tidyverse: `ggplot2`, `dplyr`, `tidyr`, `readr`, `purrr`, `tibble`, `stringr`, `forcats`, `lubridate`.

The tidyverse also includes many other packages with more specialized usage. They are not loaded automatically with `library(tidyverse)`, so you’ll need to load each one with its own call to `library()`.

--------------------------------------------------------------------------------

<span style="font-size: 1.5em; font-weight: bold;">`tibble` Package</span> 

Create a `tibble`, just the same way as `data.fram`, only that without row names.

```r
tibble(x = 1:5, y = 1, z = x ^ 2 + y)
```

`tibble()` does much less than `data.frame()`: it never changes the type of the inputs (e.g. it never converts strings to factors!), it never changes the names of variables, it only recycles inputs of length 1, and it never creates `row.names()`.

`as_tibble()` vs `tibble()`:

- `as_tibble()` turns <u>an existing object</u>, such as a data frame or matrix, into a so-called tibble, a data frame with class `tbl_df`. 

- This is in contrast with `tibble()`, which builds a tibble from <u>individual columns</u>. 

  If using `tibble()` on a whole data frame, it would generate a one column `tibble` in which the column contains the data frame.

  `tibble` columns are versatile, can be lists, matrices, tibbles, etc.

```r
tibble(
  a = list(
    c = "three", 
    d = list(4:5)
    )
)
#> # A tibble: 2 × 1
#>   a        
#>   <named list>
#> 1 <chr [1]>   
#> 2 <list [1]> 
```

#### Print tibbles {.unnumbered .unlisted}

`tbl_df %>% print(n = Inf)` print all rows. `print.tbl_df` is useful in terms of explicitly and setting arguments like `n` and `width`. 

- `n` 	print the first `n` rows. When `n=Inf`, it means to <span style='color:#008B45'>print all rows</span>.
- `width` Width of text output to generate. This defaults to `NULL`, which means use the `width` in [`options()`](https://pillar.r-lib.org/reference/pillar_options.html). When `width=Inf`, will <span style='color:#008B45'>print all columns</span>.

 Use `?print.tbl_df` to show help page.

Alternatively, use, `tbl_df %>% data.frame()` to print the whole table. `data.frame` won't round numbers. Usually `tbl` round at the 6-th digit after the decimal point.

`print(as_tibble(mtcars), n = 3)` first convert to `tibble`, then specify the rows to print.



<span style='color:#008B45'>`data.table`</span> package has nice table print settings. You can preview the head and tail at the same time. It doesn't give you column details, such as data type, but it gives you a feeling of the data structure without using `head` and `tail` functions twice.

The `data.table` R package is being used in different fields such as finance and genomics and is especially useful for those of you that are working with large data sets (for example, 1GB to 100GB in RAM).

`data.table` Cheatsheet: <https://www.datacamp.com/cheat-sheet/the-datatable-r-package-cheat-sheet>



--------------------------------------------------------------------------------

### Data Frame and Vector Conversion {.unnumbered .unlisted}

[`reframe`](https://www.tidyverse.org/blog/2023/02/dplyr-1-1-0-pick-reframe-arrange/#reframe) can *return an arbitrary number of rows* per group, while `summarise()`reduces each group down to *a single row* and `mutate` returns *the same number of rows* as the input.

`reframe()` always returns an ungrouped data frame.

`reframe()` is theoretically connected to two functions in tibble, `tibble::enframe()`and `tibble::deframe()`:

- `enframe()`: vector → data frame
- `deframe()`: data frame → vector
- `reframe()`: data frame → data frame, with arbitrary number of rows per group.


`enframe` and `deframe` convert **vectors** to tibbles and vice verse.

Example Usage:


```r
enframe(1:3)
#> # A tibble: 3 × 2
#>    name value
#>   <int> <int>
#> 1     1     1
#> 2     2     2
#> 3     3     3
enframe(c(a = 5, b = 7))
#> # A tibble: 2 × 2
#>   name  value
#>   <chr> <dbl>
#> 1 a         5
#> 2 b         7
enframe(list(one = 1, two = 2:3, three = 4:6))
#> # A tibble: 3 × 2
#>   name  value    
#>   <chr> <list>   
#> 1 one   <dbl [1]>
#> 2 two   <int [2]>
#> 3 three <int [3]>
deframe(enframe(3:1))
#> 1 2 3 
#> 3 2 1 
deframe(tibble(a = 1:3))
#> [1] 1 2 3
deframe(tibble(a = as.list(1:3)))
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
```

--------------------------------------------------------------------------------

#### Concatenate list elements into a table {.unnumbered .unlisted}

- Use  `magrittr`'s pipe operator

  ```r
  myList %>% do.call("rbind", .)
  ```

  But using the new base/native pipe (`|>`) leads to errors performing the same operation:

  ```r
  myList |> do.call("rbind", .)
  #> Error in do.call(myList, "rbind", .) : 
  #>  second argument must be a list
  ```

  The error happens because <span style='color:#FF9900'>`|>` always inserts into the first argument and does NOT support dot</span>. A workaround is to use **named arguements**:

  ```r
  myList |> do.call(what = "rbind")
  ```

- Use `bind_rows` from `dplyr` or `rbindlist` from `data.table`:

  ```r
  library(dplyr)
  myList |> bind_rows()
  
  library(data.table)
  myList |> rbindlist()
  ```

- Use <span style="color: #008B45;">`reduce`</span> from `purrr`

  ```r
  library(purrr)
  myList |> reduce(rbind)
  ```

--------------------------------------------------------------------------------

#### one row/column tibble {.unnumbered .unlisted}

`as_tibble_row(x)` and `as_tibble_col(x, column_name="value")` convert a vector to one row or one column `tibble`; from `vetor` to `tibble`.

`as_tibble(data, rownames="new_col_name")`  convert (df) to tibble. Flexible with the format of the input data, can be a range of classes.

-   `data`  A data frame, list, matrix, or other object that could reasonably be coerced to a tibble.
-   `rownames` the name of a new column. Existing rownames are transferred into this column. If `NULL` then remove the rowname column.



`rownames_to_column(.data, var = "new colname")` and `column_to_rownames(.data, var = "col to use as rownames")` using one column as row names, or converting row names to one column.

-   `.data` needs to be a data frame; strict with input data type;
-   `var` 
    -   in <span style='color:#008B45'>`rownames_to_column`</span>: new column name for original rownames in the data.frame, or 
    -   in <span style='color:#008B45'>`column_to_rownames`</span>: convert tibble to data frame, and specify which column to use as rownames. 






## Basic operations on tibbles 

### Check Unique Values

**`n_distinct(x)`** This is a faster and more concise equivalent of `length(unique(x))`, # of unique values in `x`.



`distinct(df, ..., .keep_all=FALSE)` select **distinct/unique** rows, remove duplicate rows.

* `df`: table

* `...`: variables to use when determining uniqueness. If omitted, will use all variables.

  If there are multiple rows for a given combination of inputs, only the first row will be preserved. 

  If two variables are provided, then <u>unique combinations of the two</u> are used as key and the first row of each key is preserved.

* `.keep_all`:  If `TRUE`, keep all variables in `df`

```r
# unique locations
data %>% 
    distinct(lat, lon)
```


<span style='color:#008B45'>`dplyr::setdiff(x, y)`</span>  element that is in `x` but not in `y`.

-  `x` and `y` are supposed to have the same structure, i.e., same columns if for data frames.


### Column Names

`rename()` replaces an old name with a new one. 

```r
world %>% 
  rename(name = name_long)
# renames the lengthy name_long column to simply name
```


`magrittr` package provides a series of aliases which can be more pleasant to use when composing chains using the `%>%`operator.

| Alias        | Cmd        |
| ------------ | ---------- |
| `set_colnames` | colnames<- |
| `set_rownames` | rownames<- |
| `set_names`    | names<-    |


`set_names()` changes all column names at once, and requires a character vector with a name matching each column.



--------------------------------------------------------------------------------

### Column Operations

#### Create New Columns {.unnumbered .unlisted}

`add_column(df, ..., .after=NULL, .before=NULL)` add new column after the last column.

- `df`: Data frame to append to;
- `...`:  Name-value pairs to insert;
- `.before, .after`:  One-based column **index** or column **name** where to add the new columns, default: after last column



`data %>% mutate(column = .[[2]] - .[[1]])` subset by column positions.

- Here the dot notation in  `.[[2]]` refers to `data`, the variable you pipe into `mutate`. Dot is extra useful here because it allows you to use `data` multiple times. We use it twice in this example.

- Alternatively, `data %>% mutate(column = unlist(pick(2) - pick(1)))`  `unlist` here transform the list generated from `pick(2)-pick(1)` to a vector.

#### Order by Columns {.unnumbered .unlisted}

`arrange()` reorders data frame based on specified columns.


```r
# sort mtcars by disp in ascending order
arrange(mtcars, disp)
# sort mtcars by disp in descending order
arrange(mtcars, desc(disp))
```

`arrange` by column position

```r
# sort by first column in the data
data %>% arrange(.[1])
```

### `mutate`

`mutate()` adds new columns at the penultimate (second last) position in the `sf` object (the last one is reserved for the geometry):


```r
world %>% 
  mutate(pop_dens = pop / area_km2)
```

`mutate_at(.tbl, .vars, .funs)` applies a function to given columns:

-   `.tbl` 	A tbl object;
-   `.vars`   A list of columns generated by `vars()`, a character vector of <u>column names</u>, a numeric vector of <u>column positions</u>, or NULL.
-   `.fun`     A function fun, a quosure style lambda ` ~ fun(.)` or a list of either form.


```r
mtcars <- mtcars %>%
  mutate_at(c("hp_wt", "mpg_wt"), log) 
# note that `across` use together with `mutate`
mtcars <- mtcars %>%
  mutate(across(c("hp_wt", "mpg_wt"), log)) 
## factor as numeric, except for `ISO_C3`
agg_dummy %>% 
    mutate_at(vars(-ISO_C3), ~as.numeric(levels(.)[.]))
```

`across(.cols, .fnc, .names=NULL)` apply the same transformation to multiple columns, allowing you to use `select()` semantics inside in "data-masking" functions like `summarise()` and `mutate()`. 

- `.cols` 	Columns to transform. You can NOT select grouping columns because they are already automatically handled by the verb.

  can specify start and end columns using `:`. 

- `.fnc`       Functions to apply to each of the selected columns. Possible values are:

  - A function, e.g. `mean`.

  - <span style='color:#008B45'>A purrr-style lambda, e.g. `~ mean(.x, na.rm = TRUE)`</span>

    ```r
    # divide each col by 100, except for the Date column.
    FF_factor %>% mutate_at(vars(-Date), ~./100)
    ```

  - A named list of functions or lambdas, e.g. `⁠list(mean = mean, n_miss = ~ sum(is.na(.x))⁠`. Each function is applied to each column, and the output is named by combining the function name and the column name using the glue specification in `.names`.

`mutate()` and `mutate_at()` outputs a new data frame, it does *not* alter the given data frame. We need to reassign the data frame to be the output of the pipe.

`mutate_all(.tbl, .funs, ...)`  is equivalent to `apply(x, 2, FUN)`. But `apply()` works poor when column types are not unanimous. E.g.,  when a tibble has `character` and `numeric` columns, `apply()` tends to coerce `numeric` to `character`, and won't return the result as you expext.





--------------------------------------------------------------------------------

### Concatenate rows into a `tibble`

`add_row(.data, ..., .before = NULL, .after = NULL)  ` add one or more rows of data to an existing data frame, 

- convenient in the way that you can just specify each column with their values.
- especially convenient when you just want to **add one row**.

- `...`     <`dynamic-dots`> Name-value pairs, passed on to `tibble()`. 
  -   Values can be defined only for columns that already exist in `.data` and;
  -   unset columns will get an `NA` value.
- `.before`, `.after`  specify the position where you want to add the new row/rows.

```R
# add_row ---------------------------------
df <- tibble(x = 1:3, y = 3:1)
df %>% add_row(x = 4, y = 0)
```

**`bind_rows(..., .id = NULL)`**  This is an efficient implementation of the common pattern of `do.call(rbind, dfs)`. Match by <span style='color:#008B45'>column names</span>.

The output of `bind_rows()` will contain a column if that column appears in any of the inputs. `rbind` will throw errors if columns do not match.

- `...` 	Data frames to combine.

  - Each argument can either be a data frame, a list that could be a data frame, or a list of data frames.

  - When row-binding, **columns are matched <span style='color:#008B45'>by name</span>**, and any **missing columns will be filled with NA**. So <u>no column is dropped, which is safe</u>.

  - When column-binding (**`bind_cols(df1, df2, ...)`**), rows are matched <span style='color:#FF9900'>**by position**</span>, so all data frames must have the <u>same number of rows</u>. To match by value, not position, see [mutate-joins](http://127.0.0.1:40078/help/library/dplyr/help/mutate-joins).

    Need to be careful when you use `bind_cols`, make sure rows are in the same order in the tables you want to join. 

    - `bind_cols` is equivalent to `cbind`: match by position. Recommend to use `left_join`, which is safer.

    - <span style='color:#008B45'>`bind_rows` is safer than `rbind`</span>: `bind_rows` find matched col names

- `.id`     Data frame identifier.

  - When `.id` is supplied, a new column of identifiers is created to link each row to its original data frame. The labels are taken from the named arguments to `bind_rows()`. When a list of data frames is supplied, the labels are taken from the names of the list. If no names are found a numeric sequence is used instead.

```r
res = NULL
for (i in tibbleList)
   res = bind_rows(res, i)

# or, equivalently,
bind_rows(tibbleList) # combine all tibbles in the list
```


--------------------------------------------------------------------------------


### Data Subsetting

`pull(df, var)` pull out a single variable and return a vector. Similar to `$`, but works well with `%>%`.  

`var`: A variable specified as:

- a literal variable name
- a positive integer, giving the position counting from the left 
- a negative integer, giving the position counting from the right.

--------------------------------------------------------------------------------



<span style='color:red'>**`filter(.data, ..., .preserve=FALSE)`**</span> chooses rows/cases where conditions are true. Unlike base subsetting with `[`, rows where the condition evaluates to `NA` are dropped.

-   `...` 	<`data-masking`> Expressions that return a logical value, and are defined in terms of the variables in `.data`. If **multiple expressions** are included, they are combined with the **`&`** operator. Only rows for which all conditions evaluate to `TRUE` are kept.
-   `.preserve`   Relevant when the `.data` input is grouped. If `.preserve = FALSE` (the default), the grouping structure is recalculated based on the resulting data, otherwise the grouping is kept as is.


```r
# Countries with a life expectancy longer than 82 years
world6 = filter(world, lifeExp > 82)
# filter based on vector
filter(diamonds, cut %in% c('Ideal', 'Premium'))
```

Useful filter functions:

- `==`, `>`, `>=` etc
- `&`, `|`, `!`, `xor()`
- `is.na()`
- `between()`, `near()`

`between(x, left, right)` is a  shortcut for `x >= left & x <= right`.

Ex. `x[between(x, -1, 1)]`



--------------------------------------------------------------------------------

`select()` subsets by column, **`slice`** subsets by **rows**.  **`select()`** selects **columns** by name or position.


```r
world1 = dplyr::select(world, name_long, pop)
names(world1)
#> [1] "name_long" "pop"       "geom"
```

`select()` also allows subsetting of a range of columns with the help of the `:` operator:


```r
# all columns between name_long and pop (inclusive)
world2 = dplyr::select(world, name_long:pop)
```

`select()` can be used to **reorder**/drop variables.


```r
select(df, year, var, state)   # reverses the columns
select(df, -state) # drop column by name 'state' 
```

If you only know you want **`var` in the *front*** and don't care about the order of the rest, you can do [*move one variable in the front*]


```r
df %>%
  select(var, everything())
```


`all_of(vars)` is used together with `select` for *strict selection*. If any of the variables in the character vector is missing, an error is thrown.

- `vars` 	 A vector of character names or numeric locations.

`any_of(vars)`   doesn't check for missing variables. It is especially **useful with negative selections**, when you would like to make sure a variable is removed.

```r
# select columns may or may not exist
the_country %>% select(any_of(c("isoa2", "countryCode")) )
# remove columns may or may not exist
the_country %>% select(-any_of(c("isoa2", "countryCode")) )
```
 
This flexibility is useful because it won't return an error if the variable is not found.


**Selection with conditions**

Functions work together with `select` to choose cols matching certain conditions: <span style='color:#008B45'>`starts_with()`</span>, <span style='color:#008B45'>`ends_with()`</span>, `contains()`. These are selection helpers which match variables according to a given pattern.

```r
> iris %>% select(starts_with("Sepal"))
#> # A tibble: 150 x 2
#>   Sepal.Length Sepal.Width
#>          <dbl>       <dbl>
#> 1          5.1         3.5
#> 2          4.9         3  
#> 3          4.7         3.2
#> 4          4.6         3.1
#> # i 146 more rows

> iris %>% select(ends_with("Width"))
#> # A tibble: 150 x 2
#>   Sepal.Width Petal.Width
#>         <dbl>       <dbl>
#> 1         3.5         0.2
#> 2         3           0.2
#> 3         3.2         0.2
#> 4         3.1         0.2
#> # i 146 more rows
```

--------------------------------------------------------------------------------

### Dynamic Selection

A **<span style='color:red'>dynamic</span> subset of variables** when using `select`


```r
dynamic_var <- 'state'
df %>% select(year, var, eval(dynamic_var)) # dynamic_var will be parsed as state

# --- dplyr version 0.7+---
multipetal <- function(df, n) {
    varname <- paste("petal", n , sep=".")
    mutate(df, !!varname := Petal.Width * n)
}
# !! unquote
# using := to dynamically assign/change parameter names
```

variables in the left hand side

```R
plot_v <- "maize"
plot_data <- plot_data %>% 
    select(year, plot_v, tmx, pre, rad) %>% 
    mutate(!!plot_v := log(eval(parse(text = plot_v)) )) %>% 
    group_by(year) %>% 
    summarise(across(everything(), ~mean(.x, na.rm = TRUE) ) )
plot_data    

```



Use `!!` to unquote a single argument in a function call. `!!` takes a single expression, evaluates it, and inlines the result in the AST.

```R
x <- expr(-1)
expr(f(!!x, y))
#> f(-1, y)
```



<span style='color:red'>`rlang::sym(x)`</span> 	 take a string as input and turn it into symbols

string `x` -> expression `expr(x)` -> evaluate`!!expr(x)`



**`!!!`** the behaviour of `!!!` is known as “spatting” in Ruby, Go, PHP, and Julia. It is closely related to `*args` (star-args) and `**kwarg` (star-star-kwargs) in Python, which are sometimes called argument unpacking.



  <span style='color:red'>**`:=`** </span> rather than interpreting `var` literally (pronounced colon-equals), we want to use the value stored in the variable called `var`.

```r
tibble::tibble(!!var := val)
#> # A tibble: 3 x 1
#>       x
#>   <dbl>
#> 1     4
#> 2     3
#> 3     9
```

Note the use of `:=` (pronounced colon-equals) rather than `=`. Unfortunately we need this new operation because R’s grammar does not allow expressions as argument names:

`:=` is like a vestigial organ: it’s recognised by R’s parser, but it doesn’t have any code associated with it. It looks like an `=` but allows expressions on either side, making it a more flexible alternative to `=`. It is used in data.table for similar reasons.

--------------------------------------------------------------------------------

#### SE-versions of dplyr verbs {.unnumbered .unlisted}

<https://dplyr.tidyverse.org/reference/se-deprecated.html>

dplyr used to offer twin versions of each verb suffixed with an underscore. These versions had standard evaluation (SE) semantics: rather than taking arguments by code, like NSE verbs, they took arguments by value. Their purpose was to make it possible to program with dplyr. 

However, dplyr now uses tidy evaluation semantics. NSE verbs still capture their arguments, but you can now unquote parts of these arguments. This offers full programmability with NSE verbs. Thus, the underscored versions are now superfluous.

```r
gcm_name <- "CanESM5"
mergeData %>% filter(get(gcm_name)<35 )
mergeData %>% filter_(sprintf( "%s<35", gcm_name ) ) # SE version
mergeData %>% select_(gcm_name) # SE version
```



`select_(.data, .dots=list() )`

-   `.data`  	A data frame.
-    `.dots`, `...`    Pair/values of expressions coercible to lazy objects.

```r
vars <- list(list('cyl', 'mpg'), list('vs', 'disp'))
for (v in vars) {
  print(mtcars %>% select_(.dots = v) %>% head)
}
 								  cyl  mpg
Mazda RX4           6 21.0
Mazda RX4 Wag       6 21.0
Datsun 710          4 22.8
Hornet 4 Drive      6 21.4
Hornet Sportabout   8 18.7
Valiant             6 18.1
                  vs disp
Mazda RX4          0  160
Mazda RX4 Wag      0  160
Datsun 710         1  108
Hornet 4 Drive     1  258
Hornet Sportabout  0  360
Valiant            1  225
```

Let’s make something more practical. For each list of variable arguments, we want to group using the first variable and then summarise the grouped data frame by calculating the mean of the second variable. Here, dynamic argument construction really comes into account, because we programmatically construct the arguments of `summarise_()`, e.g. `mean_mpg = mean(mpg)` using string concatenation and `setNames()`:

```R
summarise_vars <- list(list('cyl', 'mpg'), list('vs', 'disp'))

for (v in summarise_vars) {
  group_var <- v[1]   # group by this variable
  summ <- paste0('mean(', v[2], ')')  # construct summary method, e.g. mean(mpg)
  summ_name <- paste0('mean_', v[2])  # construct summary variable name, e.g. mean_mpg

  print(paste('grouping by', group_var, 'and summarising', summ))

  df_summ <- mtcars %>%
    group_by_(.dots = group_var) %>%
    summarise_(.dots = setNames(summ, summ_name))

  print(df_summ)
}

# output
[1] "grouping by cyl and summarising mean(mpg)"
# A tibble: 3 × 2
    cyl mean_mpg

1     4 26.66364
2     6 19.74286
3     8 15.10000
[1] "grouping by vs and summarising mean(disp)"
# A tibble: 2 × 2
     vs mean_disp

1     0  307.1500
2     1  132.4571
```



```r
# To refer to column names that are stored as strings, use the `.data` pronoun:
vars <- c("mass", "height")
cond <- c(80, 150)
starwars %>%
  filter(
    .data[[vars[[1]]]] > cond[[1]],
    .data[[vars[[2]]]] > cond[[2]]
  )
```


### Merge

`left_join(x, y, by = NULL, suffix = c(".x", ".y"), ...)`

* `x,y ` 	    tbls to join

* `by`           **a character vector** of variables to join by. If `NULL`, the default, `*_join()` will do a natural join, using all variables with **common colnames** across the two tables. 

  To join by the same variables on `x` and `y`, use `by = c('ID','year')`, note that it is a character vector, can't use column names directly.

  To join by different variables on `x` and `y`, use a <u>named vector</u>. For example, `by = c("a" = "b")` will match `x.a` to `y.b`.

* `suffix`   If there are non-joined duplicate variables in x and y, these suffixes will be added to the output to disambiguate them. Should be a character vector of length 2.



`merge(x, y, by = NULL, by.x = NULL, by.y = NULL, all = FALSE, ...)` is the base R function for joining two data frames. 

- `all = FALSE`  defaults to `FALSE`, it performs an <u>inner join</u>, retaining only the rows with matching keys.

  If `TRUE`, it performs a full <u>outer join</u>, retaining all rows from both `x` and `y`. 








