## Equations

Can use `$...$` (`$$...$$` for blocks) or `\(...\)` (`\[...\]` for blocks) to enclose equations. Difference:

- `$...$` provides rendered equation previews in RStudio.
- `\(...\)` does not have previews.



Rstudio equation previews do NOT work well with indented equations. $\rightarrow$ reduce indentation 

如果公式缩进，Rstudio 公式预览功能可能不识别。在不影响理解的前提下，减少不必要的缩进以便预览公式。



**Multi-case** functions using `\begin{cases}`

```markdown
\begin{align*}
I_t = 
\begin{cases}
1 & \text{if } r_t>0 \\
0 & \text{if } r_t\leq0
\end{cases}
\end{align*}
```

will render as

\begin{align*}
I_t = 
\begin{cases}
1 & \text{if } r_t>0 \\
0 & \text{if } r_t\leq0
\end{cases}
\end{align*}


For equation numbering support in `bookdown` you need to [assign labels](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#equations). 


--------------------------------------------------------------------------------

You may refer to an equation using Eq. `\@ref(eq:eq01)`.

```latex
\begin{align} (\#eq:eq01)
\frac{p(x)}{1-p(x)} = \exp (\beta_0+\beta_1 x) \,.
\end{align}
```

If you want to provide a specific number to the equation, you can use `\tag{XX.XX}`.

- With LaTeX
    
  LaTex allows custom labels.
    
  \begin{align} \label{eq:my-label-latex} \tag{my label latex}
  \frac{p(x)}{1-p(x)} = \exp (\beta_0+\beta_1 x) \,.
  \end{align}

  My specific label here, see eq \eqref{eq:my-label-latex} (`\eqref{eq:my-label-latex}`).


--------------------------------------------------------------------------------

- With `bookdown`
    
  `bookdown` does NOT support custom tag though.
    
  \begin{align}
  \frac{p(x)}{1-p(x)} = \exp (\beta_0+\beta_1 x) \,.
  (\#eq:my-label-bookdown)
  \end{align}
  
  My specific label here, see eq \@ref(eq:my-label-bookdown)

--------------------------------------------------------------------------------


**Color eqns** using `\color{#00CC66}{...}`. 

But sometime everything follows gets colored. You may want to use `{\color{#00CC66} ... }` instead.

```latex
$$
\color{#008B45}{Y_t} = I_tI_{t-1} + (1-I_t)(1-I_{t-1})
$$
```

\begin{align*}
{\color{red}Y_t} = I_tI_{t-1} + (1-I_t)(1-I_{t-1})
\end{align*}

- This only works for color names, not hex codes starting with `#`, because html requires the `#` followed by 6 characters to define a color, but LaTeX package `xcolor` specifically excludes `#` in color specifications.

- Here is an \textcolor[HTML]{00CC66}{inline colored example for LaTeX output} (only works for LaTeX).


**A workaround**: We can write a custom R function to insert the correct syntax depending on the output format using the `is_latex_output()` and `is_html_output()` functions in knitr as follows:


```r
colorize <- function(x, color) {
  if (knitr::is_latex_output()) {
    sprintf("\\textcolor{%s}{%s}", color, x)
  } else if (knitr::is_html_output()) {
    sprintf("<span style='color: %s;'>%s</span>", color,
      x)
  } else x
}
```
    
    
We can then use the code in an inline R expression `` `r colorize("some words in red", "red")` ``, which will create <span style='color: red;'>some words in red</span>, which works for both html and .


--------------------------------------------------------------------------------


### Mathjax {.unlisted .unnumbered}

<https://bookdown.org/yihui/rmarkdown/html-document.html#mathjax-equations>

Default configuration used by the rmarkdown package is given by `rmarkdown:::mathjax_config()`. As of rmarkdown v2.1, the function returns "MathJax.js?config=TeX-AMS-MML_HTMLorMML". This configures `Mathjax` to `HTML-CSS`.

Change `Mathjax` configuration to `CommonHTML` using the following codes.

```markdown
---
title: "Trouble with MathJax"
output: 
  html_document:
    mathjax: "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-AMS_CHTML.js"
    self_contained: false    
---
```

By default, [MathJax](https://www.mathjax.org/) scripts are included in HTML documents for rendering LaTeX and MathML equations. You can use the `mathjax` option to control how MathJax is included:

- Specify `"default"` to use an HTTPS URL from a CDN host (currently provided by RStudio).
- Specify `"local"` to use a local version of MathJax (which is copied into the output directory). Note that when using `"local"` you also need to set the `self_contained` option to `false`.
- Specify an alternate URL to load MathJax from another location. To use a self-hosted copy of MathJax.
- Specify `null` to exclude MathJax entirely.


--------------------------------------------------------------------------------

Q: Why my eqns are not rendered?

A: MathJax is unlikely to work offline. Check internet connection.



You load [MathJax](https://docs.mathjax.org/en/stable/configuration.html) into a web page by including its main JavaScript file into the page. That is done via a `<script>`tag that links to the `MathJax.js` file. To do that, place the following line in the `<head>` section of your document.

 For example, if you are using the MathJax distributed network service, the tag might be

```html
<script type="text/javascript"
   src="http://cdn.mathjax.org/mathjax/latest/MathJax.js">
</script>
```



MathJax is available as a web service from `cdn.mathjax.org`, so you can obtain MathJax from there without needing to install it on your own server. The CDN is part of a distributed “cloud” network, so it is handled by servers around the world. That means that you should get access to a server geographically near you, for a fast, reliable connection.

The CDN hosts the most current version of MathJax, as well as older versions, so you can either link to a version that stays up-to-date as MathJax is improved, or you can stay with one of the release versions so that your pages always use the same version of MathJax.



--------------------------------------------------------------------------------

For equation numbering support in `bookdown::pdf_document2` you need to [assign labels](https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#equations). Defualt behavior is not adding numbering.

- Use `\begin{equation}...\end{equations}` or `\begin{align}...\end{align}` environments.

  - Use `(\#eq:eq1)` or `\label{eq:eq1}` to add labels.
  - Automatically add numbering.
  - Drawback is that rmd does not have preview of equations.

- Do NOT enclose the environments in double dollar signs `$$`. Otherwise, no label is added, but cross-references still show up.

  - `$$` do not add numbering automatically. 

  - But in `bookdown::html_document2`, it is ok to use 

    ```latex
    $$
    \begin{equation} (\#eq:simple-lm)
    \hat{\beta}_{\text{OLS}} = \left(\sum_{i=1}^n x_i x_i' \right)^{-1} \left(\sum_{i=1}^n x_i y_i \right) .
    \end{equation}
    $$
    ```

    Then reference with `\@ref(eq:simple-lm)`.

- Use `\@ref(eq:eq1)` (note this use parentheses) or the Latex command  `\eqref{eq:eq1}` (this uses curly braces) to cite the equation.

```latex
Load the dataset and calculate the monthly return in month $r$ ($r_t$) as

\begin{equation}
r_t = \frac{P_t-P_{t-1}}{P_{t-1}} = \frac{P_t}{P_{t-1}}-1 , 
(\#eq:eq1)
\end{equation}

where $P_t$ is the adjusted price in month $t$. 

Test equation1 \@ref(eq:eq1).

Test equation2 \eqref{eq:eq1}.
```



<img src="https://drive.google.com/thumbnail?id=1mgX3uwLgTDHF0cMwn04mj9K4GjTOF4TX&sz=w1000" alt="eqn numbering in bookdown" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />











