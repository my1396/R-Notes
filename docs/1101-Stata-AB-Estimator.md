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

### xtabond Syntax

The Arellano-Bond estimator may be obtained in Stata using either the `xtabond` or `xtdpd` command.

[`xtabond`](https://www.stata.com/manuals/xtxtabond.pdf) fits a linear dynamic panel-data model where the unobserved unit-level effects are correlated with the lags of the dependent variable, known as the Arellano–Bond estimator. This estimator is designed for datasets with many panels and few periods, and it requires that there be **no autocorrelation** in the idiosyncratic errors.

`xtabond` uses moment conditions in which lags of the dependent variable and first differences of the exogenous variables are instruments for the first-differenced equation.

```stata
xtabond depvar [ indepvars ] [ if ] [ in ] [, options ]
```

**Estimation Options**:

- `noconstant`: suppress the constant term.
- `lags(#)`: <span class="env-green">**#lags of dependent variable**</span> as covariates; default is <span style='color:#008B45'>`lags(1)`</span>
- `maxldep(#)`: maximum lags of dependent variable for use as instruments. Defaults to $T_i-p-2,$ where $p$ is the number of lags of the dependent variable to be included in the model (i.e., `lags(#)`).
- `maxlags(#)`: maximum lags of predetermined and endogenous variables for use as instruments
- `twostep`: compute the two-step estimator instead of the one-step estimator
- `pre(varlist)`: **predetermined variables**; can be specified more than once
- `endogenous(varlist)`: **endogenous variables**; can be specified more than once
- `vce(vcetype)`
    - `vce(gmm)` the default, uses the conventionally derived variance estimator for generalized method of moments estimation.
    - `vce(robust)`: uses the robust estimator. After one-step estimation, this is the Arellano–Bond robust VCE estimator. After two-step estimation, this is the Windmeijer (2005) WC-robust estimator.

**Quick Start**

- Arellano--Bond estimation of y on x1 and x2 using xtset data

  ```stata
  xtabond y x1 x2
  ```

- One-step estimator with robust standard errors

  ```stata
  xtabond y x1 x2, vce(robust)
  ```

- Two-step estimator with bias-corrected robust standard errors

  ```stata
  xtabond y x1 x2, vce(robust) twostep
  ```

- Arellano--Bond estimation also including 2 lagged values of y

  ```stata
  xtabond y x1 x2, lags(2)
  ```

### Use Example {#use-example}


@Arellano1991 apply their new estimators and test statistics to a model of dynamic labor demand that had previously been considered by Layard and Nickell (1986), using data from an unbalanced panel of firms from the United Kingdom. All variables are indexed over the firm $i$ and time $t$.

$$
\begin{equation} (\#eq:AB-model)
\begin{split}
n_{i,t}
&= \alpha_1 n_{i,t-1} + \alpha_2 n_{i,t-2} + \bbeta'(L) \bx_{it} + \lambda_t + \eta_i + \varepsilon_{i,t} \\
&= \alpha_1 n_{i,t-1} + \alpha_2 n_{i,t-2}  \\
&\phantom{=}\quad  + \beta_1 w_{i,t} + \beta_2 w_{i,t-1} \\
&\phantom{=}\quad  + \beta_3 k_{i,t} + \beta_4 k_{i,t-1} + \beta_5 k_{i,t-2} \\
&\phantom{=}\quad + \beta_6 ys_{i,t} + \beta_7 ys_{i,t-1} + \beta_8 ys_{i,t-2}  \\
&\phantom{=}\quad + \gamma_3 d_3 + \dots + \gamma_T d_T + \pi\, t + \eta_i + \varepsilon_{i,t},
\end{split}
\end{equation}
$$

where $i=1,\ldots,n$ denotes the firm, and $t=3,\ldots,T$ is the time series dimension. 

- $n_{i,t}$ is the natural logarithm of *employment*, **first and second lagged** were used as independent variables

- $w$ refers to the natural logarithm of *wage*, up to lag 1

- $k$ is the natural logarithm of *capital*, up to lag 2

- $ys$ is the natural logarithm of *output*, up to lag 2

- Variables $d_3,\ldots,d_T$ are time dummies with corresponding coefficients $\gamma_3,\ldots,\gamma_T.$

- $t$ is a time trend with coefficient $\pi.$

- $\eta_i$ is the unobserved individual-specific effects.

- $\varepsilon_{i,t}$ is an idiosyncratic remainder component.

Model \@ref(eq:AB-model) can be implemented using `xtabond`.

```stata
// Use example of xtabond
use https://www.stata-press.com/data/r19/abdata
xtabond n l(0/1).w l(0/2).(k ys) yr1980-yr1984 year, lags(2) vce(robust) noconstant

// Equivalent command using xtdpd
xtdpd L(0/2).n L(0/1).w L(0/2).(k ys) yr1980-yr1984 year, noconstant div(L(0/1).w L(0/2).(k ys) yr1980-yr1984 year) dgmmiv(n)
```

- lagged dependent variables `n`: up to 2 lags
- lagged independent variables
  - `w`: up to 1 lag
  - `k` and `ys`: up to 2 lags

Note that

- without specifying `div()`, the default of `xtdpd` is to use levels of the dependent variables as instruments for the difference equation.

- By contrast, `xtabond` by default uses the first difference of all the exogenous variables as standard instruments for the difference equation.

- To use the same instruments as `xtabond`, we need to specify `div()`.

--------------------------------------------------------------------------------

The `xtabond` output would look like the following.

<pre class="nowrap"><code>
. xtabond n l(0/1).w l(0/2).(k ys) yr1980-yr1984 year, lags(2) vce(robust) noconstant

Arellano–Bond dynamic panel-data estimation     Number of obs     =        611
Group variable: id                              Number of groups  =        140
Time variable: year
                                                Obs per group:
                                                              min =          4
                                                              avg =   4.364286
                                                              max =          6

Number of instruments =     41                  Wald chi2(16)     =    1727.45
                                                Prob > chi2       =     0.0000
One-step results
                                     (Std. err. adjusted for clustering on id)
------------------------------------------------------------------------------
             |               Robust
           n | Coefficient  std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
           n |
         L1. |   .6862261   .1445943     4.75   0.000     .4028266    .9696257
         L2. |  -.0853582   .0560155    -1.52   0.128    -.1951467    .0244302
             |
           w |
         --. |  -.6078208   .1782055    -3.41   0.001    -.9570972   -.2585445
         L1. |   .3926237   .1679931     2.34   0.019     .0633632    .7218842
             |
           k |
         --. |   .3568456   .0590203     6.05   0.000      .241168    .4725233
         L1. |  -.0580012   .0731797    -0.79   0.428    -.2014308    .0854284
         L2. |  -.0199475   .0327126    -0.61   0.542    -.0840631    .0441681
             |
          ys |
         --. |   .6085073   .1725313     3.53   0.000     .2703522    .9466624
         L1. |  -.7111651   .2317163    -3.07   0.002    -1.165321   -.2570095
         L2. |   .1057969   .1412021     0.75   0.454    -.1709542     .382548
             |
      yr1980 |   .0029062   .0158028     0.18   0.854    -.0280667    .0338791
      yr1981 |  -.0404378   .0280582    -1.44   0.150    -.0954307    .0145552
      yr1982 |  -.0652767   .0365451    -1.79   0.074    -.1369038    .0063503
      yr1983 |  -.0690928    .047413    -1.46   0.145    -.1620205    .0238348
      yr1984 |  -.0650302   .0576305    -1.13   0.259    -.1779839    .0479235
        year |   .0095545   .0102896     0.93   0.353    -.0106127    .0297217
------------------------------------------------------------------------------
Instruments for differenced equation
        GMM-type: L(2/.).n
        Standard: D.w LD.w D.k LD.k L2D.k D.ys LD.ys L2D.ys D.yr1980
                  D.yr1981 D.yr1982 D.yr1983 D.yr1984 D.year
</code></pre>

The footer in the output reports the instruments used.

- The first line indicates that `xtabond` used lags from 2 on back to create the GMM-type instruments described in Arellano and Bond (1991) and Holtz-Eakin, Newey, and Rosen (1988); also see Methods and formulas in [XT] xtdpd. 
- The second and third lines indicate that the first difference of all the exogenous variables were used as standard instruments. 

--------------------------------------------------------------------------------

The following is the output of the equivalent command using `xtdpd`.

- Without specifying `div()`.

<pre class="nowrap"><code>
. xtdpd L(0/2).n L(0/1).w L(0/2).(k ys) yr1980-yr1984 year, noconstant dgmmiv(n)

Dynamic panel-data estimation                   Number of obs     =        611
Group variable: id                              Number of groups  =        140
Time variable: year
                                                Obs per group:
                                                              min =          4
                                                              avg =   4.364286
                                                              max =          6

Number of instruments =     27                  Wald chi2(16)     =     230.72
                                                Prob > chi2       =     0.0000
One-step results
------------------------------------------------------------------------------
           n | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
           n |
         L1. |   .7210638    .404417     1.78   0.075    -.0715789    1.513707
         L2. |   .0387296   .2178553     0.18   0.859     -.388259    .4657181
             |
           w |
         --. |  -.3089982   .5679262    -0.54   0.586    -1.422113    .8041166
         L1. |   .5261578   .5830132     0.90   0.367     -.616527    1.668843
             |
           k |
         --. |   1.312798   .5597144     2.35   0.019     .2157781    2.409818
         L1. |  -.2839418    .293703    -0.97   0.334    -.8595891    .2917054
         L2. |  -.1448001   .2486989    -0.58   0.560    -.6322411    .3426409
             |
          ys |
         --. |  -.2204921   .8476672    -0.26   0.795    -1.881889    1.440905
         L1. |   -.414458   1.167557    -0.35   0.723    -2.702827    1.873911
         L2. |  -2.635413   1.152849    -2.29   0.022    -4.894956   -.3758697
             |
      yr1980 |  -.0267764   .0721829    -0.37   0.711    -.1682524    .1146995
      yr1981 |  -.1019741   .1386003    -0.74   0.462    -.3736256    .1696775
      yr1982 |  -.2540348   .2046535    -1.24   0.214    -.6551483    .1470787
      yr1983 |  -.4411154   .2789873    -1.58   0.114    -.9879205    .1056897
      yr1984 |  -.4675579   .3241822    -1.44   0.149    -1.102943    .1678275
        year |   .0319349   .0421826     0.76   0.449    -.0507414    .1146113
------------------------------------------------------------------------------
Instruments for differenced equation
        GMM-type: L(2/.).n
</code></pre>


- With specifying `div()`.

<pre class="nowrap"><code>
. xtdpd L(0/2).n L(0/1).w L(0/2).(k ys) yr1980-yr1984 year, noconstant div(L(0/1).w L(0/2).(k ys)
>  yr1980-yr1984 year) dgmmiv(n)

Dynamic panel-data estimation                   Number of obs     =        611
Group variable: id                              Number of groups  =        140
Time variable: year
                                                Obs per group:
                                                              min =          4
                                                              avg =   4.364286
                                                              max =          6

Number of instruments =     41                  Wald chi2(16)     =    1757.07
                                                Prob > chi2       =     0.0000
One-step results
------------------------------------------------------------------------------
           n | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
           n |
         L1. |   .6862261   .1486163     4.62   0.000     .3949435    .9775088
         L2. |  -.0853582   .0444365    -1.92   0.055    -.1724523    .0017358
             |
           w |
         --. |  -.6078208   .0657694    -9.24   0.000    -.7367265   -.4789151
         L1. |   .3926237   .1092374     3.59   0.000     .1785222    .6067251
             |
           k |
         --. |   .3568456   .0370314     9.64   0.000     .2842653    .4294259
         L1. |  -.0580012   .0583051    -0.99   0.320     -.172277    .0562747
         L2. |  -.0199475   .0416274    -0.48   0.632    -.1015357    .0616408
             |
          ys |
         --. |   .6085073   .1345412     4.52   0.000     .3448115    .8722031
         L1. |  -.7111651   .1844599    -3.86   0.000      -1.0727   -.3496304
         L2. |   .1057969   .1428568     0.74   0.459    -.1741974    .3857912
             |
      yr1980 |   .0029062   .0212705     0.14   0.891    -.0387832    .0445957
      yr1981 |  -.0404378   .0354707    -1.14   0.254    -.1099591    .0290836
      yr1982 |  -.0652767    .048209    -1.35   0.176    -.1597646    .0292111
      yr1983 |  -.0690928   .0627354    -1.10   0.271    -.1920521    .0538664
      yr1984 |  -.0650302   .0781322    -0.83   0.405    -.2181665    .0881061
        year |   .0095545   .0142073     0.67   0.501    -.0182912    .0374002
------------------------------------------------------------------------------
Instruments for differenced equation
        GMM-type: L(2/.).n
        Standard: D.w LD.w D.k LD.k L2D.k D.ys LD.ys L2D.ys D.yr1980
                  D.yr1981 D.yr1982 D.yr1983 D.yr1984 D.year
</code></pre>


--------------------------------------------------------------------------------

`xtdpdsys` implements the Arellano–Bover / Blundell–Bond system estimator, which includes the lagged differences of `n` (the dependent variable) as instruments for the level equation.

--------------------------------------------------------------------------------

### Diagnostic Tests

#### Test for Autocorrelation

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


--------------------------------------------------------------------------------

#### Test for Overidentifying Restrictions

`estat sargan` reports the Sargan test of overidentifying restrictions.

The moment conditions are valid only if the idiosyncratic errors are i.i.d. We use the Sargan test to test the validity of the moment conditions. The null hypothesis ($H_0$) is that the overidentifying restrictions are valid, i.e., that the moment conditions are valid.



```stata
. estat sargan

Sargan test of overidentifying restrictions
H0: Overidentifying restrictions are valid
		chi2(25) = 65.81806
		Prob > chi2 = 0.0000
```

Noting that the Sargan test rejects the null hypothesis that the overidentifying restrictions are valid in the model with i.i.d. errors.


Now we fit the model using only the moment conditions constructed starting from the third lags as instruments of the first-differenced equation. 

```stata
. xtdpd L(0/2).n L(0/1).w L(0/2).(k ys) yr1980-yr1984 year, 
> noconstant div(L(0/1).w L(0/2).(k ys) yr1980-yr1984 year) dgmmiv(n, lag(3 .))
```

- `dgmmiv(n, lag(3 .)` means 
  - `n` is treated as endogenous.
  - use the **third and higher lags** of `n` as GMM-type instruments for the first-differenced equation.
  - `.` means "up to the maximum available lag."

(`xtdpd` output omitted)

```stata
. estat sargan

Sargan test of overidentifying restrictions
H0: Overidentifying restrictions are valid
        chi2(19)     =  23.91962
        Prob > chi2  =    0.1993
```

The results from `estat sargan` no longer reject the null hypothesis that the overidentifying restrictions are valid.




--------------------------------------------------------------------------------

### Predetermined Covariates

Sometimes we cannot assume strict exogeneity. Recall that a variable, $x_{it}$, is said to be strictly exogenous if $\E[𝑥_{it}\varepsilon_{is}] = 0$ for all $t$ and $s$. 

If $\E[x_{it}\varepsilon_{is}] \ne 0$ for $s < t$ but $\E[x_{it}\varepsilon_{is}] = 0$ for all $s\ge t,$ the variable is said to be <span style='color:#008B45'>**predetermined**</span>. Intuitively, if the error term at time $t$ has some feedback on the subsequent realizations of $x_{it},$ $x_{it}$ is a predetermined variable. Because unforecastable errors today might affect future changes in the real wage and in the capital stock, we might suspect that the log of the real product wage and the log of the gross capital stock are predetermined instead of strictly exogenous.

We also call predetermined $x_{it}$ as <span style='color:#008B45'>**sequential exogenous**</span>.

Here we treat $w$ and $k$ as predetermined and use lagged levels as instruments.

```stata
xtabond n l(0/1).ys yr1980-yr1984 year, lags(2) twostep pre(w, lag(1,.)) pre(k, lag(2,.)) noconstant vce(robust)
```

We are now including GMM-type instruments from the first lag of `L.w` on back and from the first lag of `L2.k` on back.

`pre(w, lag(1, .))` to mean that `L.w` is a predetermined variable and `pre(k, lag(2, .))` to mean that `L2.k` is a predetermined variable. 



### Endogenous Covariates

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


--------------------------------------------------------------------------------

**A matching triplet** using different pkgs to achieve the same results (pp42, [Stata Journal article by David Roodman](https://journals.sagepub.com/doi/pdf/10.1177/1536867X0900900106))

```stata
xtabond n, lags(1) pre(w, lagstruct(1,.)) pre(k, endog) robust
xtdpd n L.n w L.w k, dgmmiv(w k n) vce(robust)
xtabond2 n L.n w L.w k, gmmstyle(L.(w n k), eq(diff)) robust
```

<https://www.statalist.org/forums/forum/general-stata-discussion/general/1548924-xtabond-vs-xtabond2-how-to-get-the-same-results>


--------------------------------------------------------------------------------

### xtdpd

[Linear Dynamic panel data (DPD) estimation](https://www.stata.com/manuals/xtxtdpd.pdf) fits dynamic panel-data models by using the 

- Arellano–Bond or 
  
  also known as the "Difference GMM" estimator. Implemented in `xtabond`.
- the Arellano–Bover/Blundell–Bond system estimator
  
  aka, "System GMM" estimator. Implemented in `xtdpdsys`.

`xtdpd` can fit more complex models at the cost of a more complicated syntax. That the idiosyncratic errors follow a low-order MA process and that the predetermined variables have a more complicated structure than accommodated by `xtabond` and `xtdpdsys` are two common reasons for using `xtdpd` instead of `xtabond` or `xtdpdsys`.

**Syntax**

A panel variable and a time variable must be specified; use `xtset`.

```stata
xtdpd depvar [ indepvars ] [ if ] [ in ], dgmmiv(varlist [...]) [ options ]
```

Options:

- `dgmmiv(varlist [, lagrange(flag [llag])])` specifies **GMM-type instruments** for the **difference equation**; this is a mandatory option.
  
  - Levels of the variables are used to form GMM-type instruments for the difference equation. 
  - All possible lags are used, unless `lagrange(flag llag)` restricts the lags:
    - begin with `flag` and 
    - end with `llag`. 

- `div(varlist [, nodifference])` specifies additional standard instruments for the **difference equation**.
  
  Differences of the variables are used, unless `nodifference` is specified, which requests that levels of the variables be used as instruments for the difference equation. 

- Support time-series operators, e.g., `L.` and `D.`. See `help tsvarlist` for more information.
  `depvar`, `indepvars`, and all `varlists` may contain time-series operators;

- Prefix commands: `by`, `collect`, `statsby`, and `xi` are allowed. Use `help prefix commands` for more information.

- `vce(vcetype)` specifies the type of standard error reported. Two options:
  - `vce(gmm)`: the default; the conventionally derived variance estimator for generalized method of moments estimation.
  - `vce(robust)`: the robust estimator. After one-step estimation, this is the Arellano–Bond robust VCE estimator. After two-step estimation, this is the Windmeijer (2005) WC-robust estimator.


Refer to [Use Example](#use-example) for an illustration of **Difference GMM estimation**.


--------------------------------------------------------------------------------


### System GMM Estimation

Consider the following dynamic panel-data model: 

$$
y_{it} = \sum_{j=1}^p \alpha_j y_{i,t-j} + \bbeta' \bx_{it} + \nu_i + \varepsilon_{it} .
$$

- $\nu_i$ are the panel-level effects, which may be correlated with $\bx_{it}$
- $\varepsilon_{it}$ are i.i.d. or come from a low-order moving-average process, with variance $\sigma^2_\varepsilon$.

Building on the work of Arellano and Bover (1995), Blundell and Bond (1998) proposed a system estimator that uses moment conditions in which lagged differences are used as instruments for the level equation in addition to the moment conditions of lagged levels as instruments for the difference equation. The additional moment conditions are valid only if the initial condition 

$$
\E[\nu_i \Delta y_{i2}] = 0
$$

holds for all $i$; see Blundell and Bond (1998) and Blundell, Bond, and Windmeijer (2000).


Relevant Options for system GMM estimation:

- `lgmmiv(varlist [, lag(#)])` specifies GMM-type instruments for the **level equation**. 
  
  Differences of the variables are used to form GMM-type instruments for the level equation. 
  
  The default is to the first lag of the differences. If `lag(#)` is specified, then the `#th` lag of the differences will be used.

- `liv(varlist)` specifies additional standard instruments for the **level equation**.
  
  Levels of the variables are used as instruments for the level equation. 

```stata
// System estimator
xtdpd L(0/1).n L(0/2).(w k) yr1980-yr1984 year, div(L(0/1).(w k) yr1980-yr1984 year) dgmmiv(n) lgmmiv(n) hascons
```

(output omitted)

```stata
. estat sargan

Sargan test of overidentifying restrictions
H0: Overidentifying restrictions are valid
        chi2(31)     =  59.22907
        Prob > chi2  =    0.0017
```

We note that the Sargan test rejects the null hypothesis after fitting the model with i.i.d. errors.

Now we fit the model using the additional moment conditions constructed from the second lag of `n` as an instrument for the level equation.

```stata
xtdpd L(0/1).n L(0/2).(w k) yr1980-yr1984 year, div(L(0/1).(w k) yr1980-yr1984 year) dgmmiv(n, lag(3 .)) lgmmiv(n, lag(2)) hascons
```

Output

<pre class="nowrap"><code>
. xtdpd L(0/1).n L(0/2).(w k) yr1980-yr1984 year, 
> div(L(0/1).(w k) yr1980-yr1984 year) dgmmiv(n, lag(3 .)) lgmmiv(n, lag(2)) 
> hascons

Dynamic panel-data estimation                   Number of obs     =        751
Group variable: id                              Number of groups  =        140
Time variable: year
                                                Obs per group:
                                                              min =          5
                                                              avg =   5.364286
                                                              max =          7

Number of instruments =     38                  Wald chi2(13)     =    3680.01
                                                Prob > chi2       =     0.0000
One-step results
------------------------------------------------------------------------------
           n | Coefficient  Std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
           n |
         L1. |   .9603675    .095608    10.04   0.000     .7729794    1.147756
             |
           w |
         --. |  -.5433987    .068835    -7.89   0.000    -.6783128   -.4084845
         L1. |   .4356183   .0881727     4.94   0.000      .262803    .6084336
         L2. |  -.2785721   .1115061    -2.50   0.012    -.4971201   -.0600241
             |
           k |
         --. |   .3139331   .0419054     7.49   0.000     .2317999    .3960662
         L1. |   -.160103   .0546915    -2.93   0.003    -.2672963   -.0529096
         L2. |  -.1295766   .0507752    -2.55   0.011    -.2290943    -.030059
             |
      yr1980 |  -.0200704   .0248954    -0.81   0.420    -.0688644    .0287236
      yr1981 |  -.0425838   .0422155    -1.01   0.313    -.1253246     .040157
      yr1982 |   .0048723   .0600938     0.08   0.935    -.1129093     .122654
      yr1983 |   .0458978   .0785687     0.58   0.559    -.1080941    .1998897
      yr1984 |   .0633219   .1026188     0.62   0.537    -.1378074    .2644511
        year |  -.0075599    .019059    -0.40   0.692    -.0449148     .029795
       _cons |   16.20856   38.00619     0.43   0.670    -58.28221    90.69932
------------------------------------------------------------------------------
Instruments for differenced equation
        GMM-type: L(3/.).n
        Standard: D.w LD.w D.k LD.k D.yr1980 D.yr1981 D.yr1982 D.yr1983
                  D.yr1984 D.year
Instruments for level equation
        GMM-type: L2D.n
        Standard: _cons
</code></pre>


The estimate of the coefficient on `L.n` is now 0.96. Blundell, Bond, and Windmeijer (2000, 63–65) showthat the moment conditions in the system estimator remain informative as the true coefficient on `L.n` approaches unity. Holtz-Eakin, Newey, and Rosen (1988) show that because the large-sample distribution of the estimator is derived for fixed number of periods and a growing number of individuals there is no “unit-root” problem.


```stata
. estat sargan

Sargan test of overidentifying restrictions
H0: Overidentifying restrictions are valid
        chi2(24)     =  27.22585
        Prob > chi2  =    0.2940
```

The results from `estat sargan` no longer reject the null hypothesis that the overidentifying restrictions are valid.
