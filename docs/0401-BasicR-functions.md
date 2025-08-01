
## Basic R functions

### Workspace Management

*Functions for managing objects and getting help in your R workspace.*

`ls()`  lists all of the objects in your workspace.

`rm(list=ls())`	remove all objects in the working environment

**Check if var exists**

`exists("x")` determine whether `x` exists in global environment. Note that variable is in quotes.



**Check if a file/folder exists**

```R
if (!dir.exists("output")){
  dir.create("output")
} else{
  print("dir exists")
}

data <- 'my_data.csv'
if(file.exists(data)){
  df <- read.csv(data)
} else {
  print('Does not exist')
}
```

`list.files(dir, pattern=NULL)` 	returns a character vector of the file names in `dir`.

- `pattern`	an optional regular expression. Only file names which matches the regular expression will be returned.

`dir.create(path)` 	create a direcotry.

`file.copy(from, to)`	copy files from one directory to another.




--------------------------------------------------------------------------------


### Data Display and Output

*Functions for displaying and formatting data output.*

**`cat(x)`** Outputs the objects, concatenating the representations. `cat` performs much less conversion than `print`.

- `cat` is useful for producing output in user-defined functions. It converts its arguments to character vectors, concatenates them to a single character vector, appends the given `sep =` string(s) to each element and then outputs them.


--------------------------------------------------------------------------------



`sprintf(fmt, ...)`	The string `fmt` contains normal characters, which are passed through to the output string, and also conversion specifications which operate on the arguments provided through `…`. The allowed conversion specifications start with a `%` and end with one of the letters in the set `aAdifeEgGosxX%`.  	

https://www.rdocumentation.org/packages/base/versions/3.6.2/topics/sprintf

- <span style='color:#008B45'>**re-use one argument**</span> in `fmt`: add <span style='color:#008B45'>`1$`</span> between `%`  and `s`, numbers specify the position, `$` as place holder; 

  Immediately after `%` may come `1$` to `99$` to refer to a numbered argument.

  If this is done it is best if all formats are numbered: if not the unnumbered ones process the arguments in order. 

  ```R
  a <- "tree"
  sprintf("The %1$s is large but %1$s is small. %1$s", a)
  [1] "The tree is large but tree is small. tree"
  ```

- Round to 2 digits after decimal. 

  ```r
  sprintf("%.2f", r_A)
  ```

  Use double percentage to escape `%`

  ```r
  # print percentage sing: use double percent
  > sprintf("%.2f%%", r_A*100)
  [1] "9.62%"
  ```

- The difference in `print` and `sprintf` is in the `return` value. `sprintf` **returns** a character vector containing a formatted combination of text and variable values. `print` prints its argument and **returns** it invisibly.

- If we want to `print` in a for loop wrap the `sprintf` in a `print` or `cat` or `message`.

  -    Automatic printing is turned off in loops. If you want to print some return values, must explicitly specify.
  -    `summary(x)`, `str(x)` implicitly have print function, this info will print inside `for` loops.

--------------------------------------------------------------------------------




`print` vs. `cat`:

`print` is simply returning the character string as data object. 

The `cat` function, in contrast, **interprets** code-specific information (e.g. `\n` is converted into a newline), returns a readable version of our character string.

- if you want to display an R object in a `for` loop, use `print`.

  ```R
  data <- data.frame(x1 = 1:5,                  # Create example data
                     x2 = 3)
  print(data)                                   # Apply print to data frame
  #   x1 x2
  # 1  1  3
  # 2  2  3
  # 3  3  3
  # 4  4  3
  # 5  5  3
  ```

- if you want to display charater strings as tracking messages, use `cat`.

  ```R
  my_string <- "This is \nan example string"    # Create example string
  
  print(my_string)                              # Apply print to character string
  # [1] "This is \nan example string"
  
  cat(my_string)                                # Apply cat to character string
  # This is 
  # an example string
  ```

- `cat` is valid only for atomic types (logical, integer, real, complex, character) and names. It means you cannot call `cat` on a non-empty list or any type of object. In practice it simply converts arguments to characters and concatenates so you can think of something like `as.character() %>% paste()`.

  `print` is a generic function so you can define a specific implementation for a certain S3 class.

  ```r
  > foo <- "foo"
  > print(foo)
  [1] "foo"
  > attributes(foo)$class <- "foo"
  > print(foo)
  [1] "foo"
  attr(,"class")
  [1] "foo"
  > print.foo <- function(x) print("This is foo")
  > print(foo)
  [1] "This is foo"
  ```

- Another difference between `cat` and print is returned value.

  -    `cat` invisibly returns **`NULL`** while `print` returns its **argument**. This property of `print` makes it particularly useful when combined with pipes:

  ```r
  coefs <- lm(Sepal.Width ~  Petal.Length, iris) %>%
           print() %>%
           coefficients()
  ```

--------------------------------------------------------------------------------



`paste(…, sep = " ", collapse = NULL)`

- `...` 	one or more R objects, to be converted to character vectors.
- `sep`     a character string to separate the terms. 
- `collapse`  an optional character string to separate the results

Creating a comma separated string vector

- <span style='color:#008B45'>single quotes</span>

  ```r
  > paste(shQuote(seq(1:5)), collapse=", ")
  [1] "'1', '2', '3', '4', '5'"
  ```

- <span style='color:#008B45'>**double quotes**</span>

  ```r
  > cat(paste(shQuote(seq(1:5), type="cmd"), collapse=", "))
  "1", "2", "3", "4", "5"
  ```



Useful function to enclose text strings in quotes and connect with comma

This is useful when you want to create a long sql command including many identifiers.

```r
paste_with_quotes <- function(string_vec, type="single") {
    # Paste collapse with quotes
    # @string_vec: vector of string
    # @type: single or double quotes, defaults to single
    if (type=="single") {
        paste(shQuote(string_vec), collapse=", ") %>% cat()   
    } else {
        # double quotes
        toString(shQuote(string_vec, type="cmd")) %>% cat()   
    }
}
> paste_with_quotes(c("CLZD12-R", "GW7KTS-R"))
'CLZD12-R', 'GW7KTS-R'
> paste_with_quotes(c("CLZD12-R", "GW7KTS-R"), type="double")
"CLZD12-R", "GW7KTS-R"
```



`sep` creates element-wise sandwich stuffed with the value in the `sep` argument. `paste(slices_1, slices_2, sep='jam')`

`collapse` creates **ONE big sandwich** with the value of `collapse` argument added between the sandwiches produced by using the `sep` argument. 

- `paste(slices_1, slices_2, sep='jam', collapse='cheese')`

- `paste(charac_vec, collapse='+')`

  ```R
  auxilary_v
  # [1] "CLD" "DTR" "FRS" "PRE" "TMN" "TMP" "TMX" "VAP" "WET" "URB" "LAT"
  # [12] "LON" "MON" "ALT"
  
  paste(auxilary_v, sep = " + ") # doesn't change anything
  # [1] "CLD" "DTR" "FRS" "PRE" "TMN" "TMP" "TMX" "VAP" "WET" "URB" "LAT"
  # [12] "LON" "MON" "ALT"
  
  paste(auxilary_v, collapse = " + ")
  # [1] "CLD + DTR + FRS + PRE + TMN + TMP + TMX + VAP + WET + URB + LAT + LON + MON + ALT"
  ```



Paste vector with `", "`, using `shQuote`.

```r
paste(shQuote(as.list(Model_vec)), collapse = ", " )
```

`paste0(…, collapse)` is equivalent to `paste(…, sep = "", collapse)`, slightly more efficiently.



--------------------------------------------------------------------------------


`gor_shape@data %>% as_tibble() %>% print(n=10, width=Inf)`  display all `data.frame`.

- `n` 	specify # of rows.
- `width`   specify # of columns. Controls the maximum number of columns on a line used in printing vectors, matrices and arrays, and when filling by `cat`.

--------------------------------------------------------------------------------


### Data Manipulation and Transformation

*Functions for manipulating, transforming, and organizing data.*

**`rev(x)`** 	provides a reversed version of its argument. Useful in reversing color scales.

```R
> rev(c(1:5, 5:3))
# [1] 3 4 5 5 4 3 2 1
```


`seq(from, to, by, length.out, along.with)` create a sequence

- `by` 		     increment of the sequence.
- `length.out`     desired length of the sequence.
- `along.with`     take the length from the length of this argument.



<span style='color:#00CC66'>`rep()`</span> repeats vector

- `rep(x, times)`        if `times` is one integer, then repeat `x` as a whole `times`
  - if `times` is a vector of the same lenght as `x`, then repeat each element by the number of times in `times`.
- `rep(x, each)`  	repeat each element in `x` by `times`


```r
# repeat x as a whole
> rep(c(0, 0, 7), times = 3)
# [1] 0 0 7 0 0 7 0 0 7

# repeat each element by respective times
> rep(c(0, 7), times = c(4,2))
# [1] 0 0 0 0 7 7

# repeat each element by the same number of times
> rep(c(2, 4, 2), each = 3)
# [1] 2 2 2 4 4 4 2 2 2

# repeat as a whole, same length as specified in `length.out`
> rep(1:3, length.out=7)
# [1] 1 2 3 1 2 3 1
```

#### Finding and Locating Elements {-}

`match(x, y)` 	returns a vector of the positions of (first) matches of its first argument in its second.

-   `x` 	the values to be matched;
-   `y`         the values to be matched against. 


`which(x)` returns `TRUE` **indices** of a logical object

-   `x` a `logical` vector or array. `NA`s are allowed and omitted (treated as if `FALSE`).


`identical(x, y)` The safe and reliable way to test two objects for being *exactly* equal.


`near()` This is a safe way of comparing if two vectors of floating point numbers are (pairwise) equal. This is safer than using `==`, because it has a built in tolerance. Returns a logical vector (TRUE/FALSE for *each element comparison*)

```r
near(x, y, tol = .Machine$double.eps^0.5)
```

`all.equal(x, y, tolerance=1.5e-8)` floating point comparison, in contrast to exact comparison `identical()`. The `all.equal()` function allows you to test for equality with a difference tolerance of 1.5e-8, "near equality". It does an overall comparison of the two objects and returns a single TRUE/FALSE, while `near` does a pairwise comparison and returns a logical vector of for the element-wise comparison.

-   If the difference is greater than the tolerance level the function will return the mean relative difference.
-   return `TRUE` if `x` and `y` are approximately equal; it returns a summary, either equal or not equal; not a complete result of one-by-one comparison;

```r
x <- c(0.1, 0.2, 0.3)
y <- c(0.1000001, 0.2000001, 0.3000001)

# near() - element-wise logical vector
near(x, y)
# [1] TRUE TRUE TRUE

# all.equal() - single summary result
all.equal(x, y)
# [1] TRUE  (if within tolerance)
```

`subset(x, subset, select, drop = FALSE, …)` 	Subsetting Vectors, Matrices And Data Frames

- `x` 	 object to be subsetted.

- `subset`   logical expression indicating elements or rows to keep: missing values are taken as false.

- `select`   columns to select from a data frame.

  ```R
  subset(airquality, Temp > 80, select = c(Ozone, Temp))
  subset(airquality, Day == 1, select = -Temp)
  subset(airquality, select = Ozone:Wind)
  
  with(airquality, subset(Ozone, Temp > 80))
  ```

  


--------------------------------------------------------------------------------


#### Standardizing Data {-}

**`scale(x, center = TRUE, scale = TRUE)`** 	`scale` is generic function whose default method centers and/or scales the columns of a numeric matrix.

- `x` 		a numeric matrix(like object).
- `center`   either a logical value or numeric-alike vector of length equal to the number of columns of `x`
  - The value of `center` determines how column centering is performed. 
  - If `center` is a **numeric-alike** vector with length equal to the number of columns of `x`, then each column of `x` has the corresponding value from `center` subtracted from it. 
  - If `center` is `TRUE` then centering is done by **subtracting the column means** (omitting `NA`s) of `x` from their corresponding columns, and 
  - if `center` is `FALSE`, **no** centering is done.
- `scale`     either a logical value or a numeric-alike vector of length equal to the number of columns of `x`.
  - The value of `scale` determines how column scaling is performed (after centering). 
  - If `scale` is a numeric-alike vector with length equal to the number of columns of `x`, then each column of `x` is divided by the corresponding value from `scale`. 
  - If `scale` is `TRUE` then scaling is done by dividing the (centered) columns of `x` by their standard deviations if `center` is `TRUE`, and the root mean square otherwise. 
  - If `scale` is `FALSE`, no scaling is done.

```R
## To scale by the standard deviations without centering, use 
scale(x, center = FALSE, scale = apply(x, 2, sd, na.rm = TRUE))
```



**Squish values into range**

`scales::squish(x, range = c(0, 1) )` out of bound values handling. It replaces out of bounds values with the nearest limit. 

```R
# sometimes need to add to a small number to the lower bound
c <- 10 * .Machine$double.eps
squish(x, range = c(0+c, 1) )
```


--------------------------------------------------------------------------------


#### Data Subsetting {-}

<span style='color:#00CC66'>**`subset(x, subset, select, drop = FALSE, ...)`** </span>  subsetting vectors, matrices, tibbles ... This is a generic function, with methods supplied for many data types.

- `x` 	    vector, list, matrix, dataframe, or tibble
- `subset`   logical expression indicating elements or **rows** to keep: missing values are taken as false.
- `select`   expression, indicating **columns** to select from a data frame.
- `drop`       passed on to `[` indexing operator.

```R
## examples
subset(airquality, Temp > 80, select = c(Ozone, Temp))
subset(airquality, Day == 1, select = -Temp)
subset(airquality, select = Ozone:Wind)

with(airquality, subset(Ozone, Temp > 80))
```



```R
agg_window <- function(df, win, FUN, ...){
    # applies `FUN` non-overlapping window of length `win`
    # for data frame `df`
    n <- ceiling(nrow(df)/win)
    if (n!=(nrow(df)/win)) print ("short multiples")
    
    group_idx <- rep(1:n, each=win)[1:nrow(df)]
    df$key <- group_idx
    df_agg <- aggregate(. ~ key, df, FUN, ...)
    df_agg$key <- NULL
    
    return (df_agg)
}
agg_window(the_CC[,-(1:6)], 12, mean, na.rm=TRUE, na.action=NULL)
# na.rm=TRUE, drop rows with na values to enable mean calcualion
# na.action=NULL, to ensure that rows with NA values are not dropped when performing calculations.
```



<span style='color:#00CC66'>`drop=FALSE`</span> prevents from droping the dimensions of the array.

Note the comma before the cmd, it is necessary to indicate `drop=FALSE` is the third argument.

```r
> df <- data.frame(a = 1:100)
> df[1:10,]
[1]  1  2  3  4  5  6  7  8  9 10
> df[1:10, , drop=FALSE]
    a
1   1
2   2
3   3
4   4
5   5
...
```







--------------------------------------------------------------------------------


#### `cut()` - Converting Continuous to Categorical {-}

**`cut(x, breaks, labels=NULL, include.lowest=FALSE, right = TRUE, dig.lab=3)`**    converts numeric to factor, divides the range of `x` into intervals and codes the values in `x` according to which interval they fall. The leftmost interval corresponds to level one, the next leftmost to level two and so on. 

**Key Features:**

- `cut()` by default is left open right closed interval 
  - as  `"(b1, b2]"`, `"(b2, b3]"` etc. for `right = TRUE` and 
  - as  `"[b1, b2)"`, ... if `right = FALSE`.
- `dig.lab = 3` defines integer which is used when labels are not given. 

**Example Usage:**

```R
addPval.symbol <- function(x){
    ## add significance as symbols. The p-value of a trend slope 
    ## is added as symbol as following: 
    ##      *** (p <= 0.001), ** (p <= 0.01), 
    ##      * (p <= 0.05), . (p <= 0.1) and no symbol if p > 0.1.
    ## @param x: a numeric vector of p-values
    cutpoints <- c(0, 0.001, 0.01, 0.05, 0.1, 1)
    symbols <- c("***", "**", "*", ".", " ")
    cut(x, breaks=cutpoints, labels=symbols)
}
```

--------------------------------------------------------------------------------


### Generate Random Seeds

**Save Random Seed**

When you need to generate random numbers for your model, in order to ensure reproducibility, the best practice is to save the random seed.

```r
# y is a Bernoulli with probability pr
eff_seed <- sample(1:2^15, 1)
eff_seed <- 25662
print(sprintf("Seed for session: %s", eff_seed))
set.seed(eff_seed)
```

### Draw random samples

`rbinom(n, size, prob)`  binomial distribution with parameter `size` and `prob`.  

- `size` for the number of trials. 

  - when `size=1`, it generate the Bernoulli distribution
    $$
    X = \begin{cases}
    1 & \text{with prbability }p \\
    0 & \text{with prbability }1-p \\
    \end{cases}
    $$

  Binomial is the sum of Bernoulli
  $$
  Y = \sum_{i=1}^{\text{size}} X_i
  $$
  The probability is given by
  $$
  P(Y=y) = \begin{pmatrix} 
  \text{size} \\
  y
  \end{pmatrix} p^y (1-y)^{\text{size}-y}
  $$
  for $y=0, \ldots, \text{size}.$



Two ways to generate a <span style='color:#008B45'>Bernoulli distribution</span> sample.

1. use `rbinom` and specify size to be 1.

   ```r
   rbinom(n = 20, size = 1, prob = 0.7)
   ```

    set `n = 20` to indicate 20 draws from a binomial distribution, set `size = 1`to indicate the distribution is for 1 trial, and `p = 0.7` to specify the distribution is for a “success” probability of 0.7:



2. use `sample` and specify respective probabilities using `prob`.

   `sample(x, size, replace=FALSE, prob=NULL)`  draw random samples from a sample space using either with or without replacement.

   - `prob` 	a vector of probability weights for obtaining the elements of the vector being sampled. Of the same length as `x`.

   ```r
   sample(c(0,1), size = 20, replace = TRUE, prob = c(0.3, 0.7))
   ```

   Here’s a sample of 20 zeroes and ones, where 0 has a 30% chance of being sampled and 1 has a 70% chance of being sampled. 

   

--------------------------------------------------------------------------------

### Fit a distribution

```R
# fit a lognormal distribution
library(MASS)
fit_params <- fitdistr(prices_monthly$AdjustedPrice,"lognormal")
fit_params$estimate
x <- prices_monthly$AdjustedPrice %>% {seq(min(.), max(.), length=30)} # data point at which to compute density
x
fit <- dlnorm(x, fit_params$estimate['meanlog'], fit_params$estimate['sdlog'])
```



--------------------------------------------------------------------------------


### Operation on list

`purrr::map(.x, .f, ...)` return a list.  The `map` function transforms its input by applying a function to each element of **a list or atomic vector** and returning an object of the same length as the input.

The <span style='color:#008B45'>main advantage of `map()`</span> is the helpers which allow you to write compact code for common special cases.

- `.x` 	A list or atomic vector.

- `.f`         A function, formula, or vector (not necessarily atomic).

  - `.f` can be a named function, e.g., `mean`.

  - Formula: `~ . + 1` is equivalent to `function(x) x + 1`. 

    This syntax allows you to create very compact anonymous functions.

    - `.` or  `.x`  refer to the first argument.
    - For a two argument function, use `.x` and `.y`
    - For more arguments, use `..1`, `..2`, `..3` etc

  - <span style='color:#008B45'>subset lists</span>

    For instance, we need the 2nd element of a nested list. We can use `map(list, 2) `, while `lapply(list, 2) ` doesn't work ;

- `...`     Additional arguments passed on to `.f`.

- Type-specific map functions simply many lines of code

  -   <span style='color:red'>`map_dfr()`</span> and `map_dfc()` return data frames created by row-binding and column-binding respectively. 
  -   `map_lgl()`, `map_int()`, `map_dbl()` and `map_chr()` return an *atomic vector* of the indicated type (or die trying).

If **character vector**, **numeric vector**, or **list**, it is converted to an extractor function. Character vectors index by <u>name</u> and numeric vectors index by <u>position</u>; use a list to index by position and name at different levels. If a component is not present, the value of `.default` will be returned.

`map()` can be used as a **concise loop**.

```r
l <- map(1:4, ~ sample(1:10, 15, replace = T))
str(l)
#> List of 4
#>  $ : int [1:15] 7 1 8 8 3 8 2 4 7 10 ...
#>  $ : int [1:15] 3 1 10 2 5 2 9 8 5 4 ...
#>  $ : int [1:15] 6 10 9 5 6 7 8 6 10 8 ...
#>  $ : int [1:15] 9 8 6 4 4 5 2 9 9 6 ...
```

#### Select first element of nested list {-}

```r
x <- list(list(1,2), list(3,4), list(5,6))
# use lapply
lapply(x, `[[`, 1)
# use `purrr::map`
purrr::map(x, 1)
```



Use examples of `purrr:map`

```r
# Generate normal distributions from an atomic vector giving the means
1:10 %>%
  map(rnorm, n = 10)

# You can also use an anonymous function
1:10 %>%
  map(function(x) rnorm(10, x))

# Or a formula
1:10 %>%
  map(~ rnorm(10, .x))

# Simplify output to a vector instead of a list by computing the mean of the distributions
1:10 %>%
  map(rnorm, n = 10) %>%  # output a list
  map_dbl(mean)           # output an atomic vector
#> [1] 1.328465 2.489343 2.598304 4.208711 5.036009 5.853896 6.943884 7.779394 8.727930 9.793523

> set_names(c("foo", "bar")) %>% map_chr(paste0, ":suffix")
         foo          bar 
"foo:suffix" "bar:suffix" 
```

You can apply regression to each group with `map`, see [Split-and-Apply Operations](#split-and-apply-operations) for more details.



Find the values that occur in every element.

```r
# use `intersect` three times
out <- l[[1]]
out <- intersect(out, l[[2]])
out <- intersect(out, l[[3]])
out <- intersect(out, l[[4]])
out
#> [1] 8 4

# alternatively use `reduce` once
reduce(l, intersect)
#> [1] 8 4
```

`purrr::reduce(.x, .f, ...)` takes a vector of length *n* and produces a vector of length 1 by calling a function with a pair of values at a time: `reduce(1:4, f)` is equivalent to `f(f(f(1, 2), 3), 4)`.

<img src="https://drive.google.com/thumbnail?id=1tf9pLkXPOvfRazWsixTxpoPSr5ltw-MT&sz=w1000" alt="purrr: reduce" style="display: block; margin-right: auto; margin-left: auto; zoom:60%;" />

- `.x` 	A list or atomic vector.



List all the elements that appear in at least one entry. 

```r
reduce(l, union)
#>  [1]  7  1  8  3  2  4 10  5  9  6
```



