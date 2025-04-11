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


Commonly used global options:

| Option        | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| width         | Controls the maximum number of columns <u>on a line</u> used in printing vectors, matrices and arrays, and when filling by `cat`. Defaults to 80.<br />Don't change this if you want to print more columns. Use <span style='color:#00CC66'>`options(tibble.width=400)`</span> instead. |
| pillar.sigfig | Tibbles print numbers with three significant digits by default, switching to scientific notation if the available space is too small.<br />`options(pillar.sigfig = 4)` to increase the number of digits printed out |







