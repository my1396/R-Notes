

## Cross References

### Using `bookdown` 

You can number and refer to an equation by adding `\begin{equation}` along with a label, provided with `(\#eq:label)`. 

- <span style='color:#00CC66'>The position of the eqn label matters</span>. 
    - For single-lined equations: First write your equation, then append your label `(\#eq:label)`. Otherwise, your equation won't be rendered.
    - For multi-lined equations: append `(\#eq:label)` after `\end{split}`, `\end{aligned}` ...

- Note that `\begin{equation}` must <span style='color:#FF9900'>NOT be quoted in `$$...$$`</span> for the equation to be rendered. 

    Otherwise, will cause "Bad math delimiter" error at the time of tex compilation for pdf output. Might be alright for html output though.
    
    Unexpected consequence: Without the `$$...$$`, RStudio won't provide previews for equations.
    
    - For temporary preview in RStudio at the composing stage, you can enclose the whole math environment in `$$...$$`. But **remember to delete them when you are done** editing the equation.
    - See [this post by Kenji Sato](https://www.kenjisato.jp/en/post/2017/02/cross-referenceable-equation-with-preview-in-rmarkdown/) for a more efficient workaround.
    
- You can then refer to the equation in text using `\@ref(eq:CJ)`. Remember to put the label in parentheses `()`.

    General syntax for other environments: `\@ref(type:label)`  where `type` is the environment being referenced, and  `label` is the chunk label.

    | Element         | ID$^{[1]}$                                   | How to cite$^{[4]}$ |
    | --------------- | -------------------------------------------- | ------------------- |
    | Figure$^{[2]}$  | `any-id`                                     | `\@ref(fig:any-id)` |
    | Table           | `any-id`                                     | `\@ref(tab:any-id)` |
    | Equation        | `any-id`                                     | `\@ref(eq:any-id)`  |
    | Section$^{[3]}$ | add `{#any-id}` to the end of section header | `\@ref(any-id)`     |

    $^{[1]}$ For figures, tables, and equations, you can assign any ID you like. No type is needed. When you render your file, labels will be <span class="env-green">automatically prefixed</span> with `fig:`, `tab:`, or `eq:` respectively.

    $^{[2]}$ **A caption to your figure (or table) must be specified**: Figures without a caption will be included directly as images and will therefore not be a numbered figure.
    
    $^{[3]}$ For [sections](https://bookdown.org/yihui/bookdown/cross-references.html), you need to add `{#any-id}` (note the `#`) to the end of section header.
    
    $^{[4]}$ Do not forget the leading backslash `\`! And also note the parentheses `()` after `ref`; they are NOT curly braces `{}`, which is used in LaTeX cross-reference syntax.

```latex
This is an equation redered using bookdown

\begin{equation} (\#eq:CJ)
y=\beta_0 + \beta_1x + e_t
\end{equation}
```

will render as

\begin{equation} 
y=\beta_0 + \beta_1x + e_t
(\#eq:CJ)
\end{equation}

You may refer to it using `eqn \@ref(eq:CJ)`, e.g., see eqn \@ref(eq:CJ).

--------------------------------------------------------------------------------

```latex
Multilined equations.
  
\begin{equation} 
\begin{aligned}
y_i &= f(x_{1i}, x_{2i}, \ldots, x_{Ki}) + \varepsilon_i \\
&= x_{1i} \beta_1 + x_{2i} \beta_2 + \cdots + x_{Ki} \beta_K + \varepsilon_i
\end{aligned}(\#eq:scalar-form)
\end{equation}
```

will render as


\begin{equation} 
\begin{aligned}
y_i &= f(x_{1i}, x_{2i}, \ldots, x_{Ki}) + \varepsilon_i \\
&= x_{1i} \beta_1 + x_{2i} \beta_2 + \cdots + x_{Ki} \beta_K + \varepsilon_i
\end{aligned}(\#eq:scalar-form)
\end{equation}

You may refer to it using `eqn \@ref(eq:scalar-form)`, e.g., see eqn \@ref(eq:scalar-form) .



Note that

- For HTML output, **bookdown** can only number the equations with labels. 

  Please make sure equations without labels are not numbered by either using the `equation*` environment or adding `\nonumber` or `\notag` to your equations. 



--------------------------------------------------------------------------------

**Troubleshooting**

Issue: [Bad math environment delimiter on conversion to pdf when using equation or align](https://github.com/jupyter/nbconvert/issues/232).

Cause: The error happens because I enclosed `\begin{equation}` environment in `$$`. I did this as the dollar sings enable equation rendering and preview in file.

Fix: remove the double signs.

```latex
The following equation causes error. Need to remove the dollar signs.
$$
\begin{equation}
y=x+2
\end{equation}
$$
```



--------------------------------------------------------------------------------




#### Headers {-}

```latex
# Introduction {#intro}

This is Chapter \@ref(intro)
```
The above is the [bookdown syntax](https://bookdown.org/yihui/bookdown/cross-references.html) for cross-referencing headers. `\@ref(intro)` creates a link to the **header numbering** with the ID `intro`.

Sometimes you want to create a **text-based link**.  
You can use the markdown syntax `[link text][#ID]`. It will create a link to `link text` that points to the header with ID `ID`.
Refer to [Markdown: cross references](https://my1396.github.io/Econ-Study/2023/10/04/Markdown.html#cross-references) for more examples.

Note that **cross references between documents** are supported by bookdown. Don't need to specify the file name, just use the ID of the header in the other document. Bookdown will automatically link to the correct document.

**More about Section IDs:**

By default, Pandoc will generate an ID for all section headers, e.g., a section `# Hello World` will have an ID `hello-world`. However, we recommend you to **manually assign an ID** to a section header to make sure you do not forget to update the reference label after you change the section header. To assign an ID to a section header, simply add `{#id}` to the end of the section header. Further attributes of section headers can be set using standard [Pandoc syntax](http://pandoc.org/MANUAL.html#heading-identifiers).


#### Figures {-}

We can make cross-references within the text using the syntax `\@ref(type:label)`, where `label` is the chunk label and `type` is the environment being referenced (e.g. `tab`, `fig`, or `eq`).

- <span class="env-green">**No space**</span> between `type:` and `label`.

~~~latex
See Figure \@ref(fig:cars-plot)

```{r cars-plot, fig.cap="A plot caption"}
plot(cars)  # a scatterplot
```
~~~

#### Tables {-}

~~~latex
See Table \@ref(tab:mtcars)

```{r mtcars}
knitr::kable(mtcars[1:5, 1:5], caption = "A caption")
```
~~~

#### Theorems {-}

~~~latex
See Theorem \@ref(thm:boring)

```{theorem, boring}
Here is my theorem.
```
~~~

#### Equations {-}

```latex
See equation \@ref(eq:linear)

\begin{equation}
a + bx = c  (\#eq:linear)
\end{equation}
```



--------------------------------------------------------------------------------



### Using the LaTeX Way

The **LaTeX** way allows you to assign your own labels by `\tag`.  One drawback is that this does not allow preview of equations.

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

  3. Cite using `$\ref{eq:label}$` (no parenthesis) or `$\eqref{eq:label}$` (with parenthesis). The dollar sign `$` here around `\ref` and `\eqref` is not essential. Commands work with or without `$`.

     ```latex
     Without using the bookdown package.
     
     \begin{equation} \label{eq:test} \tag{my custom label}
       Y_i = \beta_0 + \beta_1 x_i + \epsilon_i
     \end{equation}
     
     Cite Equation $\eqref{eq:test}$ like this.
     ```

     \begin{equation} \label{eq:test} \tag{my label}
     Y_i = \beta_0 + \beta_1 x_i + \epsilon_i
     \end{equation}
     
     Refer to the eq \eqref{eq:test}





--------------------------------------------------------------------------------


**Reference**:

<https://bookdown.org/yihui/bookdown/markdown-extensions-by-bookdown.html#equations>

