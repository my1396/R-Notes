## Options

**`getOption(x)`** 	Allow the user to set and examine a variety of global *options* which affect the way in which **R computes and displays its results.** Use ` getOption` to check default values of global options.

- `x` 	a <span style='color:#00CC66'>character string </span>holding an option name, must be <span style='color:#00CC66'>quoted in quotes</span>
- Can only query one option at a time. If multiple options are given, will return the value of the first option.

**`options(...)`** query and modify global options.

- `...` 	any options can be defined, using `name = value`. 

  Note that you do <span style='color:#00CC66'>NOT need to quote your option name</span> here!

- `options()` with no arguments returns a list with the current values of the options. 

- `options("name")` can be used to examine options' current value too; return a *list*, whereas `getOption("name")`  returns the value only.

  - Note that you need to quote the option name when you do queries.
  - You can query more than one options at a time.
  
    ```r
    > options("width", "digits")
    $width
    [1] 90
    
    $digits
    [1] 7
    
    > getOption("width", "digits")
    [1] 90
    ```

**`?options`**  to get the help page of global options. To check which options are available and their definitions.

**Use examples**

```r
## Two ways checking default option values
> options("width")
$width
[1] 81

> getOption("width")
[1] 81

## Change option values
# use name=value
> options(width=80, digits=15) # set print width, digits to print for numeric values using name=value paris
# use a named list
> options(list(width=80, digits=15)) 
```

<div style="height:3px;"><br></div>

**Commonly used global options**:

| Option        | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| width         | Controls the maximum number of columns <u>on a line</u> used in printing vectors, matrices and arrays, and when filling by `cat`. Defaults to 80.<br />Don't change this if you want to print more columns. Use <span style='color:#00CC66'>`options(tibble.width=400)`</span> instead. |
| pillar.sigfig | Tibbles print numbers with <span style='color:#00CC66'>**three** significant digits</span> by default, switching to scientific notation if the available space is too small.<br />`options(pillar.sigfig = 4)` to increase the number of digits printed out. |



--------------------------------------------------------------------------------

## R Startup

**`Sys.getenv(x)`** 	get the values of the environment variables. Returns a vector of the same length as `x`. 

- `x`	a character vector

Environment Variables examples:

```r
> Sys.getenv(c("HOME", "R_HOME", "R_PAPERSIZE", "R_PRINTCMD"))
           HOME                                      R_HOME 
"/Users/menghan" "/Library/Frameworks/R.framework/Resources" 
    R_PAPERSIZE                                  R_PRINTCMD 
           "a4"                                       "lpr" 
```



[Rstudio doesnn't load Rprofile or Renviron](https://community.rstudio.com/t/rstudio-doesnnt-load-rprofile-or-renviron/57721)

I store my `Rprofile` and `Renviron` in non-default places (i.e. `~/.config/R`). When opening `R` in a normal shell, my environment is loaded perfectly fine. When opening Rstudio, it doesn't load my options, settings or paths.

- Have to <span style='color:#00CC66'>wrap your option settings in `rstudio.sessionInit`</span>

  https://damien-datasci-blog.netlify.app/post/2020-12-31-pimp-your-r-startup-message/

  - Open `.Rprofile` 

    ```R
    usethis::edit_r_profile()
    ```

  - wrap up your options in the following snippet

    ```R
    setHook("rstudio.sessionInit", function(newSession) {
      # any code included here will be run at the start of each RStudio session
      options(buildtools.check = function(action) TRUE )
    }, action = "append")
    ```

    

- Understanding R's startup

  https://rviews.rstudio.com/2017/04/19/r-for-enterprise-understanding-r-s-startup/
  
  <https://docs.posit.co/ide/user/ide/guide/environments/r/managing-r.html>



[`usethis`](https://usethis.r-lib.org/reference/index.html)  is a workflow package: it automates repetitive tasks that arise during project setup and development, both for R packages and non-package projects.



___

### `.Rprofile`

What is `.Rprofile`?

`.Rprofile` is a startup file to set <span style='color:#00CC66'><u>options</u> and <u>environment variables</u></span>. `.Rprofile` files can be either at the user or project level. 

- User-level `.Rprofile` files live in the base of the user's <span style='color:#00CC66'>home directory</span>, and 
- project-level `.Rprofile` files live in the base of the project directory. 

R will source only one `.Rprofile` file.  If there is a project-level `.Rprofile`, the user-level file will <span style='color:#FF9900'>NOT</span> be sourced, i.e., the project-level config file take priority.

So if you have both a project-specific `.Rprofile` file and a user `.Rprofile` file that you want to use, you explicitly source the user-level `.Rprofile` at the top of your project-level `.Rprofile` with `source("~/.Rprofile")`.

`.Rprofile` files are sourced as regular R code, so setting environment variables must be done inside a `Sys.setenv(key = "value")` call.

--------------------------------------------------------------------------------

Quitting R will erase the default theme setting. If you load `ggplot2` in a future session it will revert to the default gray theme. If you’d like for `ggplot2` to always use a different theme (either yours or one of the built-in ones), you can set a load hook and put it in your `.Rprofile` file. For example, the following hook sets the default theme to be `theme_minimal()` every time the `ggplot2` package is loaded.

```R
setHook(packageEvent("ggplot2", "onLoad"), 
        function(...) ggplot2::theme_set(ggplot2::theme_bw()))
```

Of course, you can always override this default theme by adding a theme object to any of your plots that you construct in `ggplot2`.



--------------------------------------------------------------------------------

### `.Renviron`

`.Renviron` is a user-controllable file that can be used to create <span style='color:#00CC66'>environment variables</span>. This is especially useful to avoid including credentials like API keys inside R scripts. This file is written in a key-value format, so environment variables are created in the format:

```
Key1=value1
Key2=value2
...additional key=value pairs
```

And then `Sys.getenv("Key1")` will return `"value1"` in an R session.

Like with the `.Rprofile` file, `.Renviron` files can be at either the user or project level. If there is a project-level `.Renviron`, the user-level file will not be sourced. The [usethis](https://usethis.r-lib.org/) package includes a helper function for editing `.Renviron` files from an R session with `usethis::edit_r_environ()`.

The `.Renviron` file is most useful for defining sensitive information such as API keys (such as GitHub, Twitter, or Posit Connect) as well as R specific environment variables like the history size (`R_HISTSIZE=100000`) and default library locations `R_LIBS_USER`.



--------------------------------------------------------------------------------

[Rcpp compilation breaks in R 4.1.0](https://community.rstudio.com/t/rcpp-compilation-breaks-in-r-4-1-0-running-on-big-sur-11-4/109744)

```R
devtools::build("my_package")
Error: Could not find tools necessary to compile a package
Call `pkgbuild::check_build_tools(debug = TRUE)` to diagnose the problem.
```

- In RStudio, I am continually prompted to install additional build tools and I can't install the build tool. $\rightarrow$ Bypass the option `options(buildtools.check = function(action) TRUE)`.

- Turns out R was pointing to an old clang version in my Makevars. 

  I just deleted it using [in Terminal]

  ````bash
  sudo rm ~/.R/Makevars
  ````



**Install SDK command line tool**

Download from developer.apple.com. Software development kit.

https://developer.apple.com/download/all/



**R compiler tools for cpp on MacOS**

- https://thecoatlessprofessor.com/programming/cpp/r-compiler-tools-for-rcpp-on-macos/

- install OpenMP enabled `clang` from the terminal 

  https://rpubs.com/Kibalnikov/776164







