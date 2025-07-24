## Data Frame Operations

**Basic operations:**

- `colSums(x)` 	returns sum for each column
- `rowSums(x)` 	returns sum for each row
- `setNames()`	updates the column names without having to write another replacement function.



`magrittr` package provides a series of aliases which can be more pleasant to use when composing chains using the `%>%`operator.

| Alias        | Cmd        |
| ------------ | ---------- |
| `set_colnames` | colnames<- |
| `set_rownames` | rownames<- |
| `set_names`    | names<-    |

 


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

  


### Column/Row-wise Operations {-}

`sweep(data, MARGIN, STATS, FUN='-')` 	Return an array obtained from an input array by sweeping out a summary statistic; useful in <span style='color:#008B45'>**standardizing data**</span>, eg., center or scale columns.

* data: matrix/dataframe

* MARGIN: 1 row-wise, 2 column-wise..

* STATS: a vector with the same length as row \[MARGIN=1\]/ column \[MARGIN=2\].

* FUN: the function to be used to carry out the sweep.

  Example:

  `sweep(z, 2, colMeans(z),'-')`  substract column mean from each column;

Alternatively, can use `mutate_at`. You can perform the operation on selected cols without changing the data structure. By contrast, with `sweep`, you need to subset the relevant cols, apply the operation, and concatenate them back to the remainder of the columns afterwards.

Takeaway: Use `sweep` if the operation is to all cols; use `mutate_at` if to selected cols.

```r
center_col <- function(data, cols){
    ## Mean center columns in a table
    # @data: table or data frame
    # @col: a vector of selected columns to center
    # @return A data frame with the selected columns mean-centered 
    #   (i.e., each value minus its column mean).
    
    data %>% 
        mutate_at(cols, ~.-mean(., na.rm=TRUE))
}
```

**Remove duplicate columns, regardless of column names:**


```r
# remove duplicate columns, regardless column names
df[!duplicated(lapply(df, summary))] 
```


--------------------------------------------------------------------------------


### <span style='color:#008B45'>**Process `NA` values**</span>

`NaN` not a number.  0/0 is an example of a calculation that will produce a `NaN`. `NaN`s print as `NaN`, but generally act like `NA`s. Use `is.nan` to check if `NaN`.

`Inf` is infinite numbers. `is.infinite` find infinite numbers (`Inf`, `-Inf`).


`na.omit(x)` remove `NA` values in `x`;

-   `x` 	could be vectors, matrices, and data frames; 
    -   if `x` is a data frame, remove rows with NA values;

#### Find NA values {-}

`complete.cases(x)` 	return a logical vector indicating which cases/<u>rows</u> are complete.

```r
# count number of rows with NA values
data %>% negate(complete.cases)() %>% sum()
```

`purrr::negate()` works similar to `base::Negate()`

- R is case-sensitive.

`(!is.na(x)) %>% colSums() %>% sort()`  returns a vector of the number of non-NA values per column, column names as vector name.

When you have a long list of columns, vector is hard to read, use `as_tibble_row() %>% t()` to convert to a tibble column.

```r
# when you have a long list of columns, you can convert to a tibble column for best visualization.
miss_per_col <- data %>% 
    filter(date > ymd("2013-01-01")) %>% 
    is.na() %>% 
		colSums()
miss_per_col <- miss_per_col %>% as_tibble_row() %>% t()
miss_per_col %>% dim()
miss_per_col[1:40, ] %>% t() %>% t()
miss_per_col[41:77, ] %>% t() %>% t()
```



`(!is.na(x)) %>% rowSums() %>% sort()`  calculate the number of non-NA values per row

`tidyr::drop_na(x, any_of(vars))` 	allow you to specify which columns you want to eliminate NA values from; it doesn't have to be the whole columns;

-   `x` 	must be a data frame.


`which(is.na(data))` returns positions of omitted missing values

A custom function for handling common missing/invalid values:

```R
cast_na <- function(x){
    # Remove records with nonvalid values, such as NA, Inf, NaN 
    # remain x when mask==TRUE
    if (is.null(dim(x))){
				# `x` is a vector
      	mask <-  !(x %in% c(NA, NaN, Inf, -Inf) )
        x <- x[mask]
    }
    else {
        # `x` is a data.frame
        mask <- apply(x, 1, function(x) sum(x %in% c(NA, NaN, Inf, -Inf)))
        mask <- (mask == 0)
        x <- x[mask,]}
    return (x)
}
```




Keep rows with least NA's for duplicated rows

```r
User_Table %>%
  arrange(rowSums(is.na(.))) %>%        # sort rows by number of NAs
  distinct(User_ID, .keep_all = TRUE)   # keep first row per User_ID only
```


#### Fill missing values {-}

**Forward/Backward filling**

`tidyr::fill(data, ..., .direction = c("down", "up", "downup", "updown"))` Fill missing values in selected columns using the next or previous entry. This is useful in the common output format where values are not repeated, and are only recorded when they change.

-   `...` 	Columns to fill.
-   `.direction` Direction in which to fill missing values. Default: "down".

Alternatively, you can use `zoo::na.locf`

```r
# Last obs. carried forward
na.locf(x)                

# Next obs. carried backward
na.locf(x, fromLast = TRUE) 
```

`fromLast` defaults to `FALSE`, carry forward. If set to `TRUE`, carry backward.

--------------------------------------------------------------------------------

Replace with specific values

`dplyr::na_if(x, y)` 	that replaces any values in `x` that are equal to `y` with `NA`. It is useful if you want to convert an annoying value to `NA`.

```R
> na_if(1:5, 5:1)
# [1]  1  2 NA  4  5
> y <- c("abc", "def", "", "ghi")
> na_if(y, "")
# [1] "abc" "def"  NA  "ghi"
```

`tidyr::replace_na(data, replace)` Replace NAs with specified values

- `replace` 
 
  - If `data` is a data frame, `replace` takes a list of values, with one value for each column that has `NA` values to be replaced.

    ```R
    # Replace NAs in a data frame
    df <- tibble(x = c(1, 2, NA), y = c("a", NA, "b"))
    df %>% replace_na(list(x = 0, y = "unknown"))
    ```

  - If `data` is a vector, `replace` takes a single value. This single value replaces all of the `NA` values in the vector.

    ```R
    # Replace NAs in a vector
    df %>% dplyr::mutate(x = replace_na(x, 0))
    # OR
    df$x %>% replace_na(0)
    df$y %>% replace_na("unknown")
    ```
  
