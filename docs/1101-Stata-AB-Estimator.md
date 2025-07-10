## Arellano-Bond Estimator

If an equation did contain a lagged dependent variable, then one could use a **dynamic panel-data** (DPD) estimator such as `xtabond`, `xtdpd`, or `xtdpdsys`. DPD estimators are designed for cases where the number of observations per panel $T$ is small.

As shown by @Nickell1981, the bias of the standard
fixed- and random-effects estimators in the presence of lagged dependent variables is of order $1/T$ and is thus particularly severe when each panel has relatively few observations.


@Judson1999 perform Monte Carlo experiments to examine the relative performance of different panel-data estimators in the presence of lagged dependent variables when used with panel datasets having dimensions more commonly encountered in macroeconomic applications. Based on their results, 

- The bias of the standard fixed-effects estimator (LSDV in their notation) is not inconsequential even when $T=20.$
- For $T=30$, the fixed-effects estimator does work as well as most alternatives. 
  
  The only estimator that appreciably outperformed the standard fixed-effects estimator when $T=30$ is the least-squares dummy variable corrected estimator (LSDVC in their notation). 

   @Bruno2005 provides a Stata implementation of that estimator.

The [Arellano–Bond estimator](https://www.stata.com/manuals/xtxtabond.pdf) is for datasets with many panels and few periods. (Technically, the large-sample properties are derived with the number of panels going to infinity and the number of periods held fixed.) The number of instruments increases quadratically in the number of periods. If your dataset is better described by a framework in which both the number of panels and the number of periods is large, then you should consider other estimators such as `xtiveg` or `xtreg, fe`.

The Arellano-Bond estimator may be obtained in Stata using either the `xtabond` or `xtdpd` command.

`xtabond` fits a linear dynamic panel-data model where the unobserved unit-level effects are correlated with the lags of the dependent variable, known as the Arellano–Bond estimator. This estimator is designed for datasets with many panels and few periods, and it requires that there be **no autocorrelation** in the idiosyncratic errors.

`xtabond` uses moment conditions in which lags of the dependent variable and first differences of the exogenous variables are instruments for the first-differenced equation.

```stata
xtabond depvar [ indepvars ] [ if ] [ in ] [, options ]
```

**Options**:

- `lags(#)`:  #lags of dependent variable as covariates; default is <span style='color:#008B45'>`lags(1)`</span>
- `maxldep(#)`: maximum lags of dependent variable for use as instruments
- `maxlags(#)`: maximum lags of predetermined and endogenous variables for use as instruments
- `twostep`: compute the two-step estimator instead of the one-step estimator
- `pre(varlist)`: predetermined variables; can be specified more than once
- `endogenous(varlist)`: endogenous variables; can be specified more than once
- `vce(vcetype)`
    - `vce(gmm)` the default, uses the conventionally derived variance estimator for generalized method of moments estimation.
    - `vce(robust)`: uses the robust estimator. After one-step estimation, this is the Arellano–Bond robust VCE estimator. After two-step estimation, this is the Windmeijer (2005) WC-robust estimator.



$$
\begin{equation} (\#eq:AB-model)
\begin{split}
n_{i,t}
&= \alpha_1 n_{i,t-1} + \alpha_2 n_{i,t-2} + \bbeta'(L) \bx_{it} + \lambda_t + \eta_i + \varepsilon_{i,t} \\
&= \alpha_1 n_{i,t-1} + \alpha_2 n_{i,t-2}  \\
&\phantom{=}\quad  + \beta_1 w_{i,t} + \beta_2 w_{i,t-1} \\
&\phantom{=}\quad  + \beta_3 k_{i,t} + \beta_4 k_{i,t-1} + \beta_5 k_{i,t-2} \\
&\phantom{=}\quad + \beta_6 ys_{i,t} + \beta_7 ys_{i,t-1} + \beta_8 ys_{i,t-2}  \\
&\phantom{=}\quad + \gamma_3 d_3 + \dots + \gamma_T d_T + \eta_i + \varepsilon_{i,t},
\end{split}
\end{equation}
$$

where $i=1,\ldots,n$ denotes the firm, and $t=3,\ldots,T$ is the time series dimension. 

- $n_{i,t}$ is the natural logarithm of *employment*, first and second lagged were used as independent variables

- $w$ refers to the natural logarithm of *wage*, up to lag 1

- $k$ is the natural logarithm of *capital*, up to lag 2

- $ys$ is the natural logarithm of *output*, up to lag 2

- Variables $d_3,\ldots,d_T$ are time dummies with corresponding coefficients $\gamma_3,\ldots,\gamma_T.$

- $\eta_i$ is the unobserved individual-specific effects.

- $\varepsilon_{i,t}$ is an idiosyncratic remainder component.

Model \@ref(eq:AB-model) can be implemented using the following command.

```stata
// Use example
use https://www.stata-press.com/data/r19/abdata
xtabond n l(0/1).w l(0/2).(k ys) yr1980-yr1984 year, lags(2) vce(robust) noconstant
```

The output would look like the following.

<pre class="nowrap"><code>
Arellano–Bond dynamic panel-data estimation     Number of obs     =        611
Group variable: id                              Number of groups  =        140
Time variable: year
                                                Obs per group:
                                                              min =          4
                                                              avg =   4.364286
                                                              max =          6

Number of instruments =     40                  Wald chi2(13)     =    1318.68
                                                Prob > chi2       =     0.0000
One-step results
                                     (Std. err. adjusted for clustering on id)

 	 	                  Robust
   n 	 	 Coefficient  std. err.      z    P>|z|     [95% conf. interval]

   n 	 
 L1. 	 	   .6286618   .1161942     5.41   0.000     .4009254    .8563983
     	 
   w 	 
 --. 	 	  -.5104249   .1904292    -2.68   0.007    -.8836592   -.1371906
 L1. 	 	   .2891446    .140946     2.05   0.040     .0128954    .5653937
 L2. 	 	  -.0443653   .0768135    -0.58   0.564     -.194917    .1061865
     	 
   k 	 
 --. 	 	   .3556923   .0603274     5.90   0.000     .2374528    .4739318
 L1. 	 	  -.0457102   .0699732    -0.65   0.514    -.1828552    .0914348
 L2. 	 	  -.0619721   .0328589    -1.89   0.059    -.1263743    .0024301
     	 
yr1980 	 	  -.0282422   .0166363    -1.70   0.090    -.0608488    .0043643
yr1981 	 	  -.0694052    .028961    -2.40   0.017    -.1261677   -.0126426
yr1982 	 	  -.0523678   .0423433    -1.24   0.216    -.1353591    .0306235
yr1983 	 	  -.0256599   .0533747    -0.48   0.631    -.1302723    .0789525
yr1984 	 	  -.0093229   .0696241    -0.13   0.893    -.1457837    .1271379
year 	 	   .0019575   .0119481     0.16   0.870    -.0214604    .0253754

Instruments for differenced equation
        GMM-type: L(2/.).n
        Standard: D.w LD.w L2D.w D.k LD.k L2D.k D.yr1980 D.yr1981 D.yr1982
                  D.yr1983 D.yr1984 D.year
Instruments for level equation
        Standard: _cons
</code></pre>


`xtdpdsys` implements the Arellano–Bover/Blundell–Bond system estimator, which includes the lagged differences of `n` (the dependent variable) as instruments for the level equation.

--------------------------------------------------------------------------------

**Test for Autocorrelation**

The moment conditions of these GMM estimators are valid only if there is no serial correlation in the idiosyncratic errors. Because the first difference of white noise is necessarily autocorrelated, we need only concern ourselves with second and higher autocorrelation. We can use **`estat abond`** to test for autocorrelation:

```stata
. estat abond, artests(4)

Arellano–Bond test for zero autocorrelation in first-differenced errors
H0: No autocorrelation 

Order         z   Prob > z
    1   -4.6414     0.0000
    2   -1.0572     0.2904
    3   -.19492     0.8455
    4   .04472      0.9643
```



**Test for Overidentifying Restrictions**

`estat sargan` reports the Sargan test of overidentifying restrictions.

```stata
. estat sargan

Sargan test of overidentifying restrictions
H0: Overidentifying restrictions are valid
		chi2(25) = 65.81806
		Prob > chi2 = 0.0000
```



--------------------------------------------------------------------------------

**Predetermined Covariates**

Sometimes we cannot assume strict exogeneity. Recall that a variable, $x_{it}$, is said to be strictly exogenous if $\E[𝑥_{it}\varepsilon_{is}] = 0$ for all $t$ and $s$. 

If $\E[x_{it}\varepsilon_{is}] \ne 0$ for $s < t$ but $\E[x_{it}\varepsilon_{is}] = 0$ for all $s\ge t,$ the variable is said to be <span style='color:#008B45'>**predetermined**</span>. Intuitively, if the error term at time $t$ has some feedback on the subsequent realizations of $x_{it},$ $x_{it}$ is a predetermined variable. Because unforecastable errors today might affect future changes in the real wage and in the capital stock, we might suspect that the log of the real product wage and the log of the gross capital stock are predetermined instead of strictly exogenous.

We also call predetermined $x_{it}$ as <span style='color:#008B45'>**sequential exogenous**</span>.

Here we treat $w$ and $k$ as predetermined and use lagged levels as instruments.

```stata
xtabond n l(0/1).ys yr1980-yr1984 year, lags(2) twostep pre(w, lag(1,.)) pre(k, lag(2,.)) noconstant vce(robust)
```

We are now including GMM-type instruments from the first lag of `L.w` on back and from the first lag of `L2.k` on back.

`pre(w, lag(1, .))` to mean that `L.w` is a predetermined variable and `pre(k, lag(2, .))` to mean that `L2.k` is a predetermined variable. 



**Endogenous Covariates**

We might instead suspect that $w$ and $k$ are endogenous in that  $\E[x_{it}\varepsilon_{is}] \ne 0$ for $s \le t$ but $\E[x_{it}\varepsilon_{is}] = 0$ for all $s > t.$

By this definition, endogenous variables differ from predetermined variables only in that the

- endogenous variables allow for correlation between $x_{it}$ and $\varepsilon_{it}$ at time $t,$ whereas

  Endogenous variables are treated similarly to the *lagged dependent variable*. Levels of the endogenous variables lagged two or more periods can serve as instruments.

- predetermined variables do <span style='color:#FF9900'>**NOT**</span> allow for contemporaneous correlation.

In this example, we treat $w$ and $k$ as endogenous variables.

```stata
xtabond n l(0/1).ys yr1980-yr1984 year, lags(2) twostep endogenous(w, lag(1,.)) endogenous(k, lag(2,.)) noconstant vce(robust)
```

Although some estimated coefficients changed in magnitude, none changed in sign, and these results are similar to those obtained by treating $w$ and $k$ as predetermined.

Prefix `xtabond` with `xi:` if you need to include factor variables

```stata
// AB estimator with factor variables
xi: xtabond logd_gdp tmp tmp2 pre pre2 ///
	tmp_pre tmp2_pre tmp_pre2 tmp2_pre2 ///
	i.year i.iso|year_id i.iso|year_id2, ///
	lags(1) vce(robust)
```

- `i.year`: time fixed effects;

- `i.iso|year_id`: country-specific linear time trends

- `i.iso|year_id2`: country-specific quadratic time trends



___

Forecast under `xtabond`: 

- <https://www.stata.com/stata-news/news29-3/forecast/>








--------------------------------------------------------------------------------

### xtabond2

`xtabond2` was written by David Roodman. More versatile than `xtabond`. 

| `xtabond`                                                    | `xtabond2`               |
| ------------------------------------------------------------ | ------------------------ |
| Not support factor variables<br />Can be fixed with `xi: xtabond` | Support factor variables |




```stata
xtabond2 depvar varlist [if exp] [in range] [weight] [, level(#)
        svmat svvar twostep robust cluster(varlist) noconstant small 
				gmmopt [gmmopt ...] ivopt [ivopt ...]]
```

**Options**:

- `level(#)` confidence level, default to `level(95)`

- `gmmopt`

  ```stata
  gmmstyle(varlist [, laglimits(# #) collapse orthogonal equation({diff | level | both}) passthru split])
  ```
  
  `gmmstyle` specifies a set of variables to be used as bases for "GMM-style" instrument sets described in Holtz-Eakin, Newey, and Rosen (1988) and Arellano and Bond (1991).  By default xtabond2 uses, for each time period, all available lags of the specified variables in levels dated $t-1$ or earlier as instruments for the transformed equation; and uses the contemporaneous first differences as instruments in the levels equation. These defaults are appropriate for predetermined variables that are not strictly exogenous (Bond 2000). Missing values are always replaced by zeros.
  
  Since the `gmmstyle()` varlist allows time-series operators, there are many routes to the same specification.  E.g., `gmm(w, lag(2 .))`, the standard treatment for an endogenous variable, is equivalent to `gmm(L.w, lag(1 .))`, thus `gmm(L.w)`.


- `ivopt`

  ```stata
  ivstyle(varlist [, equation({diff | level | both}) passthru mz])
  ```

  `ivstyle` specifies a set of variables to serve as standard instruments, with one column in the instrument matrix per variable.  Normally, strictly exogenous regressors are included in `ivstyle` options, in order to enter the instrument matrix, as well as being listed before the main comma of the command line. 
  
  The `equation()` suboption specifies which equation(s) should use the instruments: 
  
  - `equation(diff)`: first-difference only
  - `equation(level)`: levels only
  - `equation(both)`: both, default



**A matching triplet** using different pkgs to achieve the same results (pp42, [Stata Journal article by David Roodman](https://journals.sagepub.com/doi/pdf/10.1177/1536867X0900900106))

```stata
xtabond n, lags(1) pre(w, lagstruct(1,.)) pre(k, endog) robust
xtdpd n L.n w L.w k, dgmmiv(w k n) vce(robust)
xtabond2 n L.n w L.w k, gmmstyle(L.(w n k), eq(diff)) robust
```

<https://www.statalist.org/forums/forum/general-stata-discussion/general/1548924-xtabond-vs-xtabond2-how-to-get-the-same-results>









