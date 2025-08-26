## Pipe Operator

**dplyr** works well with the [‘pipe’](http://r4ds.had.co.nz/pipes.html) operator `%>%`. 

The default behavior of `%>%` when multiple arguments are required in the `rhs` call, is to place `lhs` as the first argument, i.e. `x %>% f(y)` is equivalent to `f(x, y)`.

dot (`.`) works as **placeholder** in `%>%` 

- if you want `lhs` to the `rhs` call at another position than the first.
- if you want to use the variable more than once.

For example, `y %>% f(x, .)` is equivalent to `f(x, y)` and `z %>% f(x, y, arg = .)` is equivalent to `f(x, y, arg = z)`.

The output of a previous function becomes the **first argument** of the next function, enabling *chaining*. This is illustrated below, in which only countries from Asia are filtered from the `world` dataset, next the object is subset by columns (`name_long` and `continent`) and the first five rows (result not shown).

```r
world7 = world %>%
  filter(continent == "Asia") %>%
  dplyr::select(name_long, continent) %>%
  slice(1:5)
```

- Use the dot for secondary purposes, i.e. you want to use the <span class="env-green">attributes of `x`</span> rather than `x` itself. `iris %>% subset(1:nrow(.) %% 2 == 0)` is equivalent to `iris %>% subset(., 1:nrow(.) %% 2 == 0)`

- In order to avoid plugiging in as the first argument and to call the parameter <span class="env-green">**several times**</span>, surround the `rhs` call with brace brackets `{...}`.

  `1:10 %>% {c(min(.), max(.))}` is equivalent to `c(min(1:10), max(1:10))`

```r
10 %>% { seq(from = .-5, to = .+5) }
## [1]  5  6  7  8  9 10 11 12 13 14 15

all_df %>% 
    group_by(date) %>% 
    group_map(~{
        .x %>% 
            drop_na() %>% 
            {crossprod(.[,1003] %>% as.matrix(), .[,3:1002] %>% as.matrix())}
    }, .keep=TRUE)
```

- `%>%` has higher precedence than arithmetic operations.

```r
matrix(c(1,0,0,1), nrow = 2) * 5 %>% as.data.frame()
# same as 
matrix(c(1,0,0,1), nrow = 2) * (5 %>% as.data.frame())
# need to wrap the matrix multiplication before pipe
(matrix(c(1,0,0,1), nrow = 2)*5 ) %>% as.data.frame
# V1 V2
# 1  5  0
# 2  0  5
```

- `%>%` can work together with <span class="env-green">backticks</span> for arithmetic operators

```r
x <- 2
x %>% `+`(2)
# [1] 4
```

- `%>%` can use with `!` enclosed in backticks

```r
> c(TRUE, FALSE) %>% `!`
[1] FALSE  TRUE
> c(TRUE, FALSE) %>% magrittr::not()
[1] FALSE  TRUE
> c(NA,5) %>% Negate(is.na)()
[1] FALSE  TRUE
```

It is handy to use `Aliases` in `magrittr` package, e.g.:

```r
extract `[`
extract2    `[[`
inset   `[<-`
inset2  `[[<-`
use_series  `$`
add `+`
subtract    `-`
multiply_by `*`
raise_to_power  `^`
multiply_by_matrix  `%*%`
divide_by   `/`
divide_by_int   `%/%`
mod `%%`
is_in   `%in%`
and `&`
or  `|`
equals  `==`
is_greater_than `>`
is_weakly_greater_than  `>=`
is_less_than    `<`
is_weakly_less_than `<=`
not (`n'est pas`)   `!`
set_colnames    `colnames<-`
set_rownames    `rownames<-`
set_names   `names<-`
set_class   `class<-`
set_attributes  `attributes<-`
set_attr    `attr<-`
```



- Use `{}` to specify the precedence, so that they are evaluated the way you want.

```r
# calculate the mean and sd for a vector
rnorm(100) %>% c(mean(.), sd(.)) # this does not work as the way you want
rnorm(100) %>% {c(mean(.), sd(.))} # this works well after enclosing the operation with {}
```



### Native Pipe `|>`

The native pipe was introduced to R in 4.1.0.

It is suggested to use the native piple in Tidyverse Style Guide.

❗️BUT **Caveats** using the new native pipe:

- Code using `|>` in function reference examples or vignettes will not work on older versions of R, as it is not valid syntax. 

There are advanced features of `%>%` which not supported by `|>`:

- `%>%` allows you to change the placement with a `.` placeholder. 

  R 4.2.0 added a `_` placeholder to the base pipe, with one additional restriction: the argument has to be named. For example, `x |> f(1, y = _)` is equivalent to `f(1, y = x)`.

- The `|>` placeholder is deliberately simple and can’t replicate many features of the `%>%` placeholder: you can’t pass it to multiple arguments, and it doesn’t have any special behavior when the placeholder is used inside another function. For example, `df %>% split(.$var)` is equivalent to `split(df, df$var)`, and `df %>% {split(.$x, .$y)}` is equivalent to `split(df$x, df$y)`.

- `%>%` allows you to drop the parentheses when calling a function with no other arguments; `|>`always requires the parentheses.

- `%>%` allows you to start a pipe with `.` to create a function rather than immediately executing the pipe; this is not supported by the base pipe.

