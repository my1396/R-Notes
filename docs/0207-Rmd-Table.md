## Tables

<span style='color:#00CC66'>**Cross reference tables**</span>

Using `bookdown` cmd: `\@ref(tab:chunk-label)`.

Note that you must provide `caption` option in `knitr::kable()`. Otherwise the table won't be numbered.

~~~markdown
And see Table \@ref(tab:mtcars).

```{r mtcars, echo=FALSE}
knitr::kable(mtcars[1:5, 1:5], caption = "The mtcars data.")
```
~~~

Refer to the Table \@ref(tab:mtcars).


Table: (\#tab:mtcars)The mtcars data.

|                  |  mpg| cyl| disp|  hp| drat|
|:-----------------|----:|---:|----:|---:|----:|
|Mazda RX4         | 21.0|   6|  160| 110| 3.90|
|Mazda RX4 Wag     | 21.0|   6|  160| 110| 3.90|
|Datsun 710        | 22.8|   4|  108|  93| 3.85|
|Hornet 4 Drive    | 21.4|   6|  258| 110| 3.08|
|Hornet Sportabout | 18.7|   8|  360| 175| 3.15|




`knitr::kable(x, format="pipe")` is useful when you want to copy-and-paste R output from console to other document, e.g., markdown.


```r
knitr::kable(mtcars[1:5, 1:5], format = "pipe")
|                  |  mpg| cyl| disp|  hp| drat|
|:-----------------|----:|---:|----:|---:|----:|
|Mazda RX4         | 21.0|   6|  160| 110| 3.90|
|Mazda RX4 Wag     | 21.0|   6|  160| 110| 3.90|
|Datsun 710        | 22.8|   4|  108|  93| 3.85|
|Hornet 4 Drive    | 21.4|   6|  258| 110| 3.08|
|Hornet Sportabout | 18.7|   8|  360| 175| 3.15|
```


--------------------------------------------------------------------------------

### `knitr::kable`

`knitr::kable(x, digits, caption=NULL, escape=TRUE)` Create tables in LaTeX, HTML, Markdown and reStructuredText. 

- `caption` 	The table caption. In order to number the table, mut specify the `caption` argument.

- `format`            Possible values are `latex`, `html`, `pipe` (Pandoc's pipe tables), `simple` (Pandoc's simple tables), `rst`, and `jira`. 

  The value of this argument will be <span style='color:#00CC66'>automatically determined</span> if the function is called within a **knitr** document. 

- `digits`           Maximum number of digits for numeric columns, passed to `round()`. 

- `col.names`     Rename columns.

- `escape=TRUE` 	Whether to escape special characters when producing HTML or LaTeX tables. Default is `TRUE`, special characters will either be escaped or substituted.  For example, `$` is escaped as `\$`, `_` is escaped as `\_`, and `\` is substituted with `\textbackslash{}`

  - When set to `FALSE`, you have to make sure **yourself** that special characters will not trigger syntax errors in LaTeX or HTML.
  - Common special LaTeX characters include `#`, `%`, `&`, `{`, and `}`. Common special HTML characters include `&`, `<`, `>`, and `"`. You need to be cautious when generating tables with `escape = FALSE`, and make sure you are using the special characters in the right way. It is a very common mistake to use `escape = FALSE` and include `%` or `_` in column names or the caption of a LaTeX table without realizing that they are special.

- `align`      Column alignment: a character **vector** consisting of `'l'` (left), `'c'` (center) and/or `'r'` (right). 

  - By default or if `align = NULL`, <span style='color:#00CC66'>numeric columns are right-aligned</span>, and <span style='color:#00CC66'>other columns are left-aligned</span>.
  - If only one character is provided, that will apply to all columns.
  - If a vector is provided, will map to each individual column specifically.

- Missing values (`NA`) in the table are displayed as `NA` by default. If you want to display them with other characters, you can set the option `knitr.kable.NA`, e.g. <span style='color:#00CC66'>`options(knitr.kable.NA = '')`</span> in the YAML to hide `NA` values.

- <span style='color:#00CC66'>`booktabs = TRUE`</span>   use the booktabs package

  - `linesep = ""`      remove the extra space after every five rows in kable output (with `booktabs` option)

```r
# For Markdown tables, use `pipe` format
> knitr::kable(head(mtcars[, 1:4]), format = "pipe")
|                  |  mpg| cyl| disp|  hp|
|:-----------------|----:|---:|----:|---:|
|Mazda RX4         | 21.0|   6|  160| 110|
|Mazda RX4 Wag     | 21.0|   6|  160| 110|
|Datsun 710        | 22.8|   4|  108|  93|
|Hornet 4 Drive    | 21.4|   6|  258| 110|
|Hornet Sportabout | 18.7|   8|  360| 175|
|Valiant           | 18.1|   6|  225| 105|

# For Plain tables in txt, `simple` is useful
> knitr::kable(head(mtcars[, 1:4]), format = "simple") 
                      mpg   cyl   disp    hp
------------------  -----  ----  -----  ----
Mazda RX4            21.0     6    160   110
Mazda RX4 Wag        21.0     6    160   110
Datsun 710           22.8     4    108    93
Hornet 4 Drive       21.4     6    258   110
Hornet Sportabout    18.7     8    360   175
Valiant              18.1     6    225   105
```

--------------------------------------------------------------------------------

### Data frame printing

To show the `tibble` information (number of row/columns, and group information) along with paged output, we can write a custom function by modifying the [`print.paged_df`](https://github.com/rstudio/rmarkdown/blob/main/R/html_paged.R#L241-L248) function (which is used internally by rmarkdown for the `df_print` feature) and use CSS to nicely format the output.

<https://stackoverflow.com/a/76014674/10108921>

<span style='color:#00CC66'>**Paged df**</span>

- <https://bookdown.org/yihui/rmarkdown/html-document.html#tab:paged>
- <https://github.com/rstudio/rmarkdown/issues/1403>

```markdown
---
title: "Use caption with df_print set to page"
date: "2025-08-02"
output:
  bookdown::html_document2:
    df_print: paged
---
```

When the `df_print` option is set to `paged`, tables are printed as HTML tables with support for pagination over rows and columns.

The possible values of the `df_print` option for the `html_document` format.

| Option                                     | Description                                                  |
| ------------------------------------------ | ------------------------------------------------------------ |
| `default`                                  | Call the `print.data.frame` generic method; console output prefixed by `##`; |
| `kable`                                    | Use the `knitr::kable` function; looks nice but with no navigation for rows and columns, neither column types. |
| `tibble`                                   | Use the `tibble::print.tbl_df` function, this provides groups and counts of rows and columns info as if printing a `tibble`. |
| <span style='color:#00CC66'>`paged`</span> | Use `rmarkdown::paged_table` to create a pageable table; `paged` looks best but slows down compilation significantly; |
| A custom function                          | Use the function to create the table                         |

The possible values of the `df_print` option for the `pdf_document` format: `default`, `kable`, `tibble`, `paged`, or a custom function.

~~~~markdown
paged print

```{r echo=TRUE, paged.print=TRUE}
ggplot2::diamonds
```

default output

```{r echo=TRUE, paged.print=FALSE}
ggplot2::diamonds
```

kable output

```{r echo=TRUE}
knitr::kable(ggplot2::diamonds[1:10, ])
```
~~~~

<img src="https://drive.google.com/thumbnail?id=1sgdIhRZSBnyomMIgr-d5y3wsYefGZm4C&sz=w1000" alt="df printing" style="display: block; margin-right: auto; margin-left: auto; zoom:60%;" />

Note that `kable` output doesn't provide tibble information.



Available options for `paged` tables:

| Option         | Description                                           |
| -------------- | ----------------------------------------------------- |
| max.print      | The number of rows to print.                          |
| rows.print     | The number of rows to display.                        |
| cols.print     | The number of columns to display.                     |
| cols.min.print | The minimum number of columns to display.             |
| pages.print    | The number of pages to display under page navigation. |
| paged.print    | When set to `FALSE` turns off paged tables.           |
| rownames.print | When set to `FALSE` turns off row names.              |

These options are specified in each chunk like below:

~~~markdown
```{r cols.print=3, rows.print=3}
mtcars
```
~~~


For **pdf_document**, it is possible to write LaTex code directly.

````markdown
```{=latex}
\begin{tabular}{ll}
A & B \\
A & B \\
\end{tabular}
```
````


Do not forget the equal sign before `latex`, i.e., it is `=latex` instead of `latex`. 

--------------------------------------------------------------------------------


### Stargazer

`stargazer` print nice tables in `Rmd` documents and `R` scripts:

- Passing a data frame to stargazer package creates a <span style='color:#00CC66'>**summary statistic table**</span>. 

- Passing a regression object creates a nice <span style='color:#00CC66'>**regression table**</span>.  

- Support tables output in multiple formats: `text`, `latex`, and `html`.
    - In `R` scripts, use `type = "text"` for a quick view of results. 

- `stargaer` does NOT work with `anova` table, use `pander::pander` instead.

#### Text table {-}

Specify `stargazer(type = "text")`

````markdown
```{r descrptive-analysis-text, comment = ''}
apply(data[,-1], 2, get_stat) %>% 
    stargazer(type = "text", digits=2)
```
````
The text output looks like the following.
```
===============================================
                        Dependent variable:    
                    ---------------------------
                            delta_infl         
-----------------------------------------------
unemp                         -0.091           
                              (0.126)          
                                               
Constant                       0.518           
                              (0.743)          
                                               
-----------------------------------------------
Observations                    203            
R2                             0.003           
Adjusted R2                   -0.002           
Residual Std. Error      2.833 (df = 201)      
F Statistic             0.517 (df = 1; 201)    
===============================================
Note:               *p<0.1; **p<0.05; ***p<0.01
```

By default, `stargazer` uses `***`, `**`, and `*` to denote statistical significance at the one, five, and ten percent levels (`* p<0.1; ** p<0.05; *** p<0.01`). In contrast, `summary.lm` uses `* p<0.05, ** p<0.01, *** p< 0.001`.

You can change the cutoffs for significance using `star.cutoffs = c(0.05, 0.01, 0.001)`.

There is one empty line after each coefficient, to remove the empty lines, specify `no.space = TRUE`. 

The regression table with all empty lines removed:

```
===============================================
                        Dependent variable:    
                    ---------------------------
                            delta_infl         
-----------------------------------------------
unemp                         -0.091           
                              (0.126)          
Constant                       0.518           
                              (0.743)          
-----------------------------------------------
Observations                    203            
R2                             0.003           
Adjusted R2                   -0.002           
Residual Std. Error      2.833 (df = 201)      
F Statistic             0.517 (df = 1; 201)    
===============================================
Note:               *p<0.1; **p<0.05; ***p<0.01
```


#### HTML table {-}

Note that you need to specify `results="asis"` in the chunk options.  This option tells `knitr` to treat verbatim code blocks "as is." Otherwise, instead of your table, you will see the raw html or latex code.

- Note that `*`'s do not show properly in html output, see Fig. \@ref(fig:stargazer1), need to specify in the footnote (`notes`) manually.

<div class="figure">
<img src="images/stargazer1.png" alt="Failed to show significance codes." width="198" />
<p class="caption">(\#fig:stargazer1)Failed to show significance codes.</p>
</div>

Use the following code to display the correct significance symbols. See Fig. \@ref(fig:stargazer2) for the expected output.

````markdown
```{r descrptive-analysis-html, results="asis"}
apply(data[,-1], 2, get_stat) %>% 
    stargazer(type = "html", digits=2, 
              notes = "<span>&#42;</span>: p<0.1; <span>&#42;&#42;</span>: <strong>p<0.05</strong>; <span>&#42;&#42;&#42;</span>: p<0.01 <br> Standard errors in parentheses.",
              notes.append = F)
```
````


<div class="figure">
<img src="images/stargazer1.png" alt="Correct significance codes." width="198" />
<p class="caption">(\#fig:stargazer2)Correct significance codes.</p>
</div>



**Common arguments**:

- `type` 	specify output table format. Possible values: `latex` (default for latex code), `html`, and `text`. Need to specify to `html` in html outputs.

- `digits`     an integer that indicates how many decimal places should be used. A value of `NULL` indicates that no rounding should be done at all, and that all available decimal places should be reported. Defaults to 3 digits.

- `notes`       a character vector containing notes to be included below the table.

- `notes.append = FALSE`  a logical value that indicates whether `notes` should be appended to the existing standard note(s) associated with the table's `style` (typically an explanation of significance cutoffs). 
  - Defaults to `TRUE`.
  - If the argument's value is set to `FALSE`, the character strings provided in `notes` will replace any existing/default notes.


- `notes.align`  `"l"` for left alignment, `"r"` for right alignment, and `"c"` for centering. This argument is not case-sensitive.
  

- `single.row = TRUE` to put coefficients and standard errors on same line


- <span style='color:#00CC66'>`no.space = TRUE`</span>  to remove the spaces after each line of coefficients


- `font.size = "small"`  to make font size smaller


- <span style='color:#00CC66'>`column.labels`</span>  a character vector of labels for columns in regression tables.
    
    This is useful to denote different regressions, informing the name/nature of the model, instead of using numers to identify them.


- `column.separate`   a numeric vector that specifies how `column.labels` should be laid out across regression table columns. A value of `c(2, 1, 3)`, for instance, will apply the first label to the two first columns, the second label to the third column, and the third label will apply to the following three columns (i.e., columns number four, five and six).


- `dep.var.labels` labels for dependent variables


- <span style='color:#00CC66'>`covariate.labels`</span>  labels for covariates in the regression tables.

    Can provide latex symbols in the labels, need to escape special symbols though.

    ```r
    stargazer(mod_sel_lm_mtcars, 
              covariate.labels = 
              c("(Intercept)", "drat", "hp", "$w_{i}$",
                "\\textit{k}", "logLik", "AICc", "\\Delta AICc"))
    ```



- `add.lines`  add a row(s), such as reporting fixed effects.

    ```r
    stargazer(output, output2, type = "html",
              add.lines = list(
                c("Fixed effects?", "No", "No"),
                c("Results believable?", "Maybe", "Try again later")
                )
              )
    ```


Add a blank line under the `stargazer` table: `&nbsp;` with a blank line above and below.


--------------------------------------------------------------------------------

**Cross reference `stargazer` tables.**

- **In pdf output**, use `Table \@ref(tab:reg-table)` or `Table \ref{tab:reg-table}`.

  ````markdown
  Table \@ref(tab:reg-table) summarize the regression results in a table.
  
  ```{r, include=TRUE, results='asis'}
  stargazer(capm_ml, FF_ml, type='latex', header=FALSE,
            digits=4, no.space = TRUE,
            title="Regression Results for META",
            label = "tab:reg-table")
  ```
  ````

  - <span style='color:#00CC66'>`header=FALSE`</span> is to suppress the `% Table created by stargazer` header. This applies to only `latex` tables.

  - `label="tab:reg-table"` is to specify the cross reference label for the table.

  - <span style='color:#00CC66'>`table.placement = "H"`</span>  set float to `H` to fix positions.  Places the float at *precisely* the location in the code. This requires the <span style='color:#00CC66'>`float`</span> LaTeX package. Remember to load it in the YAML.

    - Defaults to `"!htbp"`. 

      The `htbp` controls where the table or figure is placed. Tables and figures do not need to go where you put them in the text. LATEX moves them around to prevent large areas of white space from appearing in your paper.
      `h` (Here): Place the float here, i.e., *approximately* at the same point it occurs in the source text (however, *not exactly* at the spot)
      `t` (Top): Place the table at the top of the *current* page
      `b` (Bottom):  Place the table at the *bottom* of the current page.
      `p` (Page): Place the table at the top of the *next* page.
      `!`: Override internal parameters LaTeX uses for determining "good" float positions. 

  - `align = FALSE` 	a logical value indicating whether numeric values in the same column should be aligned at the decimal mark in LaTeX output.
  

- **In html output**, cross references to stargazer tables are not so straightforward.

  `label` option in `stargazer` does not work. Cannot use chunk labels either.

  ````markdown
  ```{r fit-age, echo=FALSE, results='asis', fig.cap="Logistic regression of CHD on age."}
  # Use title caption from fig.cap
  tit <- knitr::opts_current$get("fig.cap")
  # Adding caption for html output
  tit_html <- paste0('<span id="tab:',
                     knitr::opts_current$get("label"),
                     '">(#tab:',
                     knitr::opts_current$get("label"),
                     ')</span>',
                     tit)
  stargazer::stargazer(fit.age,
            label = paste0("tab:", knitr::opts_current$get("label")),
            title = ifelse(knitr::is_latex_output(), tit, tit_html),
            type = ifelse(knitr::is_latex_output(),"latex","html"),
            notes = "<span>&#42;</span>: p<0.1; <span>&#42;&#42;</span>: <strong>p<0.05</strong>; <span>&#42;&#42;&#42;</span>: p<0.01 <br> Standard errors in parentheses.",
            notes.append = F,
            header = F
            )
  ```
  
  Here is another reference to stargazer Table \@ref(tab:fit-age).
  ````

  Don't change things unless it is absolutely necessary. Run the code chunk before compiling the whole website. It gets slowly as the website gets larger. 

  `stargazer::stargazer()` the `::` is necessary, and `header=F` is necessary and should be place at the end, otherwise will have errors as follows.

  ```r
  Error in `.stargazer.wrap()`:
  ! argument is missing, with no default
  Backtrace:
   1. stargazer::stargazer(...)
   2. stargazer:::.stargazer.wrap(...)
  Execution halted
  
  Exited with status 1.
  ```

  Another example if you don't need to add footnotes.

  ````markdown
  ```{r mytable, results='asis', fig.cap="This is my table."}
  
  # Use title caption from fig.cap
  tit <- knitr::opts_current$get("fig.cap")
  
  # Adding caption for html output
  tit_html <- paste0('<span id="tab:',
                     knitr::opts_current$get("label"),
                     '">(#tab:',
                     knitr::opts_current$get("label"),
                     ')</span>',
                     tit)
  
  stargazer::stargazer(fit.age,
                       label = paste0("tab:", knitr::opts_current$get("label")),
                       title = ifelse(knitr::is_latex_output(), tit, tit_html),
                       type = ifelse(knitr::is_latex_output(),"latex","html"),
                       header = F
                       )
  ```
  
  Here is a reference to stargazer Table \@ref(tab:mytable).
  ````

  

 **Alignment of Stargazer Tables**

- In PDF, the tables will be in the center by default. 

- However, when working with HTML output, you need to add CSS styling to adjust the table. 


References:

- <https://libguides.princeton.edu/c.php?g=1326286&p=9763596#s-lg-box-wrapper-36305037>

--------------------------------------------------------------------------------

### `xtable`

`print(xtable(tableResults, caption = NULL, digits = NULL), include.rownames=FALSE)`  Convert an **R** object to an `xtable` object, which can then be printed as a LaTeX or HTML table.

-   `align` 	Character vector of length equal to the number of columns of the resulting table, indicating the alignment of the corresponding columns. Also, `"|"` may be used to produce vertical lines between columns in LaTeX tables, but these are effectively ignored when considering the required length of the supplied vector. 
    -   If a character vector of length one is supplied, it is split as `strsplit(align, "")[[1]]` before processing. Since the row names are printed in the first column, the length of `align` is one greater than `ncol(x)` if `x` is a `data.frame`. 
    -   Use `"l"`, `"r"`, and `"c"` to denote left, right, and center alignment, respectively. 
    -   Use `"p{3cm}"` etc. for a LaTeX column of the specified width. For HTML output the `"p"` alignment is interpreted as `"l"`, ignoring the width request. Default depends on the class of `x`.

-   `caption`   Character vector of length 1 or 2 containing the table's caption or title. If length is 2, the second item is the "short caption" used when LaTeX generates a "List of Tables". 
-   `digits`     Numeric vector of length equal to one (in which case it will be replicated as necessary) or to the number of columns of the resulting table **or** matrix of the same size as the resulting table, indicating the number of digits to display in the corresponding columns. 







--------------------------------------------------------------------------------

### `kableExtra`

The **kableExtra** package is designed to extend the basic functionality of tables produced using `knitr::kable()`.

`kableExtra::kable_styling(bootstrap_options = c("striped", "hover"), full_width = FALSE)`

- `bootstrap_options` 	A character vector for bootstrap table options. Please see package vignette or visit the w3schools' [Bootstrap Page](https://www.w3schools.com/bootstrap/bootstrap_tables.asp) for more information. Possible options include `basic`, `striped`, `bordered`, `hover`, `condensed`, `responsive` and `none`.

  - `striped`   alternating row colors
  - `hover`       Use the `:hover` selector on `tr` (table row) to <span style='color:#00CC66'>highlight table rows</span> on mouse over.

- `full_width`              A `TRUE` or `FALSE` variable controlling whether the HTML table should have 100% the preferable format for `full_width`. If not specified, 

  - `TRUE` for a HTML table , will have full width by default but 
  - this option will be set to `FALSE` for a LaTeX table.

- `latex_options` 	A character vector for **LaTeX** table options, i.e., won't have effecs on html tables. 

  Possible options:

  | Arguments       | Meanings                                                     |
  | --------------- | ------------------------------------------------------------ |
  | `striped`       | Add alternative row colors to the table. It will imports `LaTeX` package `xcolor` if enabled. |
  | `scale_down`    | useful for super **wide** table. It will automatically adjust the table to <span style='color:#00CC66'>fit the page width</span>. |
  | `repeat_header` | only meaningful in a **long** table environment. It will let the header row repeat on every page in that long table. |
  | `hold_position` | "hold" the floating table to the exact position. It is useful when the `LaTeX` table is contained in a `table` environment after you specified captions in `kable()`. It will force the table to stay in the position where it was created in the document. |
  | `HOLD_position` | A stronger version of `hold_position`. Requires the float package and specifies ⁠[H]⁠. |

  

Rows and columns can be grouped via the functions `pack_rows()` and `add_header_above()`, respectively. 

`scroll_box(width = "100%", height = "500px")`  let you create a fixed height table while **making it scrollable**. This function only works for html long tables.

```r
# commonly used settings 
table %>% 
    knitr::kable(digits = 5) %>%
    kable_styling(bootstrap_options = c("striped", "hover"), full_width = FALSE, latex_options="scale_down") %>% 
    scroll_box(width = "100%", height = "500px")
```


```r
# escape=TRUE, this makes your life easier, will output the table exactly as it is
result <- read_csv("~/Documents/GDP/data/reg_result/IFE_result.csv")
result %>%
  knitr::kable(digits = 5, escape=T) %>%
  kable_styling(bootstrap_options = c("striped", "hover"), full_width = FALSE, latex_options="scale_down")
```


```r
# escape=FALSE, have to specify escape by replace `*` to `\\\\*`
result <- read_csv("~/Documents/GDP/data/reg_result/IFE_result.csv")
result <- result %>% 
  mutate(pval.symbol = gsub("[*]", "\\\\*", pval.symbol) )
result %>%
  knitr::kable(digits = 5, escape=FALSE) %>%
  kable_styling(bootstrap_options = c("striped", "hover"), full_width = FALSE, latex_options="scale_down")
```



**tables in pdf output**

```r
reg_data %>% 
    select(Date, adjusted, eRi, rmrf) %>%
    head(10) %>% 
    knitr::kable(digits = c(0,2,4,4), escape=T, format = "latex", booktabs = TRUE, linesep = "" ) %>%
    kable_styling(latex_options = c("striped"), full_width = FALSE, stripe_color = "gray!15")
```

`knitr::kable()` arguments

- `format = "latex"` specifies the output format.

- `align = "l"` specifies column alignment.

- `booktabs = TRUE` is generally recommended for formatting LaTeX tables.

- `linesep = ""` prevents default behavior of extra space every five rows.

--------------------------------------------------------------------------------

`kableExtra::kable_styling()` arguments

- `position = "left"` places table on left hand side of page.
- `latex_options = c("striped", "repeat_header")` implements table striping with repeated headers for tables that span multiple pages.
- `stripe_color = "gray!15"` species the stripe color using LaTeX color specification from the [xcolor package](https://mirror.mwt.me/ctan/macros/latex/contrib/xcolor/xcolor.pdf) - this specifies a mix of 15% gray and 85% white.

--------------------------------------------------------------------------------

`linebreak(x, align = "l", double_escape = F, linebreaker = "\n")`  Make linebreak in LaTeX Table cells.

- `align="l"`  Choose from "l", "c" or "r". Defaults to "l".

--------------------------------------------------------------------------------


**Customize the looks for columns/rows**

`kableExtra::column_spec(kable_input)` this function allows users to select a column and then specify its look.

`row_spec()` works similar with `column_spec()` but defines specifications for rows. 

- For the position of the target row, you don’t need to count in header rows or the group labeling rows.
- `row_spec(row = 0, align='c')` specify format of the header row. Here I want to center align headers.

--------------------------------------------------------------------------------

**Add header rows to group columns**

`add_header_above()`. The header variable is supposed to be a named character with the names as new column names and values as column span. For your convenience, if column span equals to 1, you can ignore the `=1` part so the function below can be written as `add_header_above(c("", "Group 1" = 2, "Group 2" = 2, "Group 3" = 2))`.

```r
kbl(dt) %>%
  kable_classic() %>%
  add_header_above(c(" " = 1, "Group 1" = 2, "Group 2" = 2, "Group 3" = 2))
```

<img src="https://drive.google.com/thumbnail?id=1YGxysn1yorC6RzJq7m2KAvA6SWhdpZKx&sz=w1000" alt="group columns1" style="zoom:100%;" />

You can add another row of header on top.

--------------------------------------------------------------------------------

**Group rows**

`collapse_rows` will put <u>repeating cells in columns</u> into multi-row cells. The vertical alignment of the cell is controlled by `valign` with default as “top”.

Not working for html output.

```r
collapse_rows_dt <- data.frame(C1 = c(rep("a", 10), rep("b", 5)),
                 C2 = c(rep("c", 7), rep("d", 3), rep("c", 2), rep("d", 3)),
                 C3 = 1:15,
                 C4 = sample(c(0,1), 15, replace = TRUE))
kbl(collapse_rows_dt, align = "c") %>%
  kable_paper(full_width = F) %>%
  column_spec(1, bold = T) %>%
  collapse_rows(columns = 1:2, valign = "top")
```

<img src="https://drive.google.com/thumbnail?id=12STz3rDkTL-d2bDW5etwX5o-g6_zhcnj&sz=w1000" alt="group columns2" style="zoom:100%;" />

Empty string as column name in `tibble`: use `setNames` or `attr`

```r
df <- tibble(" "=1)
setNames(df, "")
# # A tibble: 1 x 1
#      ``
#   <dbl>
# 1     1

attr(df, "names") <- c("")
```

`footnote()` add footnotes to tables. There are four notation systems in `footnote`, namely `general` (no prefix for footnotes), `number`, `alphabet` and `symbol`. 

--------------------------------------------------------------------------------

**Math in rmd tables**

`knitr::kable(x, escape=TRUE)` 

- `escape=TRUE` 	whether to escape special characters when producing HTML or LaTeX tables. 
  - Defaults to `TRUE`.
  - When `escape = FALSE`, you have to make sure that special characters will not trigger syntax errors in LaTeX or HTML.


You need to escape `\` passed into R code.

````markdown
```{r, echo=FALSE}
library(knitr)

mathy.df <- data.frame(site = c("A", "B"), 
                       b0 = c(3, 4), 
                       BA = c(1, 2))

colnames(mathy.df) <- c("Site", "$\\beta_0$", "$\\beta_A$")

kable(mathy.df, escape=FALSE)
```
````

<img src="https://drive.google.com/thumbnail?id=1dD-dt1UDgHAOGtiQ7BHyf86N19Tq9HhA&sz=w1000" alt="rmd table" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />



It is possible to edit Latex table directly in `Rmd`.

- Don't enclose in `$$`.
- Use `\begin{table}` and start your table data.








