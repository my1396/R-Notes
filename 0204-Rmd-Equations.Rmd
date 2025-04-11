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













