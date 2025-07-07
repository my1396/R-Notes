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

    ```
    use ..., clear // begin
    /* your code */
    save ..., replace // end
    ```

- Never modify the raw data files. Save the results of your data cleaning in a new file.
- Every data file is created by a script. Convert your interactive data cleaning session to a `.do` file.
- No data file is modified by multiple scripts.
- Intermediate steps are saved in different files (or kept in temporary files) than the final dataset.


**Keep `do` files short**

Our suggestion is that you keep your do files short enough that when you're working on one of them you can easily wrap your head around it. You also want to keep do files short so they run as quickly as possible: working on a `do` file usually requires running it repeatedly, so moving any code that you consider "done" to a different do file will save time.

You can have a master do file which loads your small section do files sequentially and all in one.


--------------------------------------------------------------------------------

### `log` file {.unlisted .unnumbered}

`log` files put everything that your do file put in the Results window.


--------------------------------------------------------------------------------

**Comments**

- `//` for single line comment
- `/* */` for multiple line comment
- `//#` or `**#` add a bookmark

Continuation lines: `///` Everything after `///` to the end of the current line is considered a comment. The next line joins with the current line. Therefore, `///` allows you to split long lines across multiple lines in the do-file.

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


## Baisc syntax

Stata is case-sensitive; `myvar`, `Myvar` and `MYVAR` are three distinct names.

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


```
// summarize for observations 5 to 25
summarize marriage_rate divorce_rate in 5/25
// summarize for the last five observations
summarize marriage_rate divorce_rate in -5/l
```

```stata
gen variable = expression      // generate new variables
replace variable = expression  // replace the value of existing variables
```


`generate newvar = oldvar + 2` generate a new variable `newvar`, which equals `oldvar+2`

**Time series varlists**

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


| Operator  | Meaning                                                      |
| --------- | ------------------------------------------------------------ |
| `L.`      | lag $x_{t-1}$                                                |
| `L2.`     | 2-period lag $x_{t-2}$                                       |
| `L(1/2).` | a varlist $x_{t-1}$ and $x_{t-2}$                            |
| `F.`      | lead $x_{t+1}$                                               |
| `F2.`     | 2-period lead $x_{t+2}$                                      |
| `D.`      | difference $x_{t}-x_{t-1}$                                   |
| `D2.`     | difference of difference $(x_{t}-x_{t-1})-(x_{t-1}-x_{t-2})$ |
| `S.`      | "seasonal" difference $x_{t}-x_{t-1}$                        |
| `S2.`     | lag-2 seasonal difference $x_{t}-x_{t-2}$                    |

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


## Data Import and Export


**Shipped datasets**

Stata contains some demonstration datasets in the system directories.

`sysuse dir`: list the names of shipped datasets.

`sysuse lifeexp`: use `lifeexp`\
`use lifeexp` will return error. Data not found.


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

`delimiters("chars"[, collapse | asstring] )`:

- `"chars"` specifies the delimiter

    `";"`: uses semicolon as a delimiter; `"\t"` uses tab, `"whitespace"` uses whitespace
    
- `collapse` treat multiple consecutive delimiters as just one delimiter.
- `asstring`  treat `chars` as one delimiter. By default, each character in `chars` is treated as an individual delimiter.


```stata
// use example
import delimited auto, delim(" ", collapse) colrange(:3) rowrange(8) 
```

### Labels

Variable labels convey information about a variable, and can be a substitute for long variable names. 

```stata
// generally
label variable variable_name "variable label"
// use example
label variable price "Price in 1978 Dollars"
```

Value labels are used with categorical variables to tell you what the categories mean.

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




## Arellano-Bond Estimator

The Arellano-Bond estimator may be obtained in Stata using either the `xtabond` or `xtdpd` command.


`xtabond` fits a linear dynamic panel-data model where the unobserved unit-level effects are correlated with the lags of the dependent variable, known as the Arellano–Bond estimator. This estimator is designed for datasets with many panels and few periods, and it requires that there be **no autocorrelation** in the idiosyncratic errors.













