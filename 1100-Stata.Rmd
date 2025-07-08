# Stata

**Resources**:

- User Guide: <https://www.stata.com/manuals/u.pdf>
- Tutorial: <https://grodri.github.io/stata/>
- Quick start: <https://lanekenworthy.net/stata-quick-guide/>



`help <cmd_name>`: Get help for a command.

| Keyboard Shortcut | Description   |
| ----------------- | ------------- |
| ctrl + R          | last cmd      |
| ctrl + B          | next cmd      |
| cmd + shift + D   | Run a Do file |




**User interface**

Within the Stata interface window, there are five windows: Command, Results, History, Properties, and Variables

While Stata can be command-driven by typing code in the Command window, it can also be used in a **point-and-click** manner using the menu bar.

While nearly everything in Stata can be done via the menus, you're better off typing commands into a word processing file and saving them, then copying-and-pasting them into the Stata "Command" window.


**Buttons**

- Log: Track and save output from the Results window. Ensures replicability.
- New Do-file Editor: Organize your history commands in one place, making debugging easier.
  
    You can use **do-files** to create a batchlike environment in which you place all the commands you want to perform in a file and then instruct Stata to `do` that file. 
    
    Ex. You have a do file `myjob.do`, you can run
    
    ```
    do myjob
    ```
    
    all commands in the do file would be sourced.




--------------------------------------------------------------------------------

### Do-file {.unlisted .unnumbered}

It is <span style='color:#008B45'>**recommended** to run `do` files as a whole</span>. (This is different than R.) 

You <span style='color:#FF9900'>**cannot**</span> re-run commands freely in Stata. 

For example, if you run a command that creates a variable `x`, realize you made a mistake, and then fix it, you can’t simply select the command that creates `x` and run it again because `x` already exists. You could manually drop the existing version of `x`, but now you’re doing things in a non-reproducible way. Running the entire do file will eliminate this problem because it reloads the data from disk every time. If you find yourself getting confused by these kinds of issues, run the entire do file rather than a selection.



**Do-file Rule of Thumb**

- Your `.do` file begins with loading a dataset and ends with saving one.

    ```stata
    use ..., clear // begin
    /* your code */
    save ..., replace // end
    ```

- Never modify the raw data files. Save the results of your data cleaning in a new file.

- Every data file is created by a script. Convert your interactive data cleaning session to a `.do` file.

- No data file is modified by multiple scripts.

- Intermediate steps are saved in different files (or kept in temporary files).

    


**Keep `do` files short**

Our suggestion is that you keep your do files short enough that when you're working on one of them you can easily wrap your head around it. You also want to keep do files short so they run as quickly as possible: working on a `do` file usually requires running it repeatedly, so moving any code that you consider "done" to a different do file will save time.

**Project Structure**

- You can have a master `do` file which loads your small section `do` files sequentially and all in one.

- Enumerate your `do` files.

  Example: `0-master.do`, `1-data-clean.do`, `2-stylized-facts.do`, …

  You can then organize them in sub-do-files: if you have diﬀerent set of stylized facts, you

  could have: `2.1-stylized-facts-geography.do`, `2.2-stylized-facts-count.do` etc. . . .


--------------------------------------------------------------------------------

### `log` file {.unlisted .unnumbered}

`log` files put everything that your do file put in the Results window.


--------------------------------------------------------------------------------

**Comments**

- `//` for single line comment
- `/* */` for multiple line comment
- `//#` or `**#` add a bookmark

**Continuation lines**: `///` Everything after `///` to the end of the current line is considered a comment. The next line joins with the current line. Therefore, `///` allows you to split long lines across multiple lines in the do-file.

Summary of ways to break long lines:

- You can change the end-of-line delimiter to `;` by using `#delimit`, 

    ```stata
    #delimit ; // change the line delimiter to semicolon
    summarize weight price displ headroom rep78 length turn gear_ratio
        if substr(company,1,4)=="Ford" |
           substr(company,1,2)=="GM", detail ;
    gen byte ford = substr(company,1,4)=="Ford" ;
    #delimit cr // change the delimiter back to carriage return
    gen byte gm = substr(company,1,2)=="GM"
    ```
    
    Once you declear `#delimit ;`, all lines must end in `;`. Stata treats carriage returns as no different from blanks.

- you can comment out the line break by using `/* */` comment delimiters, or 
- you can use the `///` line-join indicator.


--------------------------------------------------------------------------------

`cd "directory_name"` change **working directory**.

- don't need quotation if there is no space
- need quotation if the directory has spaces

`pwd` displays the path of the current working directory.


`exit, clear` to quit Stata. If the dataset in memory has changed since the last time it was saved, Stata will refuse to quit unless you specify `clear`. 

--------------------------------------------------------------------------------

**Abbreviation rules**: Stata allows abbreviations. You can abbreviate commands, variable names, and options. 

```stata
// full command
. summarize myvar, detail
// use abbr. to achieve the same function
. sum myv, d
```

As a general rule, command, option, and variable names may be abbreviated to the shortest string of characters that uniquely identifies them.

When you read the Stata manual, it uses underlines to denote the minimal abbreviation for a command or option.

E.g. When you see <span style="font-family: monospace"><u>ap</u>pend</span>, it means you can use `ap` to denote `append`.
<span style="font-family: monospace"><u>desc</u>ribe</span> means the shortest
allowable abbreviation for `describe` is `desc`.

If there is no underlining, no abbreviation is allowed.

`rename` can be abbreviated `ren`, `rena`, `renam`, or it can be spelled out in its entirety.


Open `do` files in tabs rather than in separate windows: <https://www.reddit.com/r/stata/comments/1ivjegr/stata_18_mac_does_not_do_tabs_for_dofile_editor/>


## Baisc syntax

**Package management**

Users can add new features to Stata, and some users choose to make new features that they have written available to others via the web. The files that comprise a new feature are called a *package*, and a package usually consists of one or more ado-files and help files.

`ssc install newpkgname`: **Install** `newpkgname` from ssc. The SSC (Statistical Software Components) is the premier Stata download site.

`ssc uninstall pkgname` to **uninstall** `pkgname`

`ado update` to **update** packages

`ssc hot [, n(#)]` a list of most popular pkgs at SSC. `n(#)` to specify the number of pkgs listed.



Stata is case-sensitive: `myvar`, `Myvar` and `MYVAR` are three distinct names.

```
[by varlist:] command [ varlist ] [=exp] [if exp] [in range] [ weight ] [, options]
```

where square brackets distinguish optional qualifiers and options from required ones. In this diagram, 

- `varlist` denotes a list of variable names, 
  
    If no `varlist` appears, most commands assumes `_all`, which indicate all the variables in the dataset.
    
- `command` denotes a Stata command, 
- `exp` denotes an algebraic expression, 
- `range` denotes an observation range, 
- `weight` denotes a weighting expression, and 
- `options` denotes a list of options.
  
    Note the comma `,` which separate the command's main body to options.

`by varlist` repeat a cmd for each subset of the data, grouped by `varlist`.


Ex: group by `region` and `summarize marriage divorce` 

```
sysuse census
sort region
by region: summarize marriage divorce
```

Note that your have to `sort` before `by varlist`.

Alternatively, you can

```
by region, sort: summarize marriage_rate divorce_rate
```

`if exp` filter observations for which `exp` returns true

```
summarize marriage_rate divorce_rate if region == "West"
```

- `&` (and) and `|` (or) to join conditions.


`in range` restricts the scope of the cmd to be applied to a specific observation range.

- First observation can be denoted by `f`
- Last observation can be denoted by `l`
- Negative numbers mean "from the end of the data"


```stata
// summarize for observations 5 to 25
summarize marriage_rate divorce_rate in 5/25
// summarize for the last five observations
summarize marriage_rate divorce_rate in -5/l
```



**Create new variables**

```stata
gen variable = expression      // generate new variables
replace variable = expression  // replace the value of existing variables
```

`generate` create variables based on expressions you specified.

`generate newvar = oldvar + 2` generate a new variable `newvar`, which equals `oldvar + 2`

`generate lngdp = ln(gdp)` generate the natural log of `gdp`

`generate exp2 = exp^2` generate the square of `exp`

`egen`: Extensions to `generate`; creates a new variable based on <span style='color:#008B45'>`egen` functions</span> of existing variables.

Q: What are `egen` functions? \
A: The functions are specifically written for `egen`.

```stata
// Generate newv1 for distinct groups of v1 and v2, and create and apply value label mylabel
egen newv1 = group(v1 v2), label(mylabel)

// for each country, calculate the average of wpop
by country_id, sort: egen pop_country = mean(wpop)
```

`gen` vs. `egen`

- `gen` used for simple algebraic transformations
- `egen` for more complexed transformations, e.g., operations based on groups of observations.
- They behave differently if you want to calcualte the `sum` per group.
  - `gen` returns running sum
  - `egen` returns group sum

```stata
// Create variable containing the running sum of x
generate runsum = sum(x)

// Create variable containing a constant equal to the overall sum of x
egen totalsum = total(x)
```





`encode var, gen(newvar)`  creates a new variable named `newvar` based on the string variable `varname`.  It alphabetizes unique values in `var` and assigns numeric codes to each entry. 

```stata
encode sex, gen(gender)
// nolabel drops value labels and show how the data really appear
list sex gender in 1/4, nolabel
// you won't see difference using the following cmd
list sex gender in 1/4
```

`sex` is a string variable and takes on values `female` and `male`.

`encode` creates a new variable `gender`, mapping each level in `sex` to a numerical value. `female` becomes 1 and `male` becomes 2.



___

### Factor Variables

`i.varname` create **indicators** for each level of the variable

```stata
// group=1 as base level
list group i.group in 1/5
// group=3 as base level
list group i3.group in 1/5
// individual fixed effects
regress y i.group 
```

`c.varname` treat as **continuous**



`#` cross, create an **interaction** for each combination of the variables

`##` factorial cross, a full factorial of the variables: standalone effects for each variable and an interaction

```stata
group##sex
// equivalently
i.group i.sex i.group#i.sex
```



`o.varname` **omit** a variable or indicator

`o.age` means that the continuous variable `age` should be omitted, and
`o2.group` means that the indicator for `group = 2` should be omitted.





**Interaction Expansion**

```stata
xi [ , prefix(string) noomit ] term(s)
```

`xi`  expands terms containing categorical variables into indicator (also called dummy) variable sets. `xi` provides a convenient way to include dummy or indicator variables when fitting a model that does NOT support factor variables, e.g., `xtabond`.

We recommend that you use factor variables instead of `xi` if a command allows factor variables.

By default, `xi` will create interaction variables starting with `_I`.  This can be changed using the `prefix(string)` option. 

| Operator                                                 | Description                                                  |
| -------------------------------------------------------- | ------------------------------------------------------------ |
| `i.varname`                                              | creates dummies for categorical variable `varname`           |
| `i.varname1*i.varname2`                                  | creates dummies for categorical variables `varname1` and `varname2`: main effects and all interactions |
| `i.varname1*varname3`                                    | creates dummies for categorical variable `varname1` and *continuous* variable `varname3`: main effects and all interactions |
| <span style='color:#008B45'>`i.varname1|varname3`</span> | creates dummies for categorical variable `varname1` and *continuous* variable `varname3`: all interactions and main effect of `varname3`, but <span style='color:#FF9900'>**NO**</span> main effect of `varname1` |

- `xi` expands both numeric and string categorical variables.

  `agegrp` takes on values 1, 2,3, and 4.

  ```stata
  xi: logistic outcome i.agegrp
  ```

  `xi` tabulates `i.agegrp` creates indicator (dummy) variables for each observed value, omitting the indicator for the smallest value.

  This creates variables name `-Iagegrp2`, `-Iagegrp3`, and `-Iagegrp4`.

  ```stata
  // The expanded logistic model is
  logistic outcome _Iagegrp_2 _Iagegrp_3 _Iagegrp_4
  ```

- Dummy variables are created automatically and are left in your dataset.

	You can drop them by typing `drop I*`. You do not have to do this; each time you use `xi`, any automatically generated dummies with the same prefix as the one specified in the `prefix(string)` option, or `_I` by default, are *dropped and new ones are created*.
	
	

**Use `xi` as a command prefix**

```stata
// simple effects
xi: logistic outcome weight i.agegrp bp
// interactions of categorical variables
xi: logistic outcome weight bp i.agegrp*i.race
// interactions of dummy variables with continuous variables
// fits a model with indicator variables for all agegrp categories interacted with weight, plus the maineffect terms weight and i.agegrp.
xi: logistic outcome bp i.agegrp*weight i.race
// interaction terms without the agegrp main effect (but with the weight main effect)
xi: logistic outcome bp i.agegrp|weight i.race
```





___

### Time series varlists

Three time series operators: `L.`, `D.` and `S.`.

First convert variables to time variables by using `tsset`, then you can use the TS operators.

```stata
tsset time
list L.gnp
```

Convert to panel

```stata
tsset country year
// or
xtset country year
```


| TS Operator | Meaning                                                      |
| ----------- | ------------------------------------------------------------ |
| `L.`        | lag $x_{t-1}$                                                |
| `L2.`       | 2-period lag $x_{t-2}$                                       |
| `L(1/2).`   | a varlist $x_{t-1}$ and $x_{t-2}$                            |
| `F.`        | lead $x_{t+1}$                                               |
| `F2.`       | 2-period lead $x_{t+2}$                                      |
| `D.`        | difference $x_{t}-x_{t-1}$                                   |
| `D2.`       | difference of difference $(x_{t}-x_{t-1})-(x_{t-1}-x_{t-2})$ |
| `S.`        | "seasonal" difference $x_{t}-x_{t-1}$                        |
| `S2.`       | lag-2 seasonal difference $x_{t}-x_{t-2}$                    |

Note that `D1.` = `S1.`, but `D2.` $\ne$ `S2.`.

- `D2.` refers to the difference of difference 
- `S2.` refers to the two-period difference

Operators may be typed in uppercase or lowercase

```
L(1/3).(gnp cpi)
// equivalently
L.gnp L2.gnp L3.gnp L.cpi L2.cpi L3.cpi
```

`DS12.gnp` one-period difference of the 12-period difference


`.do` is a Stata do-file.

`.dta` is Stata dataset file format



### Labels

**Variable labels** convey information about a variable, and can be a substitute for long variable names. 

```stata
// generally
label variable variable_name "variable label"
// use example
label variable price "Price in 1978 Dollars"
```

**Value labels** are used with categorical variables to tell you what the categories mean.

1. First define a mapping 

```stata
// generally
label define map_name value1 "label1" value2 "label2"...
// use example
label define rep_label 1 "Bad" 2 "Average" 3 "Good"
```

2. Add value labels to existing variables

```stata
// generally
label values map_name
// use example
label values rep3 rep_label
```





## Data Manipulation

### Import and Export

**Shipped datasets**

Stata contains some demonstration datasets in the system directories.

`sysuse dir`: list the names of shipped datasets.

`sysuse lifeexp`: use `lifeexp`

Note that `use lifeexp` will return error. Data not found.


**User datasets**

**`.dta`**

`use myauto [, clear]`: Load `myauto.dta` (Stata-format) into memory.

- `clear`  it is okay to replace the data in memory, even though the current data have not been saved to disk.


`save myauto [, replace]`: Create a Stata data type file `myauto.dta`

- `replace` allows Stata to overwrite existing dataset that is the output from previous attempts to run the do file.


**`.csv`**

`import delimited myauto.csv`: Import `myauto.csv` to Stata's memory

`export delimited myauto.csv`" Export to `myauto.csv`


`import delimited filename` reads text (ASCII) files in which there is one observation
per line and the values are separated by commas, tabs, or some other delimiter.

By default, Stat will check if the file is delimited by tabs or commas based on the first line of data.

`export delimited filename` writes data into a file in comma-separated (.csv) format by default. You can specify any separation character delimiter that you prefer.


If `filename` is specified without an extension, `.csv` is assumed. If filename contains embedded spaces, enclose it in double quotes.

```stata
import delimited [using] filename [, import_delimited_options]
```

**Options** 

- `delimiters("chars"[, collapse | asstring] )`:

    - `"chars"` specifies the delimiter
    
        `";"`: uses semicolon as a delimiter; `"\t"` uses tab, `"whitespace"` uses whitespace
        
    - `collapse` treat multiple consecutive delimiters as just one delimiter.
    - `asstring`  treat `chars` as one delimiter. By default, each character in `chars` is treated as an individual delimiter.
    
    
    ```stata
    // use example
    import delimited auto, delim(" ", collapse) colrange(:3) rowrange(8) 
    ```

- `clear` replace data in memory


___

### Save Estimation Results

`estimates store model_name` stores the current (active) estimation results under the name `model_name`.

```stata
// Store estimation results as m1 for use later in the same session
estimates store m1
```

`estimates table` organizes estimation results from one or more models in a single formatted table.

If you type estimates table without arguments, a table of the most recent estimation results will be shown.

```stata
// Display a table of coefficients for stored estimates m1 and m2
estimates table m1 m2
// with SE
estimates table m1 m2, se

// with sample size, adjusted 𝑅2, and stars
estimates table m1 m2, stats(N r2_a) star
```



`estimate save filename` save the current active estimation results to `filename.ster`. 



#### `etable` {.unnumbered}

**`etable`**  allows you to easily create a table of estimation results and export it to a variety of file types, e.g., docx, html, pdf, xlsx, tex, txt, markdown, md.

```stata
// use example of etable
. clear all
. webuse nhanes2l
(Second National Health and Nutrition Examination Survey)
. quietly regress bpsystol age weight i.region
. estimates store model1

. quietly regress bpsystol i.sex weight i.agegrp
. estimates store model2

. quietly regress bpsystol age weight i.agegrp
. estimates store model3

. etable, estimates(model1 model2 model3) showstars showstarsnote title("Table 1. Models for systolic blood pressure") export(mydoc.docx, replace)
```

**Options**:

- `export` allows you to specify the output format

Alternative to `etable`: `eststo`.




### Stored Results

Stata commands that report results also store the results where they can be subsequently used by other commands or programs. This is documented in the Stored results section of the particular command in the reference manuals.

- e-class commands, such as regress, store their results in `e()`; e-class commands are Stata’s model estimation commands.

- r-class commands, such as summarize, store their results in `r()`; most commands are r-class.



```stata
// for r-class command
return list
// for e-class command
ereturn list
```



## Predict

`predict` calculates predictions, residuals, influence statistics, and the like after estimation. Exactly what `predict` can do is determined by the previous estimation command; command-specific options are documented with each estimation command. Regardless of command-specific options, the actions of `predict` share certain similarities across estimation commands:

- `predict newvar1` create `newvar1` containing "predicted values", i.e., $\hat{y}_i = \E(y_i\mid \bx_i)$

  - For linear regression models, $\hat{y}_i = \bx_i'\hat{\bbeta.}$
  - For probit/logit models, $\hat{y}_i = F(\bx_i'\hat{\bbeta}),$ where $F(.)$ is the logistic or normal cumulative distribution function.

- `predict newvar2, xb` create `newvar2` containing the linear prediction

  Option `xb` means caculating the linear prediction, $\bx_i'\hat{\bbeta},$ from the fitted model.

- `predict newvar2 if e(sample), xb` Same as above, but only for observations used to fit the model in the previous estimation, i.e., **in-sample predictions**.

  `e(sample)`:  return $1$ if the observation is in the estimation sample and $0$ otherwise.

- `predict` can be used in **out-of-sample predictions**, which extende beyond the estimation sample. 

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

Foreceast: **out-of-sample**

Before we are able to forecast, we must populate the exogenous variables over the entire forecast horizon before solving our model. 添加数据

*Solving our model*: means obtain forecast from our model.



#### **Procedure**: {.unnumbered .unlist}

1. **Estimate the model**

   ```stata
   arima y2 x3 y1, ar(1) ma(1)
   ```

   

2. **Store the estimation results** using `estimate store`

   ```stata
   estimate store myarima
   ```

   

3. **Create a forecast model** using `forecast create`. This initialize a new model; we will call the model `mymodel.`

   ```stata
   forecast create mymodel
   ```

   The name you give the model mainly controls how output from `forecast` commands is labeled. More importantly, `forecast create` creates the internal data structures Stata uses to keep track of your model.

4. **Add all equations** to the model you just created.

	The following command adds the stored estimation results in `myarima` to the current model `mymodel`.

   ```
   forecast estimates myarima
   ```

   

5. **Compute dynamic forecasts** from 2012 to 2024

   ```stata
   forecast solve, begin(2012) end(2024)
   ```


--------------------------------------------------------------------------------

### Add equations/identifies {.unnumbered}

```stata
forecast estimates name [, options ]
```

**Options**:

- `predict(p_options)`:  call `predict` using `p_options`

- `names(namelist[ , replace ])`: use `namelist` for names of left-hand-side (LHS) variables.

  `forecast estimates` creates a new variable in the dataset for each element of `namelist`.  

  If a variable of the same name already exists in your dataset, `forecast estimates` exits with an error unless you specify the `replace` option, in which case existing variables are overwritten.


--------------------------------------------------------------------------------

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



**Use example: forecast a panel**
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

With enough observations, we can have more confidence in the estimated panel-specific errors. If we are willing to assume that we have decent estimates of the panel-specific errors and that those panel-level effects will remain constant over the forecast horizon, then we can incorporate them into our forecasts. Because predict only provided us with estimates of the panel-level effects for the estimation sample, we need to extend them into the forecast horizon. An easy way to do that is to use `egen` to create a new set of variables:

```stata
by state: egen dlndim_u2 = mean(dlndim_u)
```

We can use `forecast adjust` to incorporate these terms into our forecasts. 

The following commands define our forecast model, including the estimated panel-specific terms:

```stata
forecast create statemodel, replace   /* create forecast model */
forecast estimates dim, name(dlndim)  /* add equations, endog variables to bre forecasted */
forecast adjust dlndim = dlndim + dlndim_u2 /* add state fixed effects */
```

`dlndim` stands for the first difference of the logarithm of `dim`. We are interested in the level of `dim`, so we need to back out `dim` from `dlndim`.

We use `forecast identity` to obtain the actual `dim` variable.

```stata
// reverse first difference
forecast identity lndim = L.lndim + dlndim
// reverse logarithm
forecast identity dim = exp(lndim)
```

We used forecast adjust to perform our adjustment to dlndim immediately after we added those estimation results so that we would not forget to do so.
However, we could have specified the adjustment at any time. 

Regardless of when you specify an adjustment, `forecast solve` performs those adjustments immediately after the variable being adjusted is computed.

Finally we can solve the model. Here we obtain dynamic forecasts beginning in the first quarter of 2010:

```stata
forecast solve, begin(tq(2010q1)) log(off)
```





___

### Solve the foreceast {.unnumbered}

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

  By default, <span style='color:#008B45'>**dynamic forecasts**</span> are produced, which use the forecast values of variables wherever lagged values of the endogenous variables appear in the model. 

- `actuals` use actual values if available instead of forecasts

  `actuals` specifies how nonmissing values of endogenous variables in the forecast horizon are treated. By default, nonmissing values are ignored, and forecasts are produced for all endogenous variables.
  When you specify `actuals`, `forecast` sets the forecast values <u>equal to the actual values if they are nonmissing</u>. The forecasts for the other endogenous variables are then conditional on the known values of the endogenous variables with nonmissing data.

- `log(off)` suppress the iteration log.



## Panel

**Declare panel data**

You must `xtset` your data before you can use other `xt` commands.

`xtset panelvar timevar` declares the data to be a panel in which the order of observations is relevant. When you specify `timevar`, you can then use time series operators (e.g., `L`, `D`).

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

`xtreg` is Stata's feature for fitting linear models for panel data.

`xtreg, fe` estimates the parameters of fixed-effects models:


```stata
xtreg depvar [indepvars] [if] [in] [weight] , fe [FE_options]
```

Menu: Statistics > Longitudinal/panel data > Linear models > Linear regression (FE, RE, PA, BE, CRE)

Options

- `vce(robust)` use clustered variance that allows for intragroup correlation within
  groups.
  
    By defualt, SE uses OLS estimates.



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

```stata
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
```



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







