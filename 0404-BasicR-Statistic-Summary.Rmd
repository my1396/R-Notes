
## Statistical Summary Functions

*Functions for calculating descriptive statistics and summaries.*

### The `summary()` Function

`base::summary()` is a generic function used to produce summary statistics or summaries of the results of various model fitting functions, e.g., `lm`. The function invokes particular `methods` which depend on the `class` of the first argument.

Here we focus on obtaining summary statistics given a dataset.

```r
# summary a vector returns one row table
> data = c(1: 5, 56, 43, 56, 78, 51)
> print(summary(data))
Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
1.00    3.25   24.00   29.90   54.75   78.00 
> summary(data)%>%class()
[1] "summaryDefault" "table"  

# summary a data frame returns a summary for each column
> summary(iris)
  Sepal.Length    Sepal.Width     Petal.Length    Petal.Width          Species  
 Min.   :4.300   Min.   :2.000   Min.   :1.000   Min.   :0.100   setosa    :50  
 1st Qu.:5.100   1st Qu.:2.800   1st Qu.:1.600   1st Qu.:0.300   versicolor:50  
 Median :5.800   Median :3.000   Median :4.350   Median :1.300   virginica :50  
 Mean   :5.843   Mean   :3.057   Mean   :3.758   Mean   :1.199                  
 3rd Qu.:6.400   3rd Qu.:3.300   3rd Qu.:5.100   3rd Qu.:1.800                  
 Max.   :7.900   Max.   :4.400   Max.   :6.900   Max.   :2.500 
```



### User-defined summary function

`summary()` provides a quick overview of the data, but it does NOT return a tidy data frame. → Not convenient for further analysis.

- Moreover, `summary()` does not provide some useful statistics such as standard deviation, skewness, and kurtosis.

Hence we write our own summary functions `quick_summary` that return tidy data frames.

```r
quick_summary <- function(x) {
    # Function to compute basic descriptive statistics
    data.frame(
        n = length(x),
        min = min(x),
        mean = mean(x),
        median = median(x),
        max = max(x),
        sd = sd(x),
        skewness = moments::skewness(x),
        kurtosis = moments::kurtosis(x)
        # row.names = NULL
    )
}
# use example
> quick_summary(iris$Sepal.Length) %>% round(2)
    n min mean median max   sd skewness kurtosis
1 150 4.3 5.84    5.8 7.9 0.83     0.31     2.43
```

Summary by group 

```r
CASchools %>%
    group_by(grades) %>%
    group_map(~ {
        s <- quick_summary(.x$expenditure)
        s <- cbind(
            grades = .y$grades,    # add group info
            N = nrow(.x),   # add other statistics
            s)
        return(s)
    }) %>%
    bind_rows()

grades   N   n      min     mean   median      max       sd skewness kurtosis
1  KK-06  61  61 4715.446 5577.493 5399.383 7614.379 662.8033 1.019435 3.309185
2  KK-08 359 359 3926.070 5267.365 5195.919 7711.507 618.6415 1.094514 5.284716
```


### `stargazer()` function

`stargazer` package provides functions to create well-formatted regression and summary statistics tables. 

```r
library(stargazer)
stargazer(iris, type = "text", digits = 2, summary.stat = c("n", "mean", "median", "sd", "min", "p25", "p75", "max"))
```

- Useful for exporting summary statistics to LaTeX, HTML, ASCII text, or RTF.

### Box plot statistics

Summary statistics for <span style='color:#00CC66'>**box plots**</span>

`boxplot.stats` returns the extreme of the lower whisker, the lower 'hinge' (Q1 or the 1st quartile), the median (or midhinge), the upper 'hinge' (Q3 or the 3rd quartile) and the extreme of the upper whisker.

- lower whisker is the smallest data point within 1.5 × IQR from Q1

  The larger of `min` and  `Q1–1.5*IQR`, `IQR=Q3-Q1` is the interquartile range.

- upper whisker is the the largest data point within 1.5 × IQR from Q3

  The smaller of `max` and `Q3+1.5*IQR`

```R
box.stat <- function(col){
    # Return a vector of statistics of 6 elements, containing 
    # 1) the extreme of the lower whisker, 
    # 2) the lower 'hinge', 3) the median, 4)the upper 'hinge', 
    # 5) the extreme of the upper whisker,
    # and 6) the mean.
    setNames(c(boxplot.stats(col)$stats, mean(unlist(col), na.rm=TRUE) ),
             c("low.whisker", "1st.Q", "median", "3rd.Q", "upper.whisker", "mean") )
}
```

Get boxplot and its stats

```r
# boxplot of price groupped by make
boxplot(price~make, sample_price2)$stats %>% 
    as_tibble() %>% 
    setNames(c("bmw","toyota")) %>% 
    add_column("stat"=c("low.whisker", "1st.Q", "median", "3rd.Q", "upper.whisker"), .before=1)
```



Summary statistics for <span style='color:#00CC66'>**box plots**</span>

`boxplot.stats` returns the extreme of the lower whisker, the lower ‘hinge’ (Q1 or the 1st quartile), the median (or midhinge), the upper ‘hinge’ (Q3 or the 3rd quartile) and the extreme of the upper whisker.

- lower whisker is the smallest data point within 1.5 × IQR from Q1

  The larger of `min` and  `Q1–1.5*IQR`, `IQR=Q3-Q1` is the interquartile range.

- upper whisker is the the largest data point within 1.5 × IQR from Q3

  The smaller of `max` and `Q3+1.5*IQR`

```R
box.stat <- function(col){
    # Return a vector of statistics of 6 elements, containing 
    # 1) the extreme of the lower whisker, 
    # 2) the lower ‘hinge’, 3) the median, 4)the upper ‘hinge’, 
    # 5) the extreme of the upper whisker,
    # and 6) the mean.
    setNames(c(boxplot.stats(col)$stats, mean(unlist(col), na.rm=TRUE) ),
             c("low.whisker", "1st.Q", "median", "3rd.Q", "upper.whisker", "mean") )
}
```

Get boxplot and its stats

```r
# boxplot of price groupped by make
boxplot(price~make, sample_price2)$stats %>% 
    as_tibble() %>% 
    setNames(c("bmw","toyota")) %>% 
    add_column("stat"=c("low.whisker", "1st.Q", "median", "3rd.Q", "upper.whisker"), .before=1)
```

`setNames()`	updates the column names without having to write another replacement function.


