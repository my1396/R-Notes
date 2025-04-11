## Cross References

- Using `bookdown` 

  You can provide a number for an equation by adding `\begin{equation}` along with a label, provided with `(\#eq:label)`. 

  - Note that `\begin{equation}` must be quoted in `$$...$$`.

  - You can then refer to the equation in text using `\@ref(eq:CJ)`. Need to put the label in parentheses `()`.

    `\@ref(type:label)`  where `type` is the environment being referenced, and  `label` is the chunk label.

  ```latex
  This is an equation redered using bookdown
  
  $$
  \begin{equation} (\#eq:CJ)
  y=\beta_0 + \beta_1x + e_t
  \end{equation}
  $$
  ```

  $$
  \begin{equation*} (\#eq:CJ)
  y=\beta_0 + \beta_1x + e_t
  \end{equation*}
  $$

  Cite as follows: eqn \@ref(eq:CJ).

  ```latex
  Multilined equations.
  
  $$
  \begin{equation} 
  \begin{aligned}
  y_i &= f(x_{1i}, x_{2i}, \ldots, x_{Ki}) + \varepsilon_i \\
  &= x_{1i} \beta_1 + x_{2i} \beta_2 + \cdots + x_{Ki} \beta_K + \varepsilon_i
  \end{aligned}(\#eq:scalar-form)
  \end{equation}
  $$
  ```

  Cite as eqn \@ref(eq:scalar-form).

  

  Some examples:

  - Headers:

    ```latex
    # Introduction {#intro}
    
    This is Chapter \@ref(intro)
    ```

  - Figures:

    ~~~latex
    See Figure \@ref(fig:cars-plot)
    
    
    ```r
    plot(cars)  # a scatterplot
    ```
    
    ![(\#fig:cars-plot)A plot caption](0202-Rmd-Cross-Reference_files/figure-latex/cars-plot-1.pdf) 
    ~~~

  - Tables:

    ~~~latex
    See Table \@ref(tab:mtcars)
    
    
    ```r
    knitr::kable(mtcars[1:5, 1:5], caption = "A caption")
    ```
    
    \begin{table}
    
    \caption{(\#tab:mtcars)A caption}
    \centering
    \begin{tabular}[t]{l|r|r|r|r|r}
    \hline
      & mpg & cyl & disp & hp & drat\\
    \hline
    Mazda RX4 & 21.0 & 6 & 160 & 110 & 3.90\\
    \hline
    Mazda RX4 Wag & 21.0 & 6 & 160 & 110 & 3.90\\
    \hline
    Datsun 710 & 22.8 & 4 & 108 & 93 & 3.85\\
    \hline
    Hornet 4 Drive & 21.4 & 6 & 258 & 110 & 3.08\\
    \hline
    Hornet Sportabout & 18.7 & 8 & 360 & 175 & 3.15\\
    \hline
    \end{tabular}
    \end{table}
    ~~~

  - Theorems:

    ~~~latex
    See Theorem \@ref(thm:boring)
    
    ::: {.theorem #boring}
    Here is my theorem.
    :::
    ~~~

  - Equations:

    ```latex
    See equation \@ref(eq:linear)
    
    \begin{equation}
    a + bx = c  (\#eq:linear)
    \end{equation}
    ```

- The **LaTeX** way allows you to assign your own labels by `\tag`.  One drawback is that this does not allow preview of equations.

  1. Add the following script at the beginning of your document body:

     ```html
     <script type="text/x-mathjax-config">
     MathJax.Hub.Config({
       TeX: { equationNumbers: { autoNumber: "AMS" } }
     });
     </script>
     ```

     It configures MathJax to automatically number equations. [Source](https://stackoverflow.com/a/55163121/10108921).

  2. In the text, use `label{eq:label}`. If you want to provide a specific number to the equation, you can use `\tag{XX.XX}`. 

     - Note that `\begin{equation}` is <span style='color:#00CC66'>NOT</span> inside `$$ ...$$`!
     - If `\begin{equation}` is inside `$$`, it will still compile, but not correctly labeled ang tagged.

  3. Cite using `$\ref{eq:label}$` (no parenthesis) or `$\eqref{eq:label}$` (with parenthesis). The dollar sign `$` here around `\ref` and `\eqref` is not essential. Commands work with or without `$`.

  ```latex
  Without using the bookdown package.
  
  \begin{equation} \label{eq:test} \tag{my label}
    Y_i = \beta_0 + \beta_1 x_i + \epsilon_i
  \end{equation}
  
  Cite Equation $\eqref{eq:test}$ like this.
  ```

  
