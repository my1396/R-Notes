## Rendering bookdown

Two approaches:

- “Merge and Knit” (M-K): default; runs *all* code chunks in all chapters; the state of the R session from previous chapters is carried over to later chapters (e.g., objects created in previous chapters are available to later chapters, unless you deliberately deleted them)
- “Knit and Merge” (K-M): separate R sessions for individual chapters; all chapters are isolated from each other.

Other differences:

- Because **knitr** does not allow duplicate chunk labels in a source document, you need to make sure there are no duplicate labels in your book chapters when you use the M-K approach, otherwise **knitr** will signal an error when knitting the merged Rmd file. Note that this means there must not be duplicate labels throughout the whole book. 

  The K-M approach only requires no duplicate labels within any single Rmd file.

- K-M does not allow Rmd files to be in subdirectories, but M-K does.

To switch to K-M, you either use the argument `new_session = TRUE` when calling `render_book()`, or set `new_session: yes` in the configuration file `_bookdown.yml`.

--------------------------------------------------------------------------------

### Rendering bookdown website

Assuming you have a **website**, use the following command to render your site:

```r
# render gitbook format only
rmarkdown::render_site(output_format = "bookdown::gitbook")
```


Every time you make changes to individual Rmd files or to CSS style files, you can knit the single page using `rmarkdown::render("0100-RStudio.Rmd")` or the Knit button in the source editor. The change will be reflected to your website.

- This is faster than Build the website.

--------------------------------------------------------------------------------

There are two major ways to build multiple Rmd documents: **blogdown** ([Xie, Hill, and Thomas 2017](https://bookdown.org/yihui/rmarkdown/websites.html#ref-xie2017); [Xie, Dervieux, and Presmanes Hill 2023](https://bookdown.org/yihui/rmarkdown/websites.html#ref-R-blogdown)) for building websites, and **bookdown** ([Xie 2016](https://bookdown.org/yihui/rmarkdown/websites.html#ref-xie2016), [2023a](https://bookdown.org/yihui/rmarkdown/websites.html#ref-R-bookdown))for authoring books. 


**Creating Websites with R Markdown**: <https://bookdown.org/yihui/blogdown/global-options.html>

Q: What's the difference between Bookdown and Blogdown?  
A: Bookdown is for books, grouped in chapters; Blogdown is for blogs, ordered by dates.


--------------------------------------------------------------------------------

### Rendering bookdown book

Assume you have a local bookdown project, you can use the following to [edit, build, preview, and serve](https://bookdown.org/yihui/rmarkdown/bookdown-edit.html) the book locally.

#### Build the book {-}

To build all Rmd files into a book, you can call the function `bookdown::render_book()`. It uses the settings specified in the `_output.yml` (if it exists). If multiple output formats are specified in it, all formats will be built. 

If you are using RStudio, this can be done through the `Build` tab. Open the drop down menu `Build Book` if you only want to build one format.


<img src="https://drive.google.com/thumbnail?id=1jKHiMv3_CsiQ-EaojBr2cs_G3nRgwuag&sz=w1000" alt="bookdown-build" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

#### Preview a chapter {-}

Building the whole book can be slow when the size of the book is big or your book contains large amounts of computation. We can use the `preview_chapter()` function in bookdown to only **build a single chapter** at a time. Equivalently, you can click the `Knit` button in RStudio.

#### Serve the book {-}

Instead of running `render_book()` or `preview_chapter()` each time you want to view the changes, you can use the function `bookdown::serve_book()` to start a live preview of the book. Any time a Rmd file is saved, the book will be recompiled automatically, and the preview will be updated to reflect the changes.




--------------------------------------------------------------------------------

**Control long outputs by using hooks**

1. Put the following functions to the set up code chunk.

2. Then you could use the option `max.lines = 10` whenever you want to set a limit to the maximum output length to print.

```r
## control long outputs by using eg `max.lines = 10`
hook_output_default <- knitr::knit_hooks$get('output')
truncate_to_lines <- function(x, n) {
   if (!is.null(n)) {
      x = unlist(stringr::str_split(x, '\n'))
      if (length(x) > n) {
         # truncate the output
         x = c(head(x, n), '...\n')
      }
      x = paste(x, collapse = '\n') # paste first n lines together
   }
   x
}
knitr::knit_hooks$set(output = function(x, options) {
   max.lines <- options$max.lines
   x <- truncate_to_lines(x, max.lines)
   hook_output_default(x, options)
})
```

--------------------------------------------------------------------------------

**Issue**: <u>In RStudio dark mode</u>, `kableExtra` tables are invisible in the code block output preview because both the font and background are white, making the content unreadable.

Fix: Force the font color to be black. 

First run this edited version of `kableExtra:::print.kableExtra()`:


```r
print.kableExtra <- function (x, ...) {
  view_html <- getOption("kableExtra_view_html", TRUE)
  if (view_html & interactive()) {
    dep <- list(
      rmarkdown::html_dependency_jquery(), 
      rmarkdown::html_dependency_bootstrap(theme = "cosmo"), 
      kableExtra::html_dependency_kePrint(), 
      kableExtra::html_dependency_lightable()
    )
    
    x <- sub('style="', 'style="color: black; ', as.character(x), fixed = TRUE)
        
    html_kable <- htmltools::browsable(
      htmltools::HTML(
        as.character(x), 
        "<script type=\"text/x-mathjax-config\">MathJax.Hub.Config({tex2jax: {inlineMath: [[\"$\",\"$\"]]}})</script><script async src=\"https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\"></script>"
      )
    )
    htmltools::htmlDependencies(html_kable) <- dep
    class(html_kable) <- "shiny.tag.list"
    print(html_kable)
  }
  else {
    cat(as.character(x))
  }
}
```

The changes consisted of adding the `x <- sub('style="', 'style="color: black; ', as.character(x), fixed = TRUE)` line and also adding full references to some of the functions.

Then you can print the table as before, the table font color will be forced to be black, and hence visible.

```r
library(tidyverse)
head(iris) %>% 
  knitr::kable(caption = "**Table 1.** Iris data. ", digits = 2) %>% 
  kableExtra::kable_styling()
```

