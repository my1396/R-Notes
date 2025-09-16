# Basic R


**Get help**

- CRAN: <https://cran.r-project.org>
- Rdocumentation powered by datacamp, it has interactive interface with good examples, the typesetting also looks better, <https://www.rdocumentation.org>
- Posit Cheatsheets: <https://posit.co/resources/cheatsheets/>


R is case-sensitive; comments start with `#`.

Curly brackets or braces `{}` are used to keep code that needs to be run together as a single expression. This is commonly done when writing a function or when writing an `if` statement.

Double curly braces `{{}}` are used programming with `tidyverse`. See the `dplyr`programming vignette for details.

`?Syntax` to check **precedence of operators**.


--------------------------------------------------------------------------------

<h2> Save & Load R objects </h2>


`save(..., f_name)` and `saveRDS()`

`save()` 		When loaded the named object is restored to the current environment (in general use this is the global environment — the workspace) **with the same name it had when saved**. 

`save` writes an external representation of **R** objects to the specified file. The objects can be read back from the file at a later date by using the function `load` or `attach` (or `data` in some cases).

`save(..., list = character(),
     file = stop("'file' must be specified"),
     ascii = FALSE, version = NULL, envir = parent.frame(),
     compress = isTRUE(!ascii), compression_level,
     eval.promises = TRUE, precheck = TRUE)`

- `...` 	 The names of the objects to be saved (as symbols or character strings).
- `list`    A character vector containing the names of objects to be saved.
  - The names of the objects specified **either** as symbols (or character strings) in `...` or as a character **vector** in `list` are used to look up the objects from environment `envir`. 
- `file`    the name of the file where the data will be saved.



`saveRDS()`	doesn’t save the both the object and its name it just saves a representation of the object. As a result, <span style='color:#00CC66'>the saved object can be loaded into a named object</span> within R that is different from the name it had when originally serialized.

> Serialization is the process of converting a data structure or object state into a format that can be stored (for example, in a file or memory buffer, or transmitted across a network connection link) and “resurrected” later in the same or another computer environment.

`saveRDS` 	works only for <span style='color:#00CC66'>saving a single R object</span>, `save()` can save multiple R objects in one file. A workaround for `saveRDS` is to save all target objects in a single R object (e.g., in a **list**), and then use `saveRDS()` to save it at once.

```R
datalist = list(mtcars = mtcars, pressure=pressure)
saveRDS(datalist, "twodatasets.RDS")
rm(list = ls())

datalist = readRDS("twodatasets.RDS")
datalist
```

`rm(list = ls())` removes all objects in the current environment. It will not unload the packages that you have loaded.

If you want to both remove all objects and unload all packages, you can restart your R session.


--------------------------------------------------------------------------------


#### Load R objects {-}

`load(f_name)` to load .`rda` file.

`readRDS(f_name)` to load `.rds` file.

Naming conventions:

- `rda` and `rds` for <span style='color:#00CC66'>selected</span> objects
- `.RData` for <span style='color:#00CC66'>all</span> objectes in your workspace
- The file extensions are up to you; you can use whatever file extensions you want.

An example

```R
> require(mgcv)
Loading required package: mgcv
This is mgcv 1.7-13. For overview type 'help("mgcv-package")'.
> mod <- gam(Ozone ~ s(Wind), data = airquality, method = "REML")
> mod

Family: gaussian
Link function: identity

Formula:
Ozone ~ s(Wind)

Estimated degrees of freedom:
3.529  total = 4.529002

REML score: 529.4881
> save(mod, file = "mymodel.rda")
> ls()
[1] "mod"
> load(file = "mymodel.rda")
> ls()
[1] "mod"


> ls()
[1] "mod"
> saveRDS(mod, "mymodel.rds")
> mod2 <- readRDS("mymodel.rds")
> ls()
[1] "mod"  "mod2"
> identical(mod, mod2, ignore.environment = TRUE)
[1] TRUE
```



-----------------------------------------------------------------------------


#### Save figures in a list  {-}

```R
p_list <- list(p_ano=p_ano, p_tr=p_tr)
# p_list[[name]] <- p_obj
p_list[[1]]

f_name <- paste0(fig_dir, sprintf("trend_analysis/image_list_%s.rds", con_name))
# saveRDS(p_list, f_name)

# plot in a panel grid
p_allCON <- plot_grid(plotlist=p_list, align="vh", labels=sprintf("(%s)", letters[1:length(p_list)]), hjust=-1, nrow=3, label_size=12)
p_allCON
```

-----------------------------------------------------------------------------

## Data Input & Output

### Read Data

**Read Fortran**

`read.fortran(file, format, ..., as.is = TRUE, colClasses = NA)`

- `format` 	Character vector or list of vectors. 

**Read `dta`**

`haven::read_dta()` 	read Stata data file.

```R
data <- read_dta("climate_health_2406yl.dta")
# retrieve variable labels/definitions
var_dict <- tibble(
  "name" = colnames(data),
  "label" = sapply(data, function(x) attr(x, "label")) %>% 
  as.character()
  )
var_dict
                   
var_label(data$gor) # get variable label
val_labels(data$gor) # get value labels 
```


**Read fixed width text files**

#### Base R functions

`read.fwf(file, widths)`

-   `widths` 	integer vector, giving the widths of the fixed-width fields (of one line), or list of integer vectors giving widths for multiline records.



`read.table(f_name, header=FALSE, row.names, col.names, sep="", na.strings = "NA")` a <span style='color:#00CC66'>very versatile</span> function. Can be used to read  `.csv` or `.txt` files. 

- `f_name` 	path to data. 
- `header=FALSE`  defaults to `FALSE`, assumes there is no header row in the file unless specified otherwise.
  - If there is a header in the first row, should specify `header=TRUE`.

- `row.names`     a vector of row names. This can be 
  - *a vector* giving the actual row names, or 
  - *a single number* giving the column of the table which contains the row names, or 
  - *character string* giving the name of the table column containing the row names.

- `col.names`     a vector of optional names for the variables. The default is to use `"V"` followed by the column number.
- `sep` use white space as delimiter.
  - if it is a `csv` file, use `sep=','` to specify comma as delimiter
- `na.strings = "NA"`     a character vector of strings which are to be interpreted as `NA` values.
  - A useful setting: `na.strings = c("", "NA", "NULL")`




`read.csv(f_name, header = TRUE, sep = ",", na.strings = "..", dec=".")`

-   `header = TRUE`  whether the file contains the names of the variables as its first line.
-   `sep`  the field separator string. Values within each row of `x` are separated by this string.
-   `na`    the string to use for missing values in the data.
-   `dec` the string to use for decimal points in numeric or complex columns: must be a single character.
-   `fileEncoding`  `UTF-8`  


When reading data from github, you need to pass in the <span style='color:#00CC66'>raw version</span> of the data in `read.csv()`, 

R cannot read the display version. 

You can get the URL for the raw version by clicking on the Raw button displayed above the data.

<img src="https://drive.google.com/thumbnail?id=192sslQpCtgW2NvJV-SBMZe_eUleYpjY9&sz=w1000" alt="github raw data" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />


`read.table(filename, header=FALSE, sep="")` is more versatile than `read.csv`. Useful when you have a data file saved as txt.
Default separator is "white space" for `read.table`, i.e., one or more spaces, tabs, newlines or carriage returns. 

```r
# read.table can be used to read txt and csv. Need to specify sep=',' when reading csv.
data <- read.table("https://raw.githubusercontent.com/my1396/course_dataset/refs/heads/main/bonedensity.txt", header=TRUE)
data

data <- read.table("https://raw.githubusercontent.com/my1396/course_dataset/refs/heads/main/bonedensity.csv", header=TRUE, sep=",")

# Alternatively, can use read_csv or read.csv directly
data <- read_csv("https://raw.githubusercontent.com/my1396/course_dataset/refs/heads/main/bonedensity.csv")
data
```


--------------------------------------------------------------------------------

#### `readr`

The major difference of `readr` is that it returns a `tibble` instead of a data frame.

`read_delim(f_name, delim = ";", col_names = TRUE, skip = 0)` allows you to specify the delimeter as `;`.

- `col_names = TRUE`  whether the first row contains column names.
- `skip = 0`  number of lines to skip before reading the data. Default is `0`, meaning no lines are skipped.

`read_delim(f_name, delim = "\t")` read tab separated values.

`read_tsv()` read <span style='color:#00CC66'>tab separated values</span>.

--------------------------------------------------------------------------------

Read <span style='color:#00CC66'>comma separated values</span>.

```r
readr::read_csv(
  f_name,
  na = c("..", NA, ""),
  locale = locale(encoding = "UTF-8"),
  col_types = cols(Date = col_date(format = "%m/%d/%y"))
)
```

- `col_types` specify column types. Could be created by `list()` or `cols()`.

  `read_csv` will automatically guess, if you don't explicitly specify column types. You can override column types by providing the argument `col_types`. You don't need to provide all column types, just the ones you want to override.

- By default, reading a file without a column specification will print a message showing what `readr` guessed they were. To remove this message, 

  - set `show_col_types = FALSE` for one time setting, or 
  - set `options(readr.show_col_types = FALSE)` for the current sessions' global options setting.  If want to change permanently everytime when R starts, put ` options(readr.show_col_types = FALSE)`  in `.Rprofile` as global options.



`read_csv2(f_name, na = c("..", NA, ""))`  use <span style='color:#00CC66'>semicolon `;` to separate values</span>; and use comma `,` for the decimal point. This is common in some <u>European countries</u>.

-   `locale` 	The locale controls defaults that vary from place to place. The default locale is US-centric (like R), but you can use `locale()` to create your own locale that controls things like the default time zone, encoding, decimal mark, big mark, and day/month names.
-   `locale(date_names = "en", date_format = "%AD", time_format = "%AT",
      decimal_mark = ".", grouping_mark = ",", tz = "UTC",
      encoding = "UTF-8", asciify = FALSE)`
    -   `decimal_mark`  indicate the decimal place, can only be `,` or `.` 
    -   `encoding` This only affects how the file is read - readr always converts the output to UTF-8. 






--------------------------------------------------------------------------------

### Write Data

Save data in `uft8` encoding with special language characters

`write_excel_csv()`  include a [UTF-8 Byte order mark](https://en.wikipedia.org/wiki/Byte_order_mark) which indicates to Excel the csv is UTF-8 encoded.

`write.csv(x, f_name, row.names=TRUE, fileEncoding ="UTF-8")`

- `x`  a matrix or data frame. If not one of the types, it is attempted to coerce `x` to a data frame.

  - `write_csv(x)`  `x` can only be data frame or tibble. Doesn't support matrix.

    ```r
    mat %>% as_tibble(rownames = "rowname") %>% write_csv("mat.csv")
    mat %>% write.csv("mat.csv")
    ```

- `row.names` whether to write row names of `x`. Defaults to `TRUE`.



#### `flextable` {.unnumbered} 

`flextable` package create tables for reporting and publications.

The main function is `flextable` which takes a `data.frame` as argument and returns a `flextable`. If you are using RStudio or another R GUI, the table will be displayed in the `Viewer` panel or in your default browser.

The package provides a set of functions to easily create some tables from others objects.

The `as_flextable()` function is used to transform specific objects into `flextable` objects. For example, you can transform a crosstab produced with the ‘tables’ package into a flextable which can then be formatted, annotated or augmented with footnotes.


## Functions

Function arguments fall into two sets:

- **data argument**: give input data to compute on
- **detail  argument**: control details of the computation

You can refer to an argument by its unique prefix. That is, **partial matching** is acceptable. But this is generally best avoided to reduce confusion.

When calling a function you can specify arguments by position, by complete name, or by partial name. Arguments are matched  

1. first by exact name (perfect matching), 
2. then by prefix matching, and 
3. finally by position.

If you specify arguments by names (full or partial), you can specify them in any order. If you specify arguments by position, you must specify them in the order they are defined in the function.


**Example:**

Here is a `read.csv()` function.

```r
read.csv(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", ...)
```

If you call

```r
read.csv("path/to/file.csv")
```

it will read the file `path/to/file.csv` with default values for all other arguments.


But if you call 

```r
read.csv(FALSE, "path/to/file.csv")
```

this will return an error because `FALSE` is assigned to `file` and the filename is assigned to the argument `header`.

You can run.

```r
read.csv(header = FALSE, file = "path/to/file.csv")
```

**To summarize:**

- You can pass the arguments to `read.csv` without naming them if they are in the order that `R` expects.
- However, the order of the arguments matter if they are not named.

--------------------------------------------------------------------------------

When you call a function and specify arguments, it is recommended to put a space around `=`, also put a space after a comma, not before.


```r
x <- 10; y <- 5
x + y
#> [1] 15
`+`(x, y)
#> [1] 15

# ----------------------------
for (i in 1:2) print(i)
#> [1] 1
#> [1] 2
`for`(i, 1:2, print(i))
#> [1] 1
#> [1] 2

# ----------------------------
x[3]
#> [1] NA
# Note that only need to call the open braket
`[`(x, 3)
#> [1] NA

# ----------------------------
{ print(1); print(2); print(3) }
#> [1] 1
#> [1] 2
#> [1] 3
`{`(print(1), print(2), print(3))
#> [1] 1
#> [1] 2
#> [1] 3

# ----------------------------
sapply(1:5, `+`, 3)
#> [1] 4 5 6 7 8
sapply(1:5, "+", 3)
#> [1] 4 5 6 7 8
```

Note the difference between ``+`` and `"+"`. The first one is the value of the object called `+`, and the second is a string containing the character `+`. The second version works because `sapply` can be given the name of a function instead of the function itself: if you read the source of `sapply()`, you’ll see the first line uses `match.fun()` to find functions given their names.

**Every operation is a function call**

Every operation in R is a function call, whether or not it looks like one. This includes infix operators like `+`, control flow operators like `for`, `if`, and `while`, subsetting operators like `[]` and `$`, and even the curly brace `{`. This means that each pair of statements in the following example is exactly equivalent. Note that `` ` ``, the backtick, lets you refer to functions or variables that have otherwise reserved or illegal names:

--------------------------------------------------------------------------------


### Inspecting Object Types and Structure

`str(x)`, `class(x)`, and `typeof(x)`

`str(x)` 	focus on the **str**ucture not the contents. The output of the `str()` will vary depending on the type of R object you are passing it. 

- For a data frame, the output will show the names of the columns, the class of each column, and the first few rows of data. 
- For a list, the output will show the names of the elements in the list, the class of each element, and the value of each element.

--------------------------------------------------------------------------------

<span style='color:#00CC66'>**`class(x)`** </span>	returns a `class` attribute, a character vector giving the names of the classes from which the object *inherits*.  变量的类型, eg., dataframe, tibble, vector.

- If the object does not have a class attribute, it has an implicit class, notably `"matrix"`, `"array"`, `"function"` or `"numeric"` or the result of `typeof(x)`.
- A **property** (属性) assigned to an object that determines how generic functions operate with it. It is not a mutually exclusive classification. If an object has no specific class assigned to it, such as a simple numeric vector, it's class is usually the same as its mode, by convention.

```r
library(tibble)
DT <- tibble(a = rnorm(1000), b = rnorm(1000))

DT %>% class() 
[1] "tbl_df"     "tbl"        "data.frame"

DT %>% str() 
tibble [1,000 × 2] (S3: tbl_df/tbl/data.frame)
 $ a: num [1:1000] 1.327 1.71 -0.414 0.515 -0.117 ...
 $ b: num [1:1000] -0.778 1.508 0.816 0.5 -1.874 ...
```

- `str()` is more informative than `class()`. 
  
  `str()` <span class="env-green">includes the class information</span>, but also provides additional details about the structure of the object, such as the number of rows and columns (for data frames), the types of each column, and a preview of the data contained within the object.

--------------------------------------------------------------------------------

`typeof` determines the (R internal) **type or storage** mode of any object.  变量里面存储数据的类型, eg., string, numeric, integer.

- Current values are the vector types `"logical"`, `"integer"`, `"double"`,`"complex"`, `"character"`, `"raw"` and `"list"`, `"NULL"`, `"closure"` (function), `"special"`and `"builtin"` (basic functions and operators), `"environment"`, `"S4"` (some S4 objects) and others that are unlikely to be seen at user level (`"symbol"`, `"pairlist"`, `"promise"`,`"language"`, `"char"`, `"..."`, `"any"`, `"expression"`, `"externalptr"`, `"bytecode"` and`"weakref"`).
- `mode(x)` is similar to `typeof(x)`
- mutually exclusive. One object has one `typeof` and `mode`.


--------------------------------------------------------------------------------

`methods(class="zoo")` get a list of functions that have zoo-methods.

--------------------------------------------------------------------------------

`attributes(x)` returns the object's attributes/metadata as a list. Some of the most common attributes are: row names and column names, dimensions, and class. 

- Attributes are not stored internally as a list and should be thought of as a set and not a vector, i.e, the *order* of the elements of `attributes()`does not matter. 
- To access a specific attribute, you can use the [`attr()`](https://www.rdocumentation.org/packages/base/versions/3.3.2/topics/attr)function.



`attr(x, which)`  Get or set specific attributes of an object.

- `x` 	an object whose attributes are to be accessed.
- `which` a character string specifying which attribute is to be accessed.

`attr(x, which) <- value` specify `value` to the attribute

- `value` an object, the new value of the attribute, or `NULL` to remove the attribute.

```r
# create a 2 by 5 matrix
> x <- 1:10
> attr(x, "dim") <- c(2, 5)
> x
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    3    5    7    9
[2,]    2    4    6    8   10

> my_factor <- factor(c("A", "A", "B"), ordered = T, levels = c("A", "B"))
> my_factor
[1] A A B
Levels: A < B

> attributes(my_factor)
$levels
[1] "A" "B"

$class
[1] "ordered" "factor" 
```


___

Q: What does `1L` mean?  
A: `1L` is a shorthand for `as.integer(1)`. Adding suffix `L` ensures that the value is treated as an integer and it is useful for memory usage and specific computations involving integer operations.

```r
# create numerical value
num_val <- 1

# check the data type
print(class(num_val))
[1] "numeric"

print(typeof(num_val))
[1] "double"
```

```r
# create integer value
int_val <- 1L

# check the data type
print(class(int_val))
[1] "integer"

print(typeof(int_val))
[1] "integer"
```


--------------------------------------------------------------------------------

### Type of Variables

There are two types of vectors:

1. **Atomic** vectors, of which there are six types: **logical**, **integer**, **double**, **character**, **complex**, and **raw**. Integer and double vectors are collectively known as **numeric**vectors.
2. **Lists**, which are sometimes called recursive vectors because lists can contain other lists.

The chief difference between atomic vectors and lists is that atomic vectors are **homogeneous**, while lists can be **heterogeneous**. There’s one other related object: `NULL`. `NULL` is often used to represent the absence of a vector (as opposed to `NA`which is used to represent the absence of a value in a vector). `NULL` typically behaves like a vector of length 0. The Figure below summarises the interrelationships.

<img src="https://r4ds.had.co.nz/diagrams/data-structures-overview.png" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />


#### Variable Coercion {-}

`as.logical` 	convert 0/1 to boolean values

```r
# remove NA values
mask <- is.na(reg_data) %>% rowSums() %>% as.logical()
reg_data[mask,]
reg_data <- reg_data[!mask,]
```

#### Dimension Reduction {-}

Convert a data frame, tibble, list to an atomic vector

`unlist(df)`  or `as.matrix(df) %>% as.vector()`

Convert a matrix to a vector

`as.vector(x)`



<span class="env-green">**`unlist()`**</span> TL;DR: takes in a list, returns a vector. 

It “un-lists” **nested lists** or vectors and converts them into a simple atomic vector. In other words, it takes a list that contains other lists, vectors, or atomic elements and flattens it into a single vector.

- Useful when flatten a nested or hierarchical list to a vector. Dimension reduction. 
  - Simplifying the structure of a data object
  - Passing a list to a function that only accepts vectors
  - Combining the elements of a list into a single vector

```R
> list(1, 2, 3, 4, 5)
  [[1]]
  [1] 1

  [[2]]
  [1] 2

  [[3]]
  [1] 3

	[[4]]
	[1] 4

	[[5]]
	[1] 5

> list(1, 2, 3, 4, 5) %>% unlist()
	[1] 1 2 3 4 5
# flatten a nested list
> list(a = 1, b = list(c = 2, d = 3), e = 4) %>% unlist()
  a b.c b.d   e 
  1   2   3   4 
> data.frame(matrix(1:12,3,4)) %>% unlist() # flatten by column
X11 X12 X13 X21 X22 X23 X31 X32 X33 X41 X42 X43
  1   2   3   4   5   6   7   8   9  10  11  12 
```







### Variable Scope



`with(data, expr, …)` 	Evaluate an R expression, `expr`, in an environment constructed from `data`, possibly modifying (a copy of) the original data.

- `expr` 	a single expression or a compounded one, i.e., of the form

  ```R
  {
       a <- somefun() # do some changes to cols
       b <- otherfun()
       .....
       rm(unused1, temp) # remove cols you don't want anymore
     }
  ```

`within(data, expr, …)`     is similar to `with`, except that it examines the environment after the evaluation of `expr` and **makes the corresponding modifications** to a copy of `data` (this may fail in the data frame case if objects are created which cannot be stored in a data frame), and returns it.

- Returned value: 
  - For `within`, the modified object. 
  - For `with`, the value of the evaluated `expr`. 


```r
with(mtcars, mpg[cyl == 8  &  disp > 350])
# is the same as, but nicer than
mtcars$mpg[mtcars$cyl == 8  &  mtcars$disp > 350]
```




--------------------------------------------------------------------------------


### Control Structures

Note all keywords are lowercase here.

A 'do ... until' loop in R:

```r
repeat {
  # code
  if(stop_condition_is_true) break
}

while(TRUE){
  # Do things
  if (stop_condition_is_true) break
}
```

`break` statement can break out of a loop. 

`next` statement causes the loop to skip the current iteration and start the next one. 

`switch(exp, case1, case2, ...)` the expression is matched with the list of values and the corresponding value is returned.

```r
a <- 4
switch(a,
       "1"="this is the first case in switch",
       "2"="this is the second case in switch",
       "3"="this is the third case in switch",
       "4"="this is the fourth case in switch",
       "5"="this is the fifth case in switch"
       )
```


**`ifelse(test_expression, x, y)`**

The returned vector has element from `x` if the corresponding value of `test_expression` is `TRUE`; or from `y` if the corresponding value of `test_expression` is `FALSE`.

That is the `i-th` element of result will be `x[i]` if `test_expression[i]` is `TRUE` else it will take the value of `y[i]`.

ref: 

- [R programming for Data Science, chap 13, control structures](https://bookdown.org/rdpeng/rprogdatascience/control-structures.html)
