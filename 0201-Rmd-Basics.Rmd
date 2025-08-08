## Rmd Basics

To name a chunk, add the name after `r`, it's not necessary to add `label='chunk-name'`, but it is possible to do so if you prefer the form `tag=value`. 

**The Chunk Label**

- Must be unique within the document. This is especially important for cache and plot filenames, because these filenames are based on chunk labels. Chunks without labels will be assigned labels like `unnamed-chunk-i`, where `i` is an incremental number.
- Avoid spaces (`␣`), periods ( `.`), and underscores (`_`) in chunk labels and paths.  If you need separators, you are recommended to use **hyphens** (`-`) instead. 

`knitr::opts_chunk$set()` changes the default values of chunk options in a document. See [here](#common-chunk-options) for commonly used chunk options.


--------------------------------------------------------------------------------

**Unnumbered Sections**

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

- By default `Bookdown` starts a new page for each level 2 heading. If you want to keep the style without starting a new page, use an html tag. The heading won't be numbered or included in TOC. However, a downside is that the heading won't show up in the file outline either, making them harder to locate.

  ```html
  <h2>YAML metadata</h2>
  ```

<span style="color: #008B45;">**Add Section ID**</span>

To add a section ID, use `{#section-id}` at the end of the section title. This is useful for linking to specific sections within the document or from other documents.

```markdown
Add a section ID
# Question 1: Variance and Covariance properties {#variance-covariance}

Refer to this section using the ID: [Variance and Covariance properties](#variance-covariance). 
```

- Bookdown supports **cross files linking**.
- By default, Pandoc will generate an ID for all section headers, e.g., a section `# Hello World` will have an ID `hello-world`. However, we recommend you to **manually assign an ID** to a section header to make sure you do not forget to update the reference label after you change the section header. 
- Further attributes of section headers can be set using standard [Pandoc syntax](http://pandoc.org/MANUAL.html#heading-identifiers).

--------------------------------------------------------------------------------

Q: How to cross reference a regular text across files? \
A: There's **no built-in `@ref()`** syntax for referencing arbitrary inline text. You can achieve this using html anchors. 

- In the source `.Rmd` file (say, `chapter1.Rmd`), write:

  ```markdown
  <span id="mytext">This is the important concept you want to reference later.</span>
  ```

- Then, in another `.Rmd` file (say, `chapter2.Rmd`), link to it with:

  ```markdown
  See [this explanation](#mytext) in Chapter 1.
  ```
  This works for HTML output only.

--------------------------------------------------------------------------------


**Knitting in the global environment**

```r
rmarkdown::render("/Users/menghan/Library/CloudStorage/OneDrive-Norduniversitet/EK369E/Seminars/w1.rmd", envir=.GlobalEnv)
```

**Advantages**: fast; load and output results in the global environment; easy to inspect afterwards.


--------------------------------------------------------------------------------

Rmd has many **built-in themes** which can be conveniently applied to your html document.

See here for a preview for some popular html themes: <https://rstudio4edu.github.io/rstudio4edu-book/rmd-themes.html>

Use the following code in either `_site.yml` (if R Markdown websites) or `_output.yml`(if Bookdown websites) to set the theme:

```yaml
html_document:
  toc: true
  toc_depth: 2
  theme: cerulean
  highlight: tango
```

- `theme` specifies the theme to use for the presentation (available themes are `"default"`, `"simple"`, `"sky"`, `"beige"`, `"serif"`, `"solarized"`, `"blood"`, `"moon"`, `"night"`, `"black"`, `"league"`, and `"white"`).
- [`highlight`](https://elastic-lovelace-155848.netlify.app/highlighters.html) specifies the syntax highlighting style. Supported styles include `"default"`, `"tango"`, `"pygments"`, `"kate"`, `"monochrome"`, `"espresso"`, `"zenburn"`, and `"haddock"`. Pass null to prevent syntax highlighting.


--------------------------------------------------------------------------------


`.Rmd` documents can be edited in either `source` or `visual` mode. To switch into visual mode for a given document, use the Source or Visual button at the top-left of the document toolbar (or alternatively the `Cmd+Shift+F4` keyboard shortcut).

**Visual mode**

- Visual mode allows you to preview the effect after having compiled the markdown file.

  ❗️But it modifies your code silently, be cautions with visual mode.

- More user-friendly in terms of providing drop down menus for editing.

- Visual mode supports both traditional **keyboard shortcuts** (e.g. `Cmd + B` for bold) as well as markdown shortcuts (using markdown syntax directly). For example, enclose `**bold**` text in asterisks or type `##` and press space to create a second level heading. 

- One bug for Visual mode is that inside **bullet points**, `$` is automatically escaped as `\$`. In this case, use <span style='color:#00CC66'>`cmd+/`</span> and choose <span style='color:#00CC66'>inline math</span> to insert an eqn.

- When type inline equations, first type `$` then the equation, then `$` at last. Do not type `$$` at one time. Otherwise, they will be escaped as regular text.


--------------------------------------------------------------------------------

**Comments in Rmd**

- In both html and pdf outputs, use the following to write true comments you don't want to show in the rendered file.

  ```r
  <!-- regular html comment --> 
  ```

--------------------------------------------------------------------------------

**Link to an external javascript**

```html
<SCRIPT language="JavaScript" SRC="my_jxscript.js"></SCRIPT>
```


--------------------------------------------------------------------------------

**Tips**:

- In general, you'd better <u>leave at least one empty line</u> between adjacent but different elements, e.g., a header and a paragraph. This is to avoid ambiguity to the Markdown renderer. 

  For example, the `-` in the list below cannot be recognized as a bullet point. You need to add a black line before the bullet list.

  ```markdown
  The result of 5
  - 3 is 2.
  ```

  **Different flavors of Markdown** may produce different results if there are no blank lines. 🙈🙈

- Need to escape `@` in the text by `\@` in bookdown, otherwise, it will be interpreted as a citation key, e.g., `@author` or `@citekey`.
  
  [Special characters](https://github.com/mattcone/markdown-guide/blob/master/_basic-syntax/escaping-characters.md) that have specific meanings in Markdown, such as `*`, `_`, `#`, `+`, `-`, should be escaped with a backslash (`\`) if you want to display them literally. 

  ```markdown
  \* Without the backslash, this would be a bullet in an unordered list.
  ```
