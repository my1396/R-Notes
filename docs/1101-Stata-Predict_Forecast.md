## Predict

Refer to [U] 20.11 Obtaining predicted values.

`predict` calculates predictions, residuals, influence statistics, and the like after estimation. Exactly what `predict` can do is determined by the previous estimation command; command-specific options are documented with each estimation command. Regardless of command-specific options, the actions of `predict` share certain similarities across estimation commands:

```stata
predict [type] newvar [if] [in] [, single_options]
```

- `predict newvar1` create `newvar1` containing "predicted values", i.e., $\hat{y}_i = \E(y_i\mid \bx_i)$

  - For **linear regression** models, $\hat{y}_i = \bx_i'\hat{\bbeta.}$
  - For **probit/logit** models, $\hat{y}_i = F(\bx_i'\hat{\bbeta}),$ where $F(.)$ is the logistic or normal cumulative distribution function.

- `predict newvar2, xb` create `newvar2` containing the linear prediction

  Option `xb` means calculating the linear prediction, $\bx_i'\hat{\bbeta},$ from the fitted model.

  Note that in case of a linear regression model, `predict fitted` and `predict fitted, xb` will give you the same result.

  The difference is that for probit/logit models, `predict fitted` gives you the predicted probability, while `predict fitted, xb` gives you the logit or probit index.

- `predict newvar2 if e(sample), xb` Same as above, but only for observations used to fit the model in the previous estimation, i.e., **in-sample predictions**.

  `e(sample)`:  return $1$ if the observation is in the estimation sample and $0$ otherwise.

- `predict` can be used in **out-of-sample predictions**, which extends beyond the estimation sample. 

  You can load a new dataset and type `predict` to obtain results for that sample.

  ```stata
  use dataset1		/* estimation dataset */
  (fit a model)
  use dataset2		/* forecast dataset */
  predict yhat    /* fill in the predictions */
  ```

- ` predict e, residuals` will generate a variable `e` containing the residuals of the estimation

  $$
  e_i = y_i - \hat{y}_i
  $$
  

Consider the linear prediction

$$
\begin{split}
\hat{y}_i &= \bx_i'\hat{\bbeta}  \\
&= \hat{\beta}_1x_{1i} + \hat{\beta}_2x_{2i} + \cdots + \hat{\beta}_Kx_{Ki} .
\end{split}
$$

$\hat{y}_i$ is called the 

- **predcited values** for in-sample predictions
- **forecasts** for out-of-sample predictions

For logit or probit, $\bx_i'\hat{\bbeta}$ is called the logit or probit *index*. The predicted probability is $p_i=\hat{y}_i=F(\bx_i'\hat{\bbeta}),$ where $F(.)$ is the logistic or normal cumulative distribution function.
For probit, $\hat{y}_i=\Phi(\bx_i'\hat{\bbeta})$ .

$x_{1i},$ $x_{2i},$ $\ldots,$ $x_{Ki}$ are obtained from the data currently in memory and do **NOT** necessarily correspond to the data on the independent variables used to fit the model (obtaining $\hat{\beta}_1,$ $\hat{\beta}_2,$ $\ldots,$ $\hat{\beta}_K$).




## Forecast

Refers to 

- [U] 20.21 Dynamic forecasts and simulations for a quick overview.
- [TS] forecast for detailed documentation.

Foreceast: **out-of-sample**


forecast works with time-series and panel datasets, and you can obtain either dynamic or staticforecasts. 

- **Dynamic forecasts** use **previous periods’ forecast values** wherever lags appear in the model’s equations and thus allow you to obtain forecasts for multiple periods in the future. 

- **Static forecasts** use **previous periods’ actual values** wherever lags appear in the model’s equations, so if you use lags, you cannot make predictions much beyond the end of the time horizon in your dataset. However, static forecasts are useful during model development.

> Note: Dynamic vs Static forecasts do not indicate whether the model itself is dynamic or static. It refers to how lagged values are treated when making forecasts.
> Quick takeaway: Using **dynamic forecasts** to make predictions multiple periods into the future where you do not have observations for the lagged dependent variable.


You can incorporate outside information into your forecasts, and you can specify a future path for some of the model's variables and obtain forecasts for the other variables conditional on that path. These features allow you to produce forecasts under **different scenarios**, and they allow you to explore how different **policy interventions** would affect your forecasts.

--------------------------------------------------------------------------------

Before we are able to forecast, we must populate the exogenous variables over the entire forecast horizon before solving our model. 添加数据

*Solving our model*: means obtain forecast from our model.


--------------------------------------------------------------------------------

### Essential Procedure

::: {.step-list}
1. **Estimate the model**

   Here we use arima model as an example.
   
   ```stata
   arima y2 x3 y1, ar(1) ma(1)
   ```

2. **Store the estimation results** using `estimate store`

   ```stata
   estimate store myarima
   ```

3. **Create a forecast model** using `forecast create`. 
   
   This initialize a new model; we will call the model `mymodel.`

   ```stata
   forecast create mymodel
   ```

   The name you give the model mainly controls how output from `forecast` commands is labeled. More importantly, `forecast create` creates the internal data structures Stata uses to keep track of your model.

4. **Add all equations** to the model you just created using `forecast estimates`.

   The following command adds the stored estimation results in `myarima` to the current model `mymodel`.

   ```
   forecast estimates myarima
   ```

5. **Compute dynamic forecasts** from 2012 to 2024

   ```stata
   forecast solve, begin(2012) end(2024)
   ```
:::


--------------------------------------------------------------------------------

### Creates a new forecast model

```stata
forecast create [ name ] [ , replace ]
```

The `forecast create` command creates a new forecast model in Stata.
You must create a model before you can add equations or solve it. You can have *only one model in memory at a time*.

You may optionally specify a `name` for your model. That `name` will appear in the output produced by the various forecast subcommands.

`replace` clear the existing model from memory before creating `name`.  By default, `forecast create` issues an error message if another model is already in memory.

Note that you can add multiple equations to a forecast model.


--------------------------------------------------------------------------------

### Add equations/identifies

Add estimation results to a forecast model currently in memory.

```stata
forecast estimates modelname [, options]
```

`modelname` is the name of a stored estimation result being added; it is generated by `estimates store modelname`.

**Options**:

- `predict(p_options)`:  call `predict` using `p_options`

- `names(newnamelist[ , replace])`: use `newnamelist` for the names of left-hand-side (LHS) variables in the estimation result being added, i.e., `modelname`.

  `forecast estimates` creates a new variable in the dataset for each element of `namelist`.  

  You <span class="env-green">**MUST**</span> use this option of any of the LHS variables contains time series operators, e.g., `D.`, `L.`.
  
  If a variable of the same name already exists in your dataset, `forecast estimates` exits with an error unless you specify the `replace` option, in which case existing variables are overwritten.
  
  

```stata
// use example
forecast estimates myestimates
```

Add estimation results stored in `myestimates` to the forecast model currently in memory.





___

#### Add an Identity to a `forecast` Model


```stata
forecast identity varname = exp
```

An `identity` is a nonstochastic equation that expresses an endogenous variable in the model as a function of other variables in the model. Identities often describe the behavior of endogenous variables that are based on accounting identities or adding-up conditions.

```stata
// Add an identity to the forecast that states that y3 is the sum of y1 and y2
forecast identity y3=y1+y2
// create new variable newy before adding it to the forecast
forecast identity newy=y1+y2, generate
```

The difference is that if the LHS variable does not exist, you need to specify the option `gen`.

Ex. We have a model using annual data and want to assume that our population variable pop grows at 0.75% per year. Then we can declare endogenous variable pop by using forecast identity:

```stata
forecast identity pop = 1.0075*L.pop
```

Typically, you use `forecast identity` to define the relationship that determines an endogenous variable that is already in your dataset. 


The generate option of forecast identity is useful when you wish to use a transformation of one or more endogenous variables as a right-hand-side variable in a stochastic equation that describes another endogenous variable.



___

#### Add equations that you obtained elsewhere to your model

Up untill now, we have been using model output from Stata to add equations to a forecast model, i.e., using `forecast estimates`. 

You use `forecast coefvector` to add endogenous variables to your model that are defined by linear equations.

Common use scenarios of `forecast coefvector`:

- Sometimes, you might see the estimated coefficients for an equation in an article and want to add that equation to your model. In this case, `forecast coefvector` allows you to add equations that are stored as coefficient vectors to a forecast model.

- User-written estimators that do not implement a `predict` command can also be included in forecast models via `forecast coefvector`. 

- `forecast coefvector` can also be useful in situations where you want to simulate time-series data.

```stata
forecast coefvector cname [, options ]
```

`cname` is a Stata matrix with **one row**. It defines the linear equations, which are stored in a coefficient (parameter) vector.

**Options**:

- `variance(vname)`: specify parameter variance matrix of the <span class="env-green">**estimated parameters**</span>.

  This option only has an effect if you specify the `simulate()` option when calling `forecast solve` and request `sim_technique`’s `betas` or `residuals`.

- `errorvariance(ename) `: specify <span class="env-green">**additive error term**</span> with variance matrix `ename`, where `ename` is the name of s Stata matrix. The number of rows and columns in `ename` must match the number of equations represented by coefficient vector `cname`. 

  This option only has an effect if you specify the `simulate()` option when calling `forecast solve` and request `sim_technique`’s `betas` or `residuals`.

- `names(namelist[ , replace ])`: instructs `forecast coefvector` to use namelist as the names of the left-hand-side variables in the coefficient vector being added. By default, `forecast coefvector` uses the equation names on the column stripe of cname. 

  You must use this option if any of the equation names stored with `cname` contains **time-series operators**.


You use `forecast coefvector` to add endogenous variables to your model that are defined by linear equations, where the linear equations are stored in a coefficient (parameter) vector.

```stata
// Incorporate coefficient vector of the endogenous equation of y to be used by forecast solve
forecast coefvector y
```



Ex. We want to add the following eqns to a forecast model.
$$
\begin{split}
x_t &= 0.2 + 0.3 x_{t-1} - 0.8 z_t \\
z_t &= 0.1 + 0.7 z_{t-1} + 0.3 x_t - 0.2 x_{t-1}
\end{split}
$$

We first define the coefficient vector `eqvector`.

```stata
// define a row vector
matrix eqvector = (0.2, 0.3, -0.8, 0.1, 0.7, 0.3, -0.2)
// add equation names and variale names
// equation names are before the colon
// variable names are after the colon
matrix coleq eqvector = x:_cons x:L.x x:y y:_cons y:L.y y:x y:L.x
matrix list eqvector
```

<img src="https://drive.google.com/thumbnail?id=13Jf_mLoNG1PnRiyx3Jblm7UhTYCgWNUy&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

We could then add the coefficient vector to a forecast model.

```stata
forecast create
forecast coefvector y
```


--------------------------------------------------------------------------------

#### Declare exogenous variables

```stata
forecast exogenous varlist
```

Declaring exogenous variables with forecast exogenous is not explicitly necessary, but we nevertheless <span class="env-green">**strongly encourage doing so**</span>. 

Stata can check the exogenous variables **before** solving the model and issue an appropriate error message if missing values are found, whereas troubleshooting models for which forecasting failed is more difficult after the fact.

**Undeclared exogenous variables** that contain missing values within the forecast horizon will cause `forecast solve` to exit with a less-informative error message and require the user to do more work to pinpoint the problem.


Summary:

Endogenous variables are added to the forecast model via `forecast estimates`, `forecast identity`, and `forecast coefvector`. 

- Equations added via `forecast estimates` are always stochastic, 
- while equations added via `forecast identity` are always nonstochastic. 
- Equations added via `forecast coefvector` are treated as stochastic if options `variance()` or `errorvariance()` (or both) are specified and nonstochastic if neither is specified.



--------------------------------------------------------------------------------

#### forecast adjust


`forecast adjust` adjusts a variable by add factoring, replacing, etc.


```stata
forecast adjust varname = exp [if] [in]
```

`varname` is the name of the endogenous variable that has been previously added to the model using `forecast estimates` or `forecast coefvector`.

`forecast adjust` specifies an adjustment to be applied to an endogenous variable in the model. Adjustments are typically used to produce alternative forecast scenarios or to incorporate outside information into a model.


```stata
// Adjust the endogenous variable y in forecast to account for the variable shock in 1990
forecast adjust y = y + shock if year==1990
```



___

### Solve the foreceast

`forecast solve` computes static or dynamic forecasts based on the model currently in memory. Before you can solve a model, you must first create a new model using `forecast create` and add equations and variables to it using `forecast estimates`, `forecast coefvector`, or `forecast identity`.

```stata
forecast solve [, { prefix(string) | suffix(string) } options ]
```

**Options**:

- `prefix(string)` and `suffix(string)` specify prefix/suffix for forecast variables.

  You may specify `prefix()` or `suffix()` but NOT both. 

  By default, forecast values will be prefixed by `f_`.

- `begin(time_constant)` and `end(time_constant)` specify period to begin/end forecasting

- `periods(#)` specify number of periods to forecast

- `static` produce static forecasts instead of dynamic forecasts

  **Actual values** of variables are used wherever lagged values of the endogenous variables appear in the model. Static forecasts are also called **one-step-ahead forecasts**.

  By default, <span class="env-green">**dynamic forecasts**</span> are produced, which use the *forecast values of variables wherever lagged values of the endogenous variables* appear in the model. 

- `actuals` use actual values if available instead of forecasts

  `actuals` specifies how nonmissing values of endogenous variables in the forecast horizon are treated. By default, nonmissing values are ignored, and forecasts are produced for all endogenous variables.
  When you specify `actuals`, `forecast` sets the forecast values <u>equal to the actual values if they are nonmissing</u>. The forecasts for the other endogenous variables are then conditional on the known values of the endogenous variables with nonmissing data.

- `log(log_level)` `loglevel` takes on one of the following values

  - `on`: default, provides an iteration log showing the current panel and period for which the model is being solved as well as a sequence of dots for each period indicating the number of iterations.
  - `off`: suppress the iteration log.
  - `detail`: a detailed iteration log including the current values of the convergence criteria for each period in each panel (in the case of panel data) for which the model is being solved.
  - `brief`: produces an iteration log showing the current panel being solved but does not show which period within the current panel is being solved.

- `simulate(sim_technique, sim_statistic sim_options)` allows you to simulate your model to obtain <span class="env-green">**measures of uncertainty surrounding the point forecasts**</span> produced by the model. 
  
  Simulating a model involves repeatedly solving the model, each time accounting for the uncertainty associated with the error terms and the estimated coefficient vectors.

  - `sim_technique` can be `betas`, `errors`, or `residuals`.

    - `betas`: draw multivariate-normal parameter vectors ← sampling error from the estimated coefficients
    - `errors`: draw additive errors from multivariate normal distribution ← uncertainty from the stochastic error terms; errors drawn from a normal distribution with mean zero and variance equal to the estimated variance of the error terms
    - `residuals`: draw additive residuals based on static forecast errors; errors drawn from the pool of static-forecast residuals

  - `sim_statistic` specifies a **summary statistic to summarize the forecasts** over all the simulations.

    ```stata
    statistic(statistic, { prefix(string) | suffix(string) })
    ```

    `statistic` can be `mean`, `variance`, or `stddev`. You may specify either the prefix or the suffix that will be used to name the variables that will contain the requested `statistic`.

    ```stata
    statistic(stddev, prefix(sd_))
    ```

    This will store the standard deviations of our forecasts in variables prefixed with `sd_`.

  - `sim_options` includes
    - <span class="env-green">`reps(#)`</span> request that `forecast solve` perform `#` replications; default is `reps(50)`
    - `saving(filename, …)` save results to file
    - `nodots` suppress replication dots.  By default, one dot character is displayed for each successful replication. If during a replication convergence is not achieved, forecast solve exits with an error message.
    



___

### Use example: forecast a panel 

$$
\%\Delta \text{dim}_{it} = \beta_0 + \beta_1 \ln(\text{starts}_{it}) + \beta_2 \text{rgspgrowth}_{it} + \beta_3 \text{unrate}_{it} + u_{i} + \varepsilon_{it}
$$

$u_{i}$ refers to individual fixed effects. 

When we make forecasts for any individual panel, we may want to include it in our forecasts. This can be achieved by using `forecast adjust`.

```stata
use https://www.stata-press.com/data/r19/statehardware, clear
generate lndim = ln(dim)
generate lnstarts = ln(starts)
quietly xtreg D.lndim lnstarts rgspgrowth unrate if qdate <= tq(2009q4), fe
predict dlndim_u, u  /* obtain individual fixed effects */
estimates store dim  /* store estimation results */
```

With enough observations, we can have more confidence in the estimated panel-specific errors. 
If we are willing to assume that we have decent estimates of the panel-specific errors and that those panel-level effects will remain constant over the forecast horizon, then we can *incorporate them into our forecasts*. 

Because predict only provided us with estimates of the panel-level effects for the estimation sample, we need to **extend them into the forecast horizon**. 
An easy way to do that is to use `egen` to create a new set of variables:

```stata
// extend panel fixed effects to the forecast horizon
by state: egen dlndim_u2 = mean(dlndim_u)
```

We can use `forecast adjust` to incorporate these terms into our forecasts. 

The following commands define our forecast model, including the estimated panel-specific terms:

```stata
/* create forecast model */
forecast create statemodel, replace   
/* add equations, rename the endog variable, D.lndim, to be forecasted as dlndim */
/* since the original endog variable name includes a time series operator
   it is required to name, otherwise will return error */
forecast estimates dim, name(dlndim)  
/* add state fixed effects */
forecast adjust dlndim = dlndim + dlndim_u2 
```

- Note that our dependent variable contains a time series operator, we must use `name(dlndim)` option of `forecast estimates` to specify a valid name for the endogenous variable being added.

- `dlndim` stands for the first difference of the logarithm of `dim`. We are interested in the level of `dim`, so we need to back out `dim` from `dlndim`.

  → We use `forecast identity` to obtain the actual `dim` variable.

```stata
// reverse first difference, note that you refer to the endog var using the new name, dlndim, now
forecast identity lndim = L.lndim + dlndim
// reverse natural logarithm
forecast identity dim = exp(lndim)
```

We used forecast adjust to perform our adjustment to `dlndim` immediately after we added those estimation results so that we would not forget to do so.
However, we <span class="env-green">could specify the adjustment at any time</span>. 

Regardless of when you specify an adjustment, `forecast solve` performs those adjustments immediately after the variable being adjusted is computed.

Finally we can solve the model. Here we obtain dynamic forecasts beginning in the first quarter of 2010:

```stata
forecast solve, begin(tq(2010q1)) log(off)
```





