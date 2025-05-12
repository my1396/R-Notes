# Basic R


**Get help**

- CRAN: <https://cran.r-project.org>




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
rm(list=ls())

datalist = readRDS("twodatasets.RDS")
datalist
```


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
var_dict <- tibble("name" = colnames(data),
                   "label" = sapply(data, function(x) attr(x, "label")) %>% 
                                as.character()
                   )
var_dict
                   
var_label(data$gor) # get variable label
val_labels(data$gor) # get value labels 
```


**Read fixed width text files**

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




`read_delim(f_name, delim=";")` allows you to specify the delimeter as `;`.

`readr::read_csv(f_name, na = c("..", NA, ""), `
		   `locale = locale(encoding = "UTF-8"), `
		   `col_types = cols(Date = col_date(format = "%m/%d/%y")) )`  read <span style='color:#00CC66'>comma separated values</span>.

- `col_types` specify column types. Could be created by `list()` or `cols()`.

  `read_csv` will automatically guess, if you don't explicitly specify column types. You can override column types by providing the argument `col_types`. You don't need to provide all column types, just the ones you want to override.

- By default, reading a file without a column specification will print a message showing what `readr` guessed they were. To remove this message, 

  - set `show_col_types = FALSE` for one time setting, or 
  - set `options(readr.show_col_types = FALSE)` for the current sessions' global options setting.  If want to change permanently everytime when R starts, put ` options(readr.show_col_types = FALSE)`  in `.Rprofile` as global options.

`read_tsv()` read <span style='color:#00CC66'>tab separated values</span>.

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



#### `flextable`  

`flextable` package create tables for reporting and publications.

The main function is `flextable` which takes a `data.frame` as argument and returns a `flextable`. If you are using RStudio or another R GUI, the table will be displayed in the `Viewer` panel or in your default browser.

The package provides a set of functions to easily create some tables from others objects.

The `as_flextable()` function is used to transform specific objects into `flextable` objects. For example, you can transform a crosstab produced with the ‘tables’ package into a flextable which can then be formatted, annotated or augmented with footnotes.






