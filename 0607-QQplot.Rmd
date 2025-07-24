## QQ-plot

```r
# using `ggplot2`
sim_data <- rsnorm(10000, mean = 0, sd = 1, xi = -2.5)
ggplot() +
    geom_qq(aes(sample=sim_data)) +
    geom_qq_line(aes(sample=sim_data), color="red") +
    labs(x="Theoretical quantiles", y="Sample quantiles", 
         title="Normal Q-Q plot")
```

`geom_qq()` produce quantile-quantile plots.  Sample quantiles in y-axis, theoretical quantiles in x-axis.

`geom_qq_line()` compute the slope and intercept the line regressing sample and theoretical quantiles.

Standardize to improve visualization.

- calculate mannually or

- use `scale(x, center=TRUE, scale=TRUE)`

  `center` and `scale` can be either a logical value or a numeric vector of length equal to the number of columns of `x`.
  $$
  \frac{x-\text{center}}{\text{scale}}
  $$

```r
# standardized qq-plot
ggplot() +
    geom_qq(aes(sample=with(data, (HML-mean(HML))/sd(HML)))) +
    geom_qq_line(aes(sample=with(data, (HML-mean(HML))/sd(HML))), color="red") +
    labs(x="Theoretical quantiles", y="Sample quantiles", 
         title=sprintf("Normal Q-Q plot — HML, sd: %.2f, kurtosis: %.2f", sd(data$HML), kurtosis(data$HML)))
```

