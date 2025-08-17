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

It is <span class="env-green">**recommended** to run `do` files as a whole</span>. (This is different than R.) 

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

  You can then organize them in sub-do-files: if you have different set of stylized facts, you

  could have: `2.1-stylized-facts-geography.do`, `2.2-stylized-facts-count.do` etc. . . .


--------------------------------------------------------------------------------

### `log` file {.unlisted .unnumbered}

`log` files put everything that your do file put in the Results window.


--------------------------------------------------------------------------------

### Comments

- `//` for single line comment; rest-of-line comment;
- `/* */` for multiple line comment; enclosed comment;
- `//#` or `**#` add a bookmark
- `///` line-join indicator

Note that  the `//` comment indicator and the `///` indicator must be preceded by one or more blanks.

See [[U] 16.1.2 Comments and blank lines in do-files](https://www.stata.com/manuals13/u16.pdf#u16.1.2Commentsandblanklinesindo-files) for more details.


**Continuation lines**: `///` 


`///` is called the line-join indicator or line continuation marker. It makes long lines more readable.

Everything after `///` to the end of the current line is considered a comment. The next line joins with the current line. Therefore, `///` allows you to split long lines across multiple lines in the **do-file**.

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


Example

```stata
replace final_result = ///
    sqrt(first_side^2 + second_side^2) ///
    if type == "rectangle"
```

equivalently, you can use `/* */` to break long lines: 

```stata
replace final_result = /*
    */ sqrt(first_side^2 + second_side^2) /*
    */ if type == "rectangle"
```


N.B. There's NO line continuation marker (`///`) in the command window.

In the command window, the enter key sends what has been written on the line to Stata. There is no way to continue a long command on a second line, without sending the first (incomplete) line to Stata.


You can add comments after `///`.

```stata
args a /// input parameter for a
     b /// input parameter for b
     c // input parameter for c
```

is equivalent to

```stata
args a b c
```

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


## Basic syntax

### Package management

Users can add new features to Stata, and some users choose to make new features that they have written available to others via the web. The files that comprise a new feature are called a *package*, and a package usually consists of one or more ado-files and help files.

<span class="env-green">`ssc install newpkgname`</span>: **Install** `newpkgname` from ssc. The SSC (Statistical Software Components) is the premier Stata download site.

`ssc uninstall pkgname` to **uninstall** `pkgname`

`ado update` to **update** packages

`ssc hot [, n(#)]` a list of most popular pkgs at SSC. `n(#)` to specify the number of pkgs listed.


--------------------------------------------------------------------------------


Stata is **case-sensitive**: `myvar`, `Myvar` and `MYVAR` are three distinct names.

Semicolons (`:`) is treated as a line separator. It is not required, but it may be used to place two statements on the same physical line:

```stata
x = 1 ; y = 2 ;
```

The last semicolon in the above example is unnecessary but allowed.


--------------------------------------------------------------------------------

#### Types and Declarations 

A variable's type can be described in two perspectives:

- `eltype`: specifies the *type* of the elements. Default: `transmorphic`.
- `orgtype`: specifies the *organization* of the elements. Default: `matrix`.



| `eltype`       | `orgtype`   |
| -------------- | ----------- |
| `transmorphic` | `matrix`    |
| `numeric`      | `vector`    |
| `real`         | `rowvector` |
| `complex`      | `colvector` |
| `string`       | `scalar`    |
| `pointer`      |             |






```stata
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

<span class="env-green">`in range`</span> restricts the scope of the cmd to be applied to a specific observation range.

- First observation can be denoted by `f`
- Last observation can be denoted by `l`
- Negative numbers mean "from the end of the data"


```stata
// summarize for observations 5 to 25
summarize marriage_rate divorce_rate in 5/25
// summarize for the last five observations
summarize marriage_rate divorce_rate in -5/l
```


--------------------------------------------------------------------------------

#### Create new variables

```stata
gen variable = expression      // generate new variables
replace variable = expression  // replace the value of existing variables
```

`generate` create variables based on expressions you specified.

`generate newvar = oldvar + 2` generate a new variable `newvar`, which equals `oldvar + 2`

`generate lngdp = ln(gdp)` generate the natural log of `gdp`

`generate exp2 = exp^2` generate the square of `exp`

`egen`: Extensions to `generate`; creates a new variable based on <span class="env-green">`egen` functions</span> of existing variables.

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



`display` displays strings and values of scalar expressions.

```stata
display [display_directive [display_directive [...]]]
```

`list` displays the values of variables. If no `varlist` is specified, the values of all the variables are displayed.

```stata
list [varlist] [if] [in] [, options]
```

--------------------------------------------------------------------------------

#### Refer to a range of variables

How can I list, drop, and keep a consecutive set of variables without typing the names individually?

- list all variables starting with a certain prefix
- list all variables between two variables
- combination of the two

```stata
// list all variables starting with a certain prefix
.  list var* // all variables starting with "var"

// list all variables between two variables
.  list var1-var5 // all variables between var1 and var5

// combination of the two
.  list var1 var3-var5 
```

If you want to consider reordering the variables in your dataset, `order, sequential` will put the variables in alphabetical order (and does mostly smart things with numeric suffixes).

```stata
. order *, sequential
```

the resulting order will be:

```stata
1.  alpha
2.  beta
3.  gamma
4.  v1
5.  v2
6.  v3
7.  v4
```

`order, sequential` is smart enough to know that `v10` comes after `v9` and not between `v1` and `v2`, which pure alphabetical order would specify. For online help, type `help order` in Stata, or see [D] order.


--------------------------------------------------------------------------------


### System Variables

Expressions may also contain variables (pronounced “underscore variables”), which are built-in system variables that are created and updated by Stata. They are called variables because their names all begin with the underscore character, `_`.

| Var                                           | Description                                                  |
| --------------------------------------------- | ------------------------------------------------------------ |
| `_n`                                          | the number of the current observation.                       |
| `_N`                                          | the total number of observations in the dataset or the number of observations in the current `by()` group. |
| `_pi`                                         | $\pi$                                                        |
| `[eqno]_b[varname]` or `[eqno]_coef[varname]` | value of the coefficient on `varname` from the most recently fitted model |
| `[eqno]_se[varname]`                          | standard error of the coefficient on `varname` from the most recently fit model |
| `_b[_cons]`                                   | value of the intercept term                                  |





___


### Matrix

You enter the matrices by row, separate one element from the next by using commas (`,`) and one row from the next by using backslashes (`\`).

To create

$$
A = \begin{pmatrix}
1 & 2 \\
3 & 4
\end{pmatrix}
$$


```stata
matrix [input] a = (1,2\3,4)
matrix list a
```

`input` is optional.

- without `input`, matrix must be small, can include expressions.
- with `input`, matrix can be large, but no expressions for the elements.

Menu: Data > Matrices, ado language > Input matrix by hand

Get one element using `matname[r,c]` to get `r` row, `c` column element.



`matrix rownames` and `colnames reset` the row and column names of an already existing matrix.

`matrix roweq` and `coleq` also reset the row and column names of an already existing matrix, but if a simple name (a name without a colon) is specified, it is interpreted as an **equation name**.


```stata
// Reset row names of matrix
matrix rownames A = names
matrix colnames A = names
// Reset row names and interpret simple names as equation names
matrix roweq A = names
matrix coleq A = names
```

`A` is a matrix.

`name` can be:

- a simple name; `var`
- an interaction; e.g., `var1#var2`
- a colon followed by a simple name; 
- a colon followed by an interaction;
- an equation name followed by a colon, and a simple name; e.g., `myeq:var`
- an equation name, a colon, and an interaction, e.g., `myeq:var1#var2`



**Matrix define**: <https://www.stata.com/manuals/pmatrixdefine.pdf#pmatrixdefine>



___

**Macro functions**

`rownames A` and `colnames A` return a list of all the row or column subnames (with time-series operators if applicable) of A, separated by single blanks. The equation names, even if present, are not included.

`roweq A` and `coleq A` return a list of all the **row equation names** or **column equation names** of A, separated by single blanks, and with each name appearing however many times it appears in the matrix.

`rowfullnames A` and `colfullnames A` return a list of all the row or column names, including equation names of A, separated by single blanks.




___

### Factor Variables

`help fvvarlist` for documentation on factor variables.

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



`#` cross, create an **interaction** for each combination of the variables. Spaces are not allowed in interactions.

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
| <span class="env-green">`i.varname1|varname3`</span> | creates dummies for categorical variable `varname1` and *continuous* variable `varname3`: all interactions and main effect of `varname3`, but <span style='color:#FF9900'>**NO**</span> main effect of `varname1` |

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

--------------------------------------------------------------------------------

### Output format


`%` indicates the start of a format specification.

`%9.2f` means a floating-point number with 9 characters wide, including 2 digits after the decimal point.

- the first digit states the width of the results
- the second digit after the decimal point states the number of digits after the decimal point
- `f` for fixed format. Alternatively,
  - `e` for scientific notation



ref: [U] [12.5 Data: Formats, control how data are displayed](https://www.stata.com/manuals/u12.pdf#u12.5.4Stringformats)



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
. estimates store m1
// to get them back 
. estimates restore m1
// Find out what you have stored 
. estimates dir
```

--------------------------------------------------------------------------------

`estimate save` saves the current active estimation results to a file with the extension `.ster`. 

```stata
// Save the current active estimation results
. estimate save basemodel
file basemodel.ster saved
```

In a different session, you can reload those results:

```stata
// Load the saved estimation results
. estimates use basemodel
// Display the results
. estimates table
```

Q: What is the difference between `estimates store` and `estimates save`? \
A: Once estimation results are stored, you can use other `estimates`
commands to produce tables and reports from them.

--------------------------------------------------------------------------------

[`estimates table [namelist] [, options]`](https://www.stata.com/manuals/restimatestable.pdf) <span class="env-green">organizes estimation results</span> from one or more models in a single formatted table.

If you type estimates table without arguments, a table of the most recent estimation coefficients will be shown.

```stata
// Display a table of coefficients for stored estimates m1 and m2
estimates table m1 m2
// with SE
estimates table m1 m2, se

// with sample size, adjusted 𝑅2, and stars
estimates table m1 m2, stats(N r2_a) star
```

You can add more results to show using options:

- `stats(scalarlist)` reports additional statistics in the table. Below are commonly used result identifiers:

  - `N` for sample size
  - `r2_a` for adjusted $R^2$
  - `r2` for $R^2$
  - `F` for F-statistic
  - `chi2` for chi-squared statistic
  - `p` for p-value
  
  `stats(N r2_a)` to show sample size and adjusted $R^2$
- `star` shows stars for significance levels.
  
  - By default, `star(.05 .01 .001)`, which uses the following significance levels:
    - `*` for $p < 0.05$
    - `**` for $p < 0.01$
    - `***` for $p < 0.001$
  
  - You can change the significance levels using `star(.1 .05 .01)` to set the levels to 0.10, 0.05, and 0.01, respectively.
  
  - N.B. the `star` option may not be combined with the `se`, `t`, or `p` option. 
  
  An error will be returned if you try to combine them:
    
    ```stata
    .  estimate table, star se t p star
    option star not allowed
    ```


- `b[%fmt]` how to format the coefficients.
- `se[%fmt]` show standard errors and use optional format
- `t[%fmt]` show $t$ or $z$ statistics and use optional format
- `p[%fmt]` show $p$ values and use optional format
- `varlabel` display variable labels rather than variable names


```stata
// show stars for sig. levels
. estimate table, star
// show se, t, and p values
.  estimate table, se t p
```

All statistics are shown in order under the coefficients. If you have a long list of variables, the table can be very long.

You can use `keep(varlist)` to keep only the variables you want to show in the table.

- `varlist` is a list of variables you want to keep in the table.
  - A list of variables can be specified as `keep(var1 var2 var3)`. 
    
    Names are separated by spaces.
  
  - Not possible to use variable ranges, e.g., `keep(var1-var3)` will return an error.
  
  - When you have multiple equations, use `eqn_name:varname` to specify the variable in a specific equation.


Example of a long variable list

```stata
estimate table, keep(L1.logd_gdp tmp tmp2 pre pre2 tmp_pre tmp2_pre tmp_pre2 tmp2_pre2) se t p 
```


--------------------------------------------------------------------------------

#### `etable` {.unnumbered}

**`etable`** allows you to easily create a table of estimation results and export it to a variety of file types, e.g., `docx`, `html`, `pdf`, `xlsx`, `tex`, `txt`, `markdown`, `md`.

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

- `showstars` and `showstarsnote` shows stars and notes for significance levels.
- `export` allows you to specify the output format

Alternative to `etable`: `eststo`.




### Stored Results

Stata commands that report results also store the results where they **can be subsequently used** by other commands or programs. This is documented in the Stored results section of the particular command in the reference manuals.

- r-class commands, such as summarize, store their results in `r()`;
  
  most commands are r-class.

- e-class commands, such as regress, store their results in `e()`; 
  
  e-class commands are Stata’s model estimation commands.





```stata
// for r-class command
return list
// for e-class command
ereturn list
```



Most estimation commands leave behind 

- `e(b)` the coefficient vector, and 
- `e(V)` the variance–covariance matrix of the estimates (VCE)

```stata
// display coef vector
matrix list e(b)
// assign it to a variable
matrix myb = e(b)
matrix list myb
```

You can refer to `e(b)` and `e(V)` in any matrix expression:

```stata
matrix c = e(b)*invsym(e(V))*e(b)’
matrix list c
```

`invsym(e(V))` returns the inverse of `e(V)`. Generally, `invsym` requires a a square, symmetric, and positive-definite matrix.



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

4. **Add all equations** to the model you just created using `forecast estimates`.

	The following command adds the stored estimation results in `myarima` to the current model `mymodel`.

   ```
   forecast estimates myarima
   ```

   

5. **Compute dynamic forecasts** from 2012 to 2024

   ```stata
   forecast solve, begin(2012) end(2024)
   ```


--------------------------------------------------------------------------------

**Creates a new forecast model**

```stata
forecast create [ name ] [ , replace ]
```

The `forecast create` command creates a new forecast model in Stata.
You must create a model before you can add equations or solve it. You can have *only one model in memory at a time*.

You may optionally specify a `name` for your model. That `name` will appear in the output produced by the various forecast subcommands.

`replace` clear the existing model from memory before creating `name`.  By default, `forecast create` issues an error message if another model is already in memory.

Note that you can add multiple equations to a forecast model.


--------------------------------------------------------------------------------

### Add equations/identifies {.unnumbered}

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

**Add an Identity to a `forecast` Model** 


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

**Add equations that you obtained elsewhere to your model**

Up untill now, we have been using model output from Stata to add equations to a forecast model, i.e., using `forecast estimates`. 

You use `forecast coefvector` to add endogenous variables to your model that are defined by linear equations.

Common use scenarios of `forecast coefvector`:

- Sometimes, you might see the estimated coefficients for an equation in an article and want to add that equation to your model. In this case, `forecast coefvector` allows you to add equations that are stored as coefficient vectors to a forecast model.

- User-written estimators that do not implement a `predict` command can also be included in forecast models via `forecast coefvector`. 

- `forecast coefvector` can also be useful insituations where you want to simulate time-series data.

```stata
forecast coefvector cname [, options ]
```

`cname` is a Stata matrix with **one row**. It defines the linear equations, which are stored in a coefficient (parameter) vector.

**Options**:

- `variance(vname)`: specify parameter variance matrix of the <span class="env-green">**estimated parameters**</span>.

  This option only has an effect if you specify the `simulate()` option when calling `forecast solve` and request `sim_technique`’s `betas` or `residuals`.

- `errorvariance(ename) `: specify <span class="env-green">**additive error term**</span> with variance matrix `ename`, where `ename` is the name of s Stata matrix. The number of rows and columns in `ename` must match the number of equations represented by coefficient vector `cname`. 

  This option only has an effect if you specify the `simulate()` option when calling `forecast solve` and request `sim_technique`’s `betas` or `residuals`.

- `names(namelist[ , replace ])`: instructs forecast coefvector to use namelist as the names of the left-hand-side variables in the coefficient vector being added. By default, forecast coefvector uses the equation names on the column stripe of cname. 

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

### Solve the foreceast {.unnumbered}

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

- `simulate(sim_technique, sim_statistic sim_options)` allows you to simulate your model to obtain measures of uncertainty surrounding the point forecasts produced by the model. Simulating a model involves repeatedly solving the model, each time accounting for the uncertainty associated with the error terms and the estimated coefficient vectors.

  - `sim_technique` can be `betas`, `errors`, or `residuals`.

    - `betas`: draw multivariate-normal parameter vectors
    - `errors`: draw additive errors from multivariate normal distribution
    - `residuals`: draw additive residuals based on static forecast errors

  - `sim_statistic` specifies a summary statistic to summarize the forecasts over all the simulations.

  ```stata
  statistic(statistic, { prefix(string) | suffix(string) })
  ```

  `statistic` can be `mean`, `variance`, or `stddev`. You may specify either the prefix or the suffix that will be used to name the variables that will contain the requested `statistic`.

  - `sim_options` includes
    - `saving(filename, …)` save results to file
    - `nodots` suppress replication dots.  By default, one dot character is displayed for each successful replication. If during a replication convergence is not achieved, forecast solve exits with an error message.
    - `reps(#)` request that `forecast solve` perform `#` replications; default is `reps(50)`



___

### Use example: forecast a panel {.unnumbered}

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

`xtreg` is Stata's feature for fitting linear models for panel data.

`xtreg, fe` estimates the parameters of fixed-effects models:


```stata
xtreg depvar [indepvars] [if] [in] [weight] , fe [FE_options]
```

Menu: Statistics > Longitudinal/panel data > Linear models > Linear regression (FE, RE, PA, BE, CRE)

Options

- `vce(robust)` use clustered variance that allows for intragroup correlation within
  groups.
  
    By default, SE uses OLS estimates.



