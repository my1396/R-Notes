# Regression


```r
library(tidyverse)
reg_data <- read_csv("https://raw.githubusercontent.com/my1396/course_dataset/refs/heads/main/META_monthly_factor_model_2014-2024.csv")
reg_data <- reg_data %>% 
    mutate(return = adjusted/lag(adjusted)-1,
           eRi = return-RF)
## CAPM
capm_ml <- lm(eRi~rmrf, data=reg_data)
summary(capm_ml)
```

```
## 
## Call:
## lm(formula = eRi ~ rmrf, data = reg_data)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -0.40895 -0.03482  0.00141  0.03767  0.20600 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 0.009747   0.007645   1.275    0.205    
## rmrf        1.066640   0.166384   6.411  2.8e-09 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 0.08343 on 123 degrees of freedom
##   (1 observation deleted due to missingness)
## Multiple R-squared:  0.2504,	Adjusted R-squared:  0.2444 
## F-statistic:  41.1 on 1 and 123 DF,  p-value: 2.801e-09
```

Get the **coefficient table** with `broom::tidy`.


```r
library(broom)
tidy(capm_ml)
```

```
## # A tibble: 2 × 5
##   term           estimate   std.error statistic     p.value
##   <chr>             <dbl>       <dbl>     <dbl>       <dbl>
## 1 (Intercept) 0.009746761 0.007644518  1.275000 2.047124e-1
## 2 rmrf        1.066640    0.1663838    6.410718 2.801085e-9
```


Get the **variance-covariance matrix** with `vcov`.


```r
vcov(capm_ml)
```

```
##               (Intercept)          rmrf
## (Intercept)  5.843866e-05 -0.0002760605
## rmrf        -2.760605e-04  0.0276835643
```

```r
# verify using coef table
capm_ml %>% 
    tidy() %>% 
    mutate(variance=std.error^2)
```

```
## # A tibble: 2 × 6
##   term           estimate   std.error statistic     p.value      variance
##   <chr>             <dbl>       <dbl>     <dbl>       <dbl>         <dbl>
## 1 (Intercept) 0.009746761 0.007644518  1.275000 2.047124e-1 0.00005843866
## 2 rmrf        1.066640    0.1663838    6.410718 2.801085e-9 0.02768356
```


We can manually calculate as

```r
df <- (nrow(capm_ml$model)-2)  # degree of freedom
sigma2 <- sum(capm_ml$residuals^2)/df  # residual variance
# 1st column of lm$model is the depend. var.
X <- capm_ml$model[, 2, drop=FALSE] %>% as.matrix()
X <- cbind(1, X)  # add intercept
V <- solve(t(X) %*% X) * sigma2
V
```

```
##                             rmrf
##       5.843866e-05 -0.0002760605
## rmrf -2.760605e-04  0.0276835643
```


Note that `cov.unscaled` returns the **unscaled** covariance matrix, $(X'X)^{-1}$. 

- To get estimated covariance matrix for the coefficients, you need to multiply `cov.unscaled` by the estimate of the error variance.


```r
solve(t(X) %*% X)
```

```
##                          rmrf
##       0.008395487 -0.03965975
## rmrf -0.039659745  3.97711043
```

```r
summary(capm_ml)$cov.unscaled
```

```
##              (Intercept)        rmrf
## (Intercept)  0.008395487 -0.03965975
## rmrf        -0.039659745  3.97711043
```

```r
all.equal(solve(t(X) %*% X), 
          summary(capm_ml)$cov.unscaled, 
          check.attributes = FALSE)
```

```
## [1] TRUE
```


**References**:

- <https://github.com/SurajGupta/r-source/blob/master/src/library/stats/R/vcov.R>
- stats package: <https://docs.tibco.com/pub/enterprise-runtime-for-R/6.0.1/doc/html/Language_Reference/stats/summary.lm.html>






