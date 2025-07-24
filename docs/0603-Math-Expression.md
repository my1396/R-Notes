## Math Expression in Figures

Main idea: to use expression or convert latex to expression;

Two options

1.   `expression(CO[2])` show math equation style as $CO_2$.
     https://www.dataanalytics.org.uk/axis-labels-in-r-plots-using-expression/#expression_comm

2.   `latex2exp::TeX("$\\alpha^\\beta$")`  show as $\alpha^{\beta}$;

Trick: use `\\,` or `\\;` to show white space in math mode. `\\;` is a larger space than `\\,`.


```r
# There is an R package called latex2exp which may be helpful. It has function TeX which accepts some LaTeX expressions enclosed with dollar sign $ as in this example:

library(latex2exp)
library(ggplot2)

qplot(1, "A")+
     ylab(TeX("Formula: $\\frac{2hc^2}{\\lambda^\\beta}$"))+
     xlab(TeX("$\\alpha$"))
```



<img src="https://drive.google.com/thumbnail?id=1R7I0KimEVf4i_JI1XW0oaxWAlSuqRLQC&sz=w1000" alt="Tex" style="zoom:75%;" />

`TeX` 	only put the part that needs <u>latex interpretation</u> between \$...$ , and there are several escape characters that needs to be carefully treated.

| Symbol | TeX  |
| ------ | ---- |
| `\`    | `\\` |
| `[`    | `\[` |
| `]`    | `\]` |

Check out other **escaping** characters:

https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/plotmath.html

`TeX` in <u>legend scales</u>, the use of `unname()` is necessary:

 ```R
# have to use unname(TeX("$...$"))
labels=c("CRU", unname( TeX("$Burke \\times 10$") ) ) 
 ```

When using `TeX` inside `geom_text(aes(x, y, label=TeX("", output = "character") ), parse=TRUE )`, 

-   specifying the output of `TeX()` as character, although "character" is not one of the values that the `output` argument can take, and 

-   turning the `parse` argument in `geom_text()` to TRUE. 



Using variables in `aes`

`aes_string(x="TCS_reported", y=as.name(target_v))`

-   `target_v` can be a variable which will be parsed in `aes`;

-   `as.name()` 	 first coerces its argument internally to a character vector; then takes the first element and returns a symbol of that name. 

    -   A `name` 	(also known as a ‘symbol’) is a way to refer to R objects by name (rather than the value of the object, if any, bound to that name).

    -   It will <span style='color:#008B45'>**escape special characters**</span> that are otherwise reserved or illegal; equivalent to `'target_v'`

```R
target_v <- "#Obs"
aes_string(x="TCS_reported", y=as.name(target_v))

# or equivalently replace `as.name()` with backticks ``
target_v <- "`#Obs`"
aes_string(x="TCS_reported", y=target_v)

# or using get()
aes(x=TCS_reported, y=get(target_v))
```

