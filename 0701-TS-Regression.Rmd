## Time Series Regression

Distributed Lag model using `dynlm` package, which is useful for dynamic linear models and time series regressions. Lags or differences can directly be specified in the model formula.

The main function used to estimate our model is the `dynlm(formula, data)` function. Within this function, `d()` can be used to specify the **difference** in a variable and `L()` can be used to compute the desired **lag** of the variable.  

`d(u, 1)` means to calculate the first difference in `u`; `L(g, 0:2)` denotes `g` of the current period and the past two periods, $g$, $g_{-1}$, and $g_{-2}$.

Note that `data` must be either a data frame or `zoo` object. `xts` returns an error.

```r
> library(dynlm)
# Finite Distributed Lag Models
> okun.lag2 <- dynlm(d(unemp, 1) ~ L(gGDP, 0:2), data = okun2.zoo)  # lag 2
> okun.lag3 <- dynlm(d(unemp, 1) ~ L(gGDP, 0:3), data = okun2.zoo)  # lag 3
# ARDL(1, 1)
> okun.ardl <- dynlm(d(unemp, 1) ~ L(d(unemp, 1), 1) + L(gGDP, 0:1), data = okun2.zoo)
> summary(okun.ardl)

Time series regression with "zoo" data:
Start = 1948 Q3, End = 2025 Q1

Call:
dynlm(formula = d(unemp, 1) ~ L(d(unemp, 1), 1) + L(gGDP, 0:1), 
    data = okun2.zoo)

Residuals:
    Min      1Q  Median      3Q     Max 
-1.4662 -0.2198 -0.0218  0.1686  4.9875 

Coefficients:
                  Estimate Std. Error t value Pr(>|t|)    
(Intercept)        0.42871    0.03769  11.374  < 2e-16 ***
L(d(unemp, 1), 1) -0.05640    0.05874  -0.960 0.337736    
L(gGDP, 0:1)1     -0.43423    0.02390 -18.165  < 2e-16 ***
L(gGDP, 0:1)2     -0.11951    0.03575  -3.343 0.000932 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4416 on 303 degrees of freedom
  (0 observations deleted due to missingness)
Multiple R-squared:  0.5825,	Adjusted R-squared:  0.5784 
F-statistic: 140.9 on 3 and 303 DF,  p-value: < 2.2e-16

```



