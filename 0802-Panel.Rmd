## Panel

`make.pbalanced(x, balance.type = "fill")` is useful to make a panel balanced by filling missing time periods with NA values. This is useful when you include individual specific time trends in the model.

`plm::plm()` is the horse force for panel data estimation.

`plm::plm(formula, data, effect = c("individual", "time", "twoways", "nested"), model = c("within", "random", "ht", "between", "pooling", "fd"), index = NULL )`

- `index` 	the index attribute that describes **individual** and **time** dimensions; has to be the exact order, i.e. **entity first**, can't reverse;

  It can be:

  - a vector of two character strings which contains the names of the individual and of the time

    indexes;

  - a character string which is the name of the **individual** index variable. In this case, the time index is created automatically and a new variable called "time" is added, assuming consecutive and ascending time periods in the order of the original data;

  - an integer, the number of individuals. In this case, the data need to be a **balanced panel** and be organized as a stacked time series (successive blocks of individuals, each block being a time series for the respective individual) assuming consecutive and ascending time periods in the order of the original data. Two new variables are added: "id" and "time" which contain the individual and the time indexes.


### Two-way fixed effects

With `effect = "twoways"`, the model includes both firm FE and year FE. The year fixed effects absorb all variation that is common across firms within a year — which is exactly what these macro variables capture. They are perfectly collinear with the year dummies, so plm silently drops them.

> In a two-way FE panel, you cannot separately identify time-invariant cross-sectional variables (absorbed by firm FE) or cross-sectionally invariant time-series variables (absorbed by year FE).

Q: Do I have to convert the data to a panel data frame with `pdata.frame()` before using `plm()`?  
A: Not necessarily. You have two options: 

1. Convert to `pdata.frame()` and estimate with `plm()`. 
2. Use `plm()` directly on a regular data frame, specifying the `index` argument to indicate the panel structure.

```r
# Option 1: Convert to pdata.frame
library(plm)
data("Grunfeld", package = "plm")
grunfeld_pdata <- pdata.frame(Grunfeld, index = c("firm", "year"))
model_fe <- plm(inv ~ value + capital, data = grunfeld_pdata, effect = "twoways", model = "within")

# Option 2: Use plm directly on regular data frame
model_fe_direct <- plm(inv ~ value + capital, data = Grunfeld, effect = "twoways", model = "within", index = c("firm", "year"))
```

Note that `ggplot2` accepts regular data frames only. 
If you want to plot the data with `ggplot2`, it is suggested to save a panel data frame version of the data (`grunfeld_pdata`) for estimation and use the original data frame (`grunfeld`) for plotting.


--------------------------------------------------------------------------------

Robust standard errors for panel data models can be computed with the `vcovHC()` function from the `sandwich` package.

```r
# clustered by firm
coeftest(model_fe, vcov = vcovHC(model_fe, type = "HC1", cluster = "group"))
# clustered by year
coeftest(model_fe, vcov = vcovHC(model_fe, type = "HC1", cluster = "time"))
```

**Firm- vs. Year-level clustering**


|                       | Firm-level clustering (`cluster = "group"`) | Year-level clustering (`cluster = "time"`) |
| --------------------- | -------------------------------------------- | ------------------------------- |
| Correlation structure | Allows within-firm correlation of errors across years | Allows within-year correlation of errors across firms |
| What it accounts for  | Firm-specific shocks that persist over time           | Common shocks affecting all firms in the same year    |
| When to use           | Default choice for panel data with many firms and multiple observations per firm | Appropriate when aggregate macro shocks dominate (e.g., COVID, financial crisis, policy changes) |
| Example               | Firm culture, management quality, industry-specific trends affecting the same firm over time | All firms affected by the same Fed rate change, recession, or regulatory change in a given year  |




--------------------------------------------------------------------------------


### Dynamic Panel

```R
data("EmplUK", package = "plm")
form <- log(emp) ~ log(wage) + log(capital) + log(output)
# Arellano and Bond (1991), table 4, col. b 
empl_ab <- pgmm(
    dynformula(form, list(2, 1, 0, 1)),
    data = EmplUK, index = c("firm", "year"),
    effect = "twoways", model = "twosteps",
    gmm.inst = ~ log(emp), lag.gmm = list(c(2, 99)) 
    )
```


$$
\boldsymbol \Gamma_n = \begin {pmatrix}
\gamma_0 & \gamma_1 & \gamma_2 & \cdots & \gamma_{n - 1} \\ \gamma_1 & \gamma_0 & \gamma_1 & \cdots & \gamma_{n - 2} \\ \gamma_2 & \gamma_1 & \gamma_0 & \cdots & \gamma_{n - 3} \\ \vdots & \vdots & \vdots & \ddots & \vdots \\ \gamma_{n - 1} & \gamma_{n - 2} & \gamma_{n - 3} & \cdots & \gamma_0 \end {pmatrix}
$$

