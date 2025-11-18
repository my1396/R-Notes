# Stata

**Resources**:

- User Guide: <https://www.stata.com/manuals/u.pdf>
- Tutorial: <https://grodri.github.io/stata/>
- Quick start: 
  - <https://lanekenworthy.net/stata-quick-guide/>
  - [[GSM] Getting Started with Stata for Mac](https://www.stata.com/manuals/gsm1.pdf) 


<span class="env-green">`help <cmd_name>`</span>: Get help for a command in Stata console.

Overview of [Documentation](https://www.stata.com/features/documentation/):

- [U] User's Guide: is divided into three sections: Stata basics, Elements of Stata, and Advice.
  
  Recommended to read.

- [Base Reference Manual](https://www.stata.com/bookstore/base-reference-manual/#contents): list commands alphabetically. 
  
  Not designed to be read from cover to cover.

- The PDF documentation may be accessed from within Stata.  

  `help command_name` and then click on the "View complete PDF manual entry" button under the command.

  Or in the menu bar, Help > PDF Documentation to open the complete PDF documentation.

  The pdf documentation uses Acrobat Reader as the viewer. Tip: **use finger pinch to zoom in and out**. When using the zoom button or `cmd +`/`cmd -`, the text jumps around, you lose your original position.



Keyboard Shortcuts

Actually not of much use.

| Keyboard Shortcut | Description   |
| ----------------- | ------------- |
| ctrl + R          | last cmd      |
| ctrl + B          | next cmd      |
| cmd + shift + D   | Run a Do file |





**User interface**

Within the Stata interface window, there are five windows: Command, Results, History, Properties, and Variables.

<img src="https://drive.google.com/thumbnail?id=1VDcZ6w7Ie8lqYKJxF7zJlUiXqH4WxDaw&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />


Output appears in the Results window. E.g.,

```stata
. sysuse auto, clear
(1978 Automobile Data)
```

The dot (`.`) indicates that the current line is a Stata command.

`>` indicates that the command is not yet complete. You will see this when you have a command that spans multiple lines.


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

### Comments {.unlisted .unnumbered}

- `//` for single line comment; rest-of-line comment; it can be put at any place. 
  
  Commonly used after a command to denote comments on that line.
- `*` for single line comments; the comment line must begin with `*`;
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

### Types and Declarations 

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

- `varlist` denotes a *list* of variable names.
  
  Variables are separated by spaces.

  Use `help varlist` for more details on how to specify `varlist`.

  If no `varlist` appears, most commands assumes `_all`, which indicate all the variables in the dataset.
  
- `command` denotes a Stata command, 
- `exp` denotes an algebraic expression, 
- `range` denotes an observation range, 
- `weight` denotes a weighting expression, and 
- `options` denotes a list of options.
  
    Note the comma <span class="env-green">`,` which separate the command's main body from options</span>.

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

### Create new variables

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

### Refer to a range of variables

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

Wildcard characters:

- `*` matches any string of characters, including no characters.
- `?` matches any single character.
  - `?*` matches one or more character
  - `??*` matches two or more characters

`var1-var2` specifies a range of variables, from the first variable to the second variable, in the order in which they appear in the dataset.

A `numlist` is a list of numbers. It can include individual numbers, ranges of numbers, and increments.

Common operators in `numlist`:

- range: `start/end` means all numbers from `start` to `end`, inclusive.
  - `start to end`
  - `start:end`
- specify increment

  `start(increment)end` or `start[increment]end`

Ex

```
1/3     // 1,2,3
-5/-8   // -5,-6,-7,-8
1 to 3  // 1,2,3
1(2)9   // 1,3,5,7,9
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

`i.varname` create <span class="env-green">**indicators**</span> for each level of the variable

```stata
// group=1 as base level
list group i.group in 1/5
// group=3 as base level
list group i3.group in 1/5
// individual fixed effects
regress y i.group 
```

- `ib#.varname` specify the base level. `#` is the value of the base level.
  
  By default, the smallest level becomes the base level.

  `i` might be omitted. `ib3.group` is equivalent to `b3.group`.

`c.varname` treat as <span class="env-green">**continuous**</span>


`#` cross, create an <span class="env-green">**interaction**</span> for each combination of the variables. Spaces are not allowed in interactions.

```stata
sex#c.age   // interaction between categorical variable `sex` and continuous variable `age`

c.age#c.age        // age squared
c.age#c.age#c.age  // age cubed
```

`##` factorial cross, a full factorial of the variables: <span class="env-green">**standalone effects** for each variable and an **interaction**</span>

```stata
group##sex
// equivalently
i.group i.sex i.group#i.sex
```



`o.varname` **omit** a variable or indicator

- `o.age` means that the continuous variable `age` should be omitted, and
- `o2.group` means that the indicator for `group = 2` should be omitted.



--------------------------------------------------------------------------------


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

--------------------------------------------------------------------------------

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

Basic syntax: `operator(order/spec).(varlist)`

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
| `L(2/.).`   | from $x_{t-2} up to the maximum available lag                |
| `F.`        | lead $x_{t+1}$                                               |
| `F2.`       | 2-period lead $x_{t+2}$                                      |
| `D.`        | difference $x_{t}-x_{t-1}$                                   |
| `D2.`       | difference of difference $(x_{t}-x_{t-1})-(x_{t-1}-x_{t-2})$ |
| `S.`        | "seasonal" difference $x_{t}-x_{t-1}$                        |
| `S2.`       | lag-2 seasonal difference $x_{t}-x_{t-2}$                    |


`2/.` the dot means "up to the **maximum available** lag/lead".

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
. estimates table, star

// show se, t, and p values
.  estimates table, se t p
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
estimates table, keep(L1.logd_gdp tmp tmp2 pre pre2 tmp_pre tmp2_pre tmp_pre2 tmp2_pre2) se t p 
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



