## Panel

`make.pbalanced(x, balance.type = "fill")` is useful to make a panel balanced by filling missing time periods with NA values. This is useful when you include individual specific time trends in the model.

`plm::plm(formula, data, effect = c("individual", "time", "twoways", "nested"), model = c("within", "random", "ht", "between", "pooling", "fd"), index = NULL )`

- `index` 	the index attribute that describes **individual** and **time** dimensions; has to be the exact order, i.e. **entity first**, can't reverse;

  It can be:

  - a vector of two character strings which contains the names of the individual and of the time

    indexes;

  - a character string which is the name of the **individual** index variable. In this case, the time index is created automatically and a new variable called "time" is added, assuming consecutive and ascending time periods in the order of the original data;

  - an integer, the number of individuals. In this case, the data need to be a **balanced panel** and be organized as a stacked time series (successive blocks of individuals, each block being a time series for the respective individual) assuming consecutive and ascending time periods in the order of the original data. Two new variables are added: "id" and "time" which contain the individual and the time indexes.

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

