## Quarto

Host Quarto on [GitHub Pages](https://quarto.org/docs/publishing/github-pages.html).

To get started, change your project configuration `_quarto.yml` to use `docs` as the `output-dir`.

```yml
project:
  type: website
  output-dir: docs
```

Then, add a `.nojekyll` file to the **root of your repository** that tells GitHub Pages not to do additional processing of your published site using Jekyll (the GitHub default site generation tool):

```
touch .nojekyll
```

- Note that `.nojekyll`'s location is different than that of `bookdown`, which is at `/docs` folder.


Benefits of Quarto:

- hoverable citations 
- [subplots](https://quarto.org/docs/authoring/cross-references.html#subfigures)

--------------------------------------------------------------------------------

Syntax differences with R markdown:

- Code chunks

    R markdown
    
    ~~~~markdown
    ```{r my-label, fig.cap = caption}
    
    # R code
    ```
    ~~~~
    
    Vs.
    
    Quarto
    
    ````markdown
    ```{r}
    #| label: fig-my-label
    #| fig-cap: caption 
    
    # R code
    ```
    ````

--------------------------------------------------------------------------------

### Cross References

1. **Add labels:**

   - **Code cell:** add option `label: prefix-LABEL`
   - **Markdown:** add attribute `#prefix-LABEL`

2. **Add references:** `@prefix-LABEL`, e.g.

   ```
   You can see in @fig-scatterplot, that...
   ```

| `prefix` | Renders    |
| -------- | ---------- |
| `fig-`   | Figure 1   |
| `tbl-`   | Table 1    |
| `eq-`    | Equation 1 |
| `sec-`   | Section 1  |


--------------------------------------------------------------------------------

#### Equations {.unnumbered}

```latex
$$
y_i = \beta_{i}'x + u_i.
$$ {#eq-cross_sectional_hetero}
```

- `@eq-cross_sectional_hetero` gives `Equation (1)` 
- `[-@eq-cross_sectional_hetero]` gives only the tag `(1)`



You can customize the appearance of inline references by either changing the syntax of the inline reference or by setting options. 

Here are the various ways to compose a cross-reference and their resulting output:

| Type          | Syntax                | Output   |
| ------------- | --------------------- | -------- |
| Default       | `@fig-elephant`       | Figure 1 |
| Capitalized   | `@Fig-elephant`       | Figure 1 |
| Custom Prefix | `[Fig @fig-elephant]` | Fig 1    |
| No Prefix     | `[-@fig-elephant]`    | 1        |

Note that the capitalized syntax makes no difference for the default output, but would indeed capitalize the first letter if the default prefix had been changed via an [option](https://quarto.org/docs/authoring/cross-reference-options.html#references) to use lower case (e.g. “fig.”).

Change the prefix in inline reference using `*-prefix` options. You can also specify whether references should be hyper-linked using the `ref-hyperlink` option. 

```markdown
---
title: "My Document"
crossref:
  fig-prefix: figure   # (default is "Figure")
  tbl-prefix: table    # (default is "Table")
  ref-hyperlink: false # (default is true)
---
```



___

### Equations

**Load MathJax Config**

Load `mathjax.html` in YAML

```markdown
---
title: "Model specifications"
author: "GDP and climate"
date: "2025-05-13"
from: markdown+tex_math_single_backslash
format: 
  html:
    toc: true
    self-contained: true
    html-math-method: mathjax
    include-in-header: mathjax.html
---
```

In `mathjax.html`

```html
<script>
MathJax = { 
    tex: { 
        tags: 'ams',  // should be 'ams', 'none', or 'all' 
        macros: {  // define TeX macro
            RR: "{\\bf R}",
            bold: ["{\\bf #1}", 1]
        },
  	},
};
</script>
```

`tags: 'ams'`  allows equation numbering



___

**Math delimiters**

Issue: Cannot use `\(` and `\[` for math delimiters. \
Fix: Add `from: markdown+tex_math_single_backslash` to YAML frontmatter. [Source](https://github.com/quarto-dev/quarto-cli/discussions/11753#discussioncomment-11696142)

```markdown
---
title: "Quarto Playground"
from: markdown+tex_math_single_backslash
format:
  html:
    html-math-method: mathjax
---

Inline math example: \( E = mc^2 \)

Block math example:

\[
a^2 + b^2 = c^2
\]
```

`form`: Format to read from. Extensions can be individually enabled or disabled by appending +EXTENSION or -EXTENSION to the format name (e.g. `markdown+emoji`).

Extension: `tex_math_single_backslash`

Causes anything between `\(` and `\)` to be interpreted as inline TeX math, and anything between `\[` and `\]` to be interpreted as display TeX math. Note: a drawback of this extension is that it precludes escaping `(` and `[`.



Refer to Docs of Quarto and Pandoc:

- [https://quarto.org/docs/reference/formats/html.html#rendering](https://quarto.org/docs/reference/formats/html.html#rendering)

- [https://pandoc.org/MANUAL.html#extension-tex_math_single_backslash](https://pandoc.org/MANUAL.html#extension-tex_math_single_backslash)

- [https://pandoc.org/MANUAL.html#extension-tex_math_double_backslash](https://pandoc.org/MANUAL.html#extension-tex_math_double_backslash)



___

Q: How to get rid of the `qmd` dependence file?  
A: Use 

```css
format: 
  html:
    self-contained: true
```


--------------------------------------------------------------------------------

### Theorems 

```
::: {#thm-line}
The equation of any straight line, called a linear equation, can be written as:

$$
y = mx + b
$$
:::

See @thm-line.
```


In Quarto, `#thm-line` is a combined command us `.theorem #thm-line` in bookdown. In bookdown, the label can be anything, does not have to begin with `#thm-`. But in Quarto, `#thm-line` is restrictive, it indicates the `thm` environment and followed by the label of the theorem `line`.

::: {.theorem #thm-line}
The equation of any straight line, called a linear equation, can be written as:

$$
y = mx + b
$$
:::

See Theorem \@ref(thm:thm-line).

--------------------------------------------------------------------------------

```markdown
::: {#thm-topo name="Topology Space"}
A topological space $(X, \Tcal)$ is a set $X$ and a collection $\Tcal \subset \Pcal(X)$ of subsets of $X,$ called open sets, such that ...
:::

See Theorem @thm-topo.
```



::: {.theorem #thm-topo name="Topology Space"}
A topological space $(X, \Tcal)$ is a set $X$ and a collection $\Tcal \subset \Pcal(X)$ of subsets of $X,$ called open sets, such that ...
::: 


See Theorem \@ref(thm:thm-topo).


--------------------------------------------------------------------------------

**References**:

- <https://www.njtierney.com/post/2022/04/11/rmd-to-qmd/>
- Cheatsheet: <https://rstudio.github.io/cheatsheets/html/quarto.html>
- Citations: <https://quarto.org/docs/authoring/citations.html>
- Theorems: <https://quarto.org/docs/authoring/cross-references.html#theorems-and-proofs>







