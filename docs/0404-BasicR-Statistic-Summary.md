
## Statistical Summary Functions

*Functions for calculating descriptive statistics and summaries.*

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


