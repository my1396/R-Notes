## Panel

**Declare panel data**

You must `xtset` your data before you can use other `xt` commands.

`xtset panelvar timevar [, tsoptions]` declares the data to be a panel in which the order of observations is relevant. When you specify `timevar`, you can then use time series operators (e.g., `L`, `D`).

`tsoptions` can be specified using

- unit of `timevar`, e.g., `yearly`, `quarterly`.
- `delta(#)` specifies the time increment between observations in `timevar` units.

**Example**

To set a panel dataset:

```stata
// string variables not allowed in varlist; need to convert them to numeric
. egen float country_id = group(iso)
. egen float year_id = group(year)

. xtset country_id year_id, yearly

Panel variable: country_id (strongly balanced)
 Time variable: year_id, 1 to 59
         Delta: 1 year
```

**Menu**

Statistics > Longitudinal/panel data > Setup and utilities > Declare dataset to be panel data

- `panelvar`  panel variable that identifies the unit
- `timevar` optional time variable that identifies the time within panels

Use `describe` to show an overview of data structure.

Sometimes numbers will get recorded as string variables, making it impossible to do almost any command.

```stata
destring [varlist], {gen(newvarlist) | replace} [options]
```

- `gen(newvarlist)` generate new variables for each variable in `varlist`.
- `replace` replace string variables with numeric variables
- `ignore("chars")` specifies nonnumeric characters be removed.

```stata
// from logd_gdp to rad, convert to numeric, replace "NA" with missing
destring logd_gdp-rad, replace ignore(`"NA"')
```



--------------------------------------------------------------------------------

### `xtreg`

`xtreg` is Stata's feature for fitting linear models for panel data.

<div class="rmd-caution">
<code>xtreg</code> is only used for one-way cluster SE estimation, such as individual, firm, or country fixed effects. For two-way cluster SE estimation, use the <code>reghdfe</code> command
</div>

`xtreg, fe` estimates the parameters of fixed-effects models:


```stata
xtreg depvar [indepvars] [if] [in] [weight] , fe [FE_options]
```

Menu: Statistics > Longitudinal/panel data > Linear models > Linear regression (FE, RE, PA, BE, CRE)

**Options:**

- `vce(robust)` use clustered variance that allows for intragroup correlation within groups.
  
  `vce` stands for variance-covariance estimation.

  By default, SE uses OLS estimates, which is invalid in presence of heteroskedasticity or serial correlation. Use `vce(robust)` to get robust SE.

  Other vce types include `vce(bootstrap)` and `vce(jackknife)`. 

- `vce(cluster clustvar)` use cluster-robust variance that allows for intragroup correlation within groups. 

  The `clustvar` variable must be a variable that identifies the clusters.

What `xtreg, fe` does is known as the within estimator to the following model:

$$
y_{it} = \alpha + \bx_{it}\bbeta' + \nu_i + \varepsilon_{it}
$$

where $\nu_i$ is the unobserved individual effect; $\varepsilon_{it}$ is the error term with the usual assumptions (mean 0, uncorrelated with itself, uncorrelated with $\bx$, uncorrelated with $\nu$, and homoskedastic).

#### Goodness-of-fit

Three versions of R-squared are reported in the output of `xtreg, fe`:

| R-squared | Description |
| ---------- | ----------- |
| Regular $R^2 = \frac{\var(\hat{y}_{it})}{\var(y)_{it}}$ | $\hat{y}_{it} = \hat{\alpha} + \hat{\bx}_{it}\hat{\bbeta}'$ | 
| Between $R^2 = \frac{\var(\hat{\bar{y}}_i)}{\var(\bar{y}_t)}$ | $\hat{\bar{y}}_i = \hat{\alpha} + \bar{\bx}_{it}\hat{\bbeta}'$ |
| Within $R^2 = \frac{\var(\hat{\tilde{y}}_{it})}{\var(\tilde{y}_{it})}$ | $\hat{\tilde{y}}_{it} = \hat{y}_{it} - \hat{\bar{y}}_i = (\bx_{it} - \bar{\bx}_i)\hat{\bbeta}'$ |

where 

$$
\bar{y}_i = \frac{1}{T_i}\sum_{t=1}^{T_i} y_{it}, 
$$

and

$$
\bar{\bx}_i = \frac{1}{T_i}\sum_{t=1}^{T_i} \bx_{it}.
$$

`estat mundlak` performs a Mundlak specification test to help decide whether to use a fixed-effects or random-effects model. The null hypothesis is that the random-effects model is appropriate.

### High-dimensional fixed effects

For instance, we may want to study the effect of import tariffs (`imports`) on yearly trade volume (`trade`) and include year, country, and industry as controls.

This can be achieved using `xtreg, fe absorb(year country industry)`, but it is slower than `areg` or `reghdfe`. 



### Test for serial correlation

However, Wooldridge (2002, 319--320) derives a simple test for autocorrelation in panel-data models. Drukker (2003) provides simulation results showing that the test has good size and power properties in reasonably sized samples.

There is a community-contributed program, called **xtserial**, written by David Drukker to perform this test in Stata. To install this community-contributed program, type

```stata
. search xtserial
. net sj 3-2 st0039         (or click on st0039)
. net install st0039        (or click on click here to install)
```


To use **xtserial**, you simply specify the dependent and independent variables:

```stata
. xtserial depvar indepvars 
```

A significant test statistic indicates the presence of serial correlation.
