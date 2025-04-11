## Rmd Basics

To name a chunk, add the name after `r`, it's not necessary to add `label='chunk-name'`, but it is possible to do so if you prefer the form `tag=value`. 

**The chunk label**

- Must be unique within the document. This is especially important for cache and plot filenames, because these filenames are based on chunk labels. Chunks without labels will be assigned labels like `unnamed-chunk-i`, where `i` is an incremental number.
- Avoid spaces (`␣`), periods ( `.`), and underscores (`_`) in chunk labels and paths.  If you need separators, you are recommended to use hyphens (`-`) instead. 

`knitr::opts_chunk$set()` changes the default values of chunk options in a document. 


--------------------------------------------------------------------------------


**Unnumbered sections**

Add `{-}` at the end of the section title.

```markdown
# Question 1: Variance and Covariance properties {-}
<!-- equivalently, you can use {.unnumbered} --> 
# Question 1: Variance and Covariance properties {.unnumbered}
```

Note that the section won't be numbered but will show in the TOC.

If you want to further exclude it from the TOC:

```markdown
# Question 1: Variance and Covariance properties {.unlisted .unnumbered}
```

Headings with `#` will appear in the file outline, which is a convenient feature. So use this method whenever possible. 

One exception is level 2 headings in Bookdown:

- By default `Bookdown` starts a new page for each level 2 heading. If you want to keep the style wihtout starting a new page, use an html tag. The heading won't be numbered or included in TOC. However, a downside is that the heading won't show up in the file outline either, making them harder to locate.

  ```html
  <h2>YAML metadata</h2>
  ```


--------------------------------------------------------------------------------


**Knitting in the global environment**

```r
rmarkdown::render("/Users/menghan/Library/CloudStorage/OneDrive-Norduniversitet/EK369E/Seminars/w1.rmd", envir=.GlobalEnv)
```

**Advantages**: fast; load and output results in the global environment; easy to inspect afterwards.



Rmd built-in themes for `html` output: <https://rstudio4edu.github.io/rstudio4edu-book/rmd-themes.html>



`.Rmd` documents can be edited in either source or visual mode. To switch into visual mode for a given document, use the Source or Visual button at the top-left of the document toolbar (or alternatively the `Cmd+Shift+F4` keyboard shortcut).

- Visual mode allows you to preview the effect after having compiled the markdown file.

  ❗️But it modifies your code siliently, be cautions with visual mode.

- More user-friendly in terms of providing dropdown menus for editting.

- Visual mode supports both traditional **keyboard shortcuts** (e.g. `Cmd + B` for bold) as well as markdown shortcuts (using markdown syntax directly). For example, enclose `**bold**` text in asterisks or type `##` and press space to create a second level heading. 

- One bug for Visual mode is that inside **bullet points**, `$` is automatically escaped as `\$`. In this case, use <span style='color:#00CC66'>`cmd+/`</span> and choose <span style='color:#00CC66'>inline math</span> to insert an eqn.

- When type inline equations, first type `$` then the equation, then `$` at last. Do not type `$$` at one time. Otherwise, they will be escaped as regular text.


--------------------------------------------------------------------------------

**Comments in Rmd**

- In both html and pdf outputs, use the following to write true comments you don't want to show in the rendered file.

  ```r
  <!-- regular html comment --> 
  ```

  

**Link to an external javascript**

```html
<SCRIPT language="JavaScript" SRC="my_jxscript.js"></SCRIPT>
```









