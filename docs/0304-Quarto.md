## Quarto

Quarto Guide: <https://quarto.org/docs/guide/>

Quarto Tutorial: <https://jmjung.quarto.pub/m02-advanced-literate-programming/#learning-outcomes>

Host Quarto on [GitHub Pages](https://quarto.org/docs/publishing/github-pages.html).

To get started, change your project configuration `_quarto.yml` to use `docs` as the `output-dir`.

```yaml
project:
  type: book
  output-dir: docs
```

Then, add a `.nojekyll` file to the **root of your repository** that tells GitHub Pages not to do additional processing of your published site using Jekyll (the GitHub default site generation tool):

```bash
touch .nojekyll
```

- Note that `.nojekyll`'s location is different than that of `bookdown`, which is at `/docs` folder.


Strengths of Quarto:

- hoverable citations and cross-references, easy to read 
- [easy subplots](https://quarto.org/docs/authoring/cross-references.html#subfigures)


Weakness of Quarto:

- slow compared to `Bookdown`
- issues when you want to compile one single page within a package. Changes are not realized in time unless render the whole website. 

    Workaround: Need to exclude from project index, and need file header `yaml` to import mathjax settings and themes.
    
    `Bookdown` is reliable. Don't need `yaml` in single `Rmd`, website theme will apply automatically. 

--------------------------------------------------------------------------------




### Book Structure

```yaml
book:
  chapters:
    - index.qmd
    - preface.qmd
    - part: dice.qmd
      chapters: 
        - basics.qmd
        - packages.qmd
    - part: cards.qmd
      chapters:
        - objects.qmd
        - notation.qmd
        - modifying.qmd
        - environments.qmd
    - references.qmd
  appendices:
    - tools.qmd
    - resources.qmd
```

- The `index.qmd` file is required (because Quarto books also produce a website in HTML format). This page should include the preface, acknowledgements, etc.

- The remainder of `chapters` includes one or more book chapters.

  You can divide your book into parts using `part` within the book `chapters`. 

  Note that the markdown files `dice.qmd` and `cards.qmd` contain the part title (as a level one heading) as well as some introductory content for the part. 

  If you just need a part title then you can alternatively use this syntax:

  ```yaml
  book:
    chapters:
      - index.qmd
      - preface.qmd
      - part: "Dice"
        chapters: 
          - basics.qmd
          - packages.qmd
  ```

- The `references.qmd` file will include the generated bibliography (see [References](https://quarto.org/docs/books/book-structure.html#references) below for details).



___

**Syntax differences with R markdown:**

- Code chunks

    Both R markdown and Quarto can use the following ways to specify chunk options:
    
    Use `tag=value` in the chunk header ```` ```{r} ````.
    
    ~~~~markdown
    ```{r my-label, fig.cap = caption}
    
    # R code
    ```
    ~~~~
    
    
    Alternatively, you can write chunk options in the body of a code chunk after `#|`, e.g., 
    
    
    ````markdown
    ```{r}
    #| label: fig-my-label
    #| fig-cap: caption 
    
    # R code
    ```
    ````
    
    `tag: value` is the YAML syntax. Logical values in YAML can be any of: `true/false`, `yes/no`, and `on/off`. They all equivalent to `TRUE/FALSE` (uppercase) in R.
    
    
    Options format:
    
    - space after `#|` and colon `:`
    - TRUE/FALSE need to be in uppercase
    
    Note that <span style='color:#008B45'>Quarto accepts Rmd's way of specifying chunk options</span>. The **difference** is that <span style='color:#008B45'>Quarto's label for figures</span> must start with `fig-`, while Rmd accepts any labels.
    
    ````markdown
    ```{r label = "fig-my-label", fig.cap = caption}
    
    # R code
    ```
    ````
    
--------------------------------------------------------------------------------

### HTML Theming

One simple theme

```yaml
title: "My Document"
format:
  html: 
    theme: cosmo
    fontsize: 1.1em
    linestretch: 1.7
```

Enable **dark and light** modes

```yaml
format:
  html:
    include-in-header: themes/mathjax.html
    respect-user-color-scheme: true
    theme:
      dark: [cosmo, themes/cosmo-dark.scss]
      light: [cosmo, themes/cosmo-light.scss]
```



--------------------------------------------------------------------------------

`respect-user-color-scheme: true`  honors the user’s operating system or browser preference for light or dark mode.

Otherwise, <u>the order of light and dark elements</u> in the theme or brand will determine the <u>default</u> appearance for your html output. For example, since the `dark` option appears first in the first example, a reader will see the light appearance by default, if `respect-user-color-scheme` is not enabled.

As of Quarto 1.7, `respect-user-color-scheme` requires JavaScript support: users with JavaScript disabled will see the author-preferred (first) brand or theme.

--------------------------------------------------------------------------------


#### Custom Themes {-}

Your `custom.scss` file might look something like this:

```css
/*-- scss:defaults --*/
$h2-font-size:          1.6rem !default;
$headings-font-weight:  500 !default;

/*-- scss:rules --*/
h1, h2, h3, h4, h5, h6 {
  text-shadow: -1px -1px 0 rgba(0, 0, 0, .3);
}
```

Note that the variables section is denoted by

- `/*-- scss:defaults --*/`: the defaults section (where Sass variables go) 
  
  Used to define global variables that can be used throughout the theme.

- `/*-- scss:rules --*/`: the rules section (where normal CSS rules go)
  
  Used to define more fine grained behavior of the theme, such as specific styles for headings, paragraphs, and other elements.


--------------------------------------------------------------------------------


#### Theme Options {-}

You can do extensive customization of themes using [Sass variables](https://sass-lang.com/). Bootstrap defines over 1,400 Sass variables that control fonts, colors, padding, borders, and much more. 

The Sass Variables can be specified within SCSS files. These variables should always be prefixed with a `$` and are specified within theme files rather than within YAML options

[Commonly used Sass variables](https://jmjung.quarto.pub/m02-advanced-literate-programming/#sass-variables):

| Category   | Variable        | Description                                                  |
|:-----------|:----------------|:-------------------------------------------------------------|
| **Colors** | `$body-bg`      | The page background color.                                   |
|            | `$body-color`   | The page text color.                                         |
|            | `$link-color`   | The link color.                                              |
|            | `$input-bg`     | The background color for HTML inputs.                       |
|            | `$popover-bg`   | The background color for popovers (for example, when a citation preview is shown). |






You can see all of the variables here:

https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss

Note that when you make changes to your local `.scss`, the changes will be implemented in-time. That is, you don't need to re-build your website to see the effects.



Ref: 

- Quarto document: <https://quarto.org/docs/output-formats/html-themes.html>

- Check sass variables: <https://bootswatch.com>

--------------------------------------------------------------------------------

### Render Quarto


Rendering the whole website is slow. When you are editing a new section/page, you may want to edit as a standalone webpage and when you are finished, you add the `qmd` file to the `_quarto.yml` file index.

Difference btw a standalone webpage from a component of a `qmd` project

- Standalone webpage: include `yaml` at the header of the file.
  
    Fast compile and rendering. ✅
    
- A component of `qmd` project: added to the file index, no `yaml` needed, format will automatically apply.

    Slow, need to render the whole `qmd` project in order to see your change.





#### In terminal {-}

- Render a Quarto document to HTML using the command line:

  ```bash
  $quarto render 0304-Quarto.Rmd --to html
  ```

- Quarto Preview: display output in a web browser.

  ```bash
  quarto preview 0304-Quarto.Rmd
  ```

  Note that `quarto render` can be used to Rmd files too. 

- You can also render a Quarto project using:

  ```bash
  $quarto render --to html
  ```

#### In VS Code {-}

You can render a Quarto document in VS Code using the command palette:

- `Quarto: Render Document` to render the document.
- `Quarto: Render Project` to render the entire project.
- `Quarto: Preview` to preview the default document in a web browser. If you want to preview a different format, use the `Quarto: Preview Format` command:

```bash
$ quarto preview 0304-Quarto.Rmd # all formats
$ quarto preview 0304-Quarto.Rmd --to html # specific format
``` 

#### In R {-}

`quarto::quarto_render(input = NULL, output_format = "html")` can be used to render a Quarto document or project in R.

- If `input` is not specified, it will render the current Quarto project. If `input` is specified, it will render the specified Quarto document.

- If `output_format` is not specified, it will render the document to HTML. You can specify other formats such as PDF or Word. 
  - `output_format = "all"` will render all formats specified in the `_quarto.yml` file.


```r
# Render a Quarto document to HTML
quarto::quarto_render("0304-Quarto.Rmd", output_format = "html")
# Render a Quarto project to HTML
quarto::quarto_render(output_format = "html")
```

```r
# Render a Quarto document to PDF
quarto::quarto_render("0304-Quarto.Rmd", output_format = "pdf")
# Render a Quarto project to PDF
quarto::quarto_render(output_format = "pdf")
```

Alternatively, you can use the **Render** button in RStudio. The Render button will render the first format listed in the document YAML. If no format is specified, then it will render to HTML.

--------------------------------------------------------------------------------

### Cross References

1. **Add labels:**

   - **Code cell:** add option `label: prefix-LABEL`
   - **Markdown:** add attribute `#prefix-LABEL`

2. **Add references:** `@prefix-LABEL`, e.g.

   ```
   You can see in @fig-scatterplot, that...
   ```

| Element  | ID         | How to cite |
| -------- | ---------- | ----------- |
| Figure   | `#fig-xxx` | `@fig-xxx`  |
| Table    | `#tbl-xxx` | `@tbl-xxx`  |
| Equation | `#eq-xxx`  | `@eq-xxx`   |
| Section  | `#sec-xxx` | `@sec-xxx`  |


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

```yaml
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

```yaml
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

```yaml
format: 
  html:
    self-contained: true
```


--------------------------------------------------------------------------------

### Divs and Spans

You can add classes, attributes, and other identifiers to regions of content using Divs and Spans.

Div example

```markdown
::: {.border} 
This content can be styled with a border 
:::
```

Once rendered to HTML, Quarto will translate the markdown into:

```html
<div class="border">   
  <p>This content can be styled with a border</p> 
</div>
```

A bracketed sequence of inlines, as one would use to begin a link, will be treated as a Span with attributes if it is followed immediately by attributes:

```markdown
[This is *some text*]{.class key="val"}
```

Once rendered to HTML, Quarto will translate the markdown into

```html
<span class="class" data-key="val">
  This is <em>some text</em>
</span>
```





___

### Theorems 

```latex
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

To add a name to Theorem, use `name="..."`.

```latex
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

Change the label prefix:

```yaml
---
crossref:
  cnj-title: "Assumption"
  cnj-prefix: "Assumption"
---
```

- `cnj-title`: The title prefix used for conjecture captions.
- `cnj-prefix`: The prefix used for an <u>inline reference</u> to a conjecture.

--------------------------------------------------------------------------------

### Callouts

There are five different types of callouts available.

- note
- warning
- important
- tip
- caution

The color and icon will be different depending upon the type that you select. 

````markdown
::: {.callout-note}
Note that there are five types of callouts, including:
`note`, `warning`, `important`, `tip`, and `caution`.
:::

::: {.callout-tip}
## Tip with Title

This is an example of a callout with a title.
:::

::: {.callout-caution collapse="true"}
## Expand To Learn About Collapse

This is an example of a 'folded' caution callout that can be expanded by the user. You can use `collapse="true"` to collapse it by default or `collapse="false"` to make a collapsible callout that is expanded by default.
:::
````

Here are what the various types look like in HTML output:


<img src="https://drive.google.com/thumbnail?id=1WVMOAJyHE_09EYkH05KREhKE3A6r1vMj&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

- Callout heading can be defined using 
  - `title = "Heading"` in the callout header, or
  - `## Heading` in the callout body
    
    It can be any level of heading.

- `icon = false` to disable the icon in the callout.
- To cross-reference a callout, add an ID attribute that starts with the appropriate callout prefix, e.g., `#nte-xxx`. You can then reference the callout using the usual `@nte-xxx` syntax. 
- `appearance = "default" | "simple" | "minimal"` 
  - `default`: to use the default appearance with a background color and border.
  - `simple`: to remove the background color, but keep the border and icon.
  - `minimal`: A minimal treatment that applies borders to the callout, but doesn’t include a header background color or icon.
    
    `appearance="minimal"` is equivalent to `appearance = "simple" icon = false` in the callout header.



--------------------------------------------------------------------------------

**References**:

- <https://www.njtierney.com/post/2022/04/11/rmd-to-qmd/>
- Cheatsheet: <https://rstudio.github.io/cheatsheets/html/quarto.html>
- Citations: <https://quarto.org/docs/authoring/citations.html>
- Theorems: <https://quarto.org/docs/authoring/cross-references.html#theorems-and-proofs>







