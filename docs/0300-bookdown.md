# bookdown


**[Bookdown](https://bookdown.org/yihui/rmarkdown/bookdown-start.html)** is an extra package for R Markdown that is particularly useful for long documents.

- In HTML format, produces a full website of interlinked pages, one page per chapter
- Other HTML features: contents bar, search, colour schemes, font size adjustment, etc
- Adds LaTeX-like theorem/definition/proof environments

| “Plain” R Markdown                         | R Markdown with Bookdown                    |
| ------------------------------------------ | ------------------------------------------- |
| Good for short documents, single HTML page | Good for long documents, multi-page website |
| PDF or accessible HTML                     | PDF or accessible HTML                      |
| LaTeX equations                            | LaTeX equations                             |
| No theorem environments                    | Theorem environments                        |


We can reference chunks (tables and figures), sections, and equations in `bookdown` output formats

- `bookdown` extends Pandoc
- Examples of `bookdown` formats are `bookdown::pdf_document2` or `bookdown::html_document2`.
- Refer to 
    - Figure `\@ref(fig:chunk-name)`
    - Table `\@ref(tab:chunk-name)`
    - Section `\@ref(my-section)`

Examples of chunks:

````markdown
```{r chunk-name}
plot(cars)
``` 
See Figure \@ref{fig:chunk-name}.
````
<br>

```markdown
# Section {#my-section}

Refer to Section \@ref{my-section}
```

--------------------------------------------------------------------------------

**Create a `bookdown` project**:

`File` → `New Project` → `New Directory` → `Book project using bookdown` → `Create Project`

**Bookdown cookbook**: <https://rstudio4edu.github.io/rstudio4edu-book/book-dress.html>

--------------------------------------------------------------------------------

**Deployment and Hosting `bookdown` on GitHub Pages**

Ref: Authoring Books with R Markdown, <https://bookdown.org/yihui/bookdown/github.html>

1. Initialize your local git repository and link to the remote GitHub repo.
   
    See instructions [HERE][init-git].

2. Go to your `_bookdown.yml` file and add `output_dir: "docs"` on a line by itself

3. Serve/preview your book locally

   Now the website output files should be in `/docs`.

   Create a `.nojekyll` in `/docs` that tells GitHub that your website is not to be built via Jekyll.

   ```bash
   touch .nojekyll
   ```

4. Push your changes to GitHub remote

5. Configure publishing source for GH pages as main branch `/docs` folder

   Go to your GH remote repo, click `Settings` → click `Pages` in the left column → under `GitHub Pages`, change the “Source” to be “main branch /docs folder”.

   <img src="https://drive.google.com/thumbnail?id=1Fvyx6UCwaZsqaT11X2JCrmdCLQJPZOii&sz=w1000" alt="GH pages Source" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

--------------------------------------------------------------------------------

## bookdown project structure

Below shows the basic [structure of a default `bookdown` project](https://bookdown.org/yihui/rmarkdown/bookdown-project.html):

```markdown
directory/
├──  index.Rmd
├── 01-intro.Rmd
├── 02-literature.Rmd
├── 03-method.Rmd
├── 04-application.Rmd
├── 05-summary.Rmd
├── 06-references.Rmd
├── _bookdown.yml
├── _output.yml
├──  book.bib
├──  preamble.tex
├──  README.md
└──  style.css
```

As a summary of these files:

- <a href="#bd-index">`index.Rmd`</a>: **This is the only Rmd document to contain a YAML frontmatter**, and is the first book chapter.

- Rmd files: A typical bookdown book contains multiple chapters, and each chapter lives in one separate Rmd file.

- <a href="#bookdown-config">`_bookdown.yml`</a>: A configuration file for bookdown.

- <a href="#output">`_output.yml`</a>: It specifies the formatting of the HTML, LaTeX/PDF, and e-books.

- `preamble.tex` and `style.css`: They can be used to adjust the appearance and styles of the book output document(s). Knowledge of LaTeX and/or CSS is required.

These files are explained in greater detail in the following subsections.

--------------------------------------------------------------------------------

<a id="output"></a>

### `_output.yml` {.unnumbered}

**`_output.yml`** **Output formats** can be specified either 

- in the YAML metadata of the first Rmd file of the book (usually <a href="#bd-index">`index.Rmd`</a>), or 
- in a separate YAML file named `_output.yml` under the root directory of the book. 

See [Section 12.4 in *R Markdown: The Definitive Guide*](https://bookdown.org/yihui/rmarkdown/bookdown-output.html#bookdown-output) for a complete list of bookdown output formats. A quick takeaway is that bookdown supports both book types and single documents. 

**Common uses of `_output.yml`**:

- Specify supported output formats: `bookdown::gitbook`, `bookdown::pdf_book`, `bookdown::epub_book`, etc.

- Add an edit link, e.g., `https://github.com/my1396/R-Notes/edit/main/%s`

  This will configure which remote repo to link to and hence allow the page to be downloadable as an `.Rmd`. Also need to specify `download: ["rmd"]`.

- Link to your GitHub in the toolbar (also need <a href="#bd-index">`index.Rmd`</a>)

- Add other sharing links

- Header and footer of your TOC

- Collapse the TOC by (sub)section

- Code highlighting
  
  Here we use `highlight: tango` to apply the [Tango](https://tango.freedesktop.org/) theme.

  The issue is that Tango highlighting does not work well with dark mode.

  

Here is a brief example of  `_output.yml`:

```yml
bookdown::gitbook:
  css: style.css
  highlight: tango
  split_by: section+number
  includes:
    in_header: head.html
  config:
    fontsettings:
      theme: sky
    toc:
      collapse: section+number
      before: |
        <li><a href="./">R Notes</a></li>
      after: |
        <li><a href="https://github.com/rstudio/bookdown" target="blank">Published with bookdown</a></li>
    toc_depth: 3
    edit: 
        link: https://github.com/my1396/R-Notes/edit/main/%s
    sharing:
        github: yes
    download: ["pdf", "epub", "rmd"]
    enableEmoji: true

bookdown::pdf_book:
  includes:
    in_header: preamble.tex
  latex_engine: xelatex
  citation_package: natbib
  keep_tex: yes

bookdown::epub_book: default
```

You do NOT need the three dashes `---` in `_output.yml`. In this case, all formats should be at the top level, instead of under an `output` field in individual Rmds. 

The output format `bookdown::gitbook` is built upon `rmarkdown::html_document`, which was explained in Section [3.1](https://bookdown.org/yihui/rmarkdown/html-document.html#html-document) in R Markdown: The Definitive Guide. The main difference between rendering in R Markdown and **bookdown** is that a book will generate multiple HTML pages by default. 

[`bookdown::gitbook` settings:](https://bookdown.org/yihui/bookdown/html.html#gitbook-style)

- `css: style.css` specifies one or more custom CSS files to tweak the default CSS style.
  
  Note that `bookdown::gitbook` has a set of default CSS files. Use `docs/libs/gitbook-2.6.7/css` to see the default settings.
  If some of your custom CSS settings are not applied, it is likely due to conflicts with gitbook CSS. You may need to override the default CSS files by appending `!important` to your custom CSS settings.

-  There are several sub-options in the `config` option for you to tweak some details in the user interface. See [here][gitbook-config] for the default settings of `config`.

   - **Font/theme settings**

     ```yaml
     fontsettings:
     # changing the default
       theme: night
       family: serif
       size: 3
     ```
     
     You can set the initial value of these settings via the `fontsettings` option. 

      - Font size is measured on a scale of 0-4; the initial value can be set to 1, 2 (default), 3, or 4. 
      - `theme: white | sepia | night`. Default to `white`.
   
  - `download: ["pdf", "epub", "rmd"]` specifies which formats to allow users to download the book in. 
   
    When `download: null` (by default), `gitbook()` will look for PDF, EPUB, and MOBI files in the book output directory, and automatically add them to the download option. If you just want to suppress the download button, use `download: false`. 
   
- `split_by= c("chapter", "chapter+number", "section", "section+number", "rmd", "none")` defaults to `chapter`, which splits the file by the first-level headers. 

    - `chapter` splits the file by the first-level headers; 
    
        A chapter page may be too long if there are many sections within chapters.
        
    - `section` splits the file by the <span style='color:#008B45'>second-level</span> headers.
    - `chapter+number` and `section+number`: the chapter/section numbers will be prepended to the HTML filenames. For example: if using `chapter` or `section`, the HTML file names will be `introduction.html`, `literature.html`, etc.; but with the numbering setting, the HTML file names will be `1-introduction.html`, `2-literature.html`, etc.
    - I prefer <span style='color:#008B45'>`section+number`</span> as it *orders all html in the book's section order*. ✅

- The [`includes` option](https://bookdown.org/yihui/bookdown/yaml-options.html) allows you to insert arbitrary custom content before and/or after the body of the output.

    It has three sub-options: `in_header`, `before_body`, and `after_body`. You need to know the basic structure of an HTML or LaTeX document to understand these options. 
    
    - The source of an HTML document looks like this:
    
    ```html
    <html>
    
      <head>
      <!-- head content here, e.g. CSS and JS -->
      </head>
      
      <body>
      <!-- body content here -->
      </body>

    </html>
    ```
    
    The `in_header` option takes a file path and inserts it into the `<head>` tag. The `before_body` file will be inserted right below the opening `<body>` tag, and `after_body` is inserted before the closing tag `</body>`.
    
    **Use example** of `includes` option in HTML output.
    
    For example, when you have LaTeX math expressions rendered via the MathJax library in the HTML output, and want the equation numbers to be displayed on the left (default is on the right), you can create a text file (named `mathjax-number.html`) that contains the following code:
    
    ```js
    <script type="text/x-mathjax-config">
    MathJax.Hub.Config({
      TeX: { TagSide: "left" }
    });
    </script>
    ```
    
    Let’s assume the file `mathjax-number.html` is in the root directory of your book (the directory that contains all your Rmd files). You can insert this file into the HTML head via the `in_header` option, e.g.,
    
    ```markdown
    ---
    output:
      bookdown::gitbook:
        includes:
          in_header: mathjax-number.html
    ---
    ```
    
    Example of MathJax config files: 
    
    - [`0007bookdown/mathjax_header.html`](https://github.com/matthew-towers/0007bookdown/blob/master/mathjax_header.html) by matthew-towers
            
      @matthew-towers uses a very clever approach, probably the easiest setup -- define the command directly in LaTeX and enclode in `<span class="math inline">$...$</span>` to indicate this is inline math.
      
    - [Using inline config options](https://docs.mathjax.org/en/v2.7-latest/configuration.html#using-in-line-configuration-options)
    - [Stack Overflow MathJax](https://stackoverflow.com/questions/76312006/how-to-load-mathjax-extensions-in-bookdown)
    
    [Bookdown uses MathJax 2.7 by default](https://forum.posit.co/t/cannot-load-mathtools-mathjax-extension-in-bookdown/131073). 
    
    [**Define TeX macros**](https://docs.mathjax.org/en/v2.7-latest/tex.html#defining-tex-macros)
    
    You can include macro definitions in the Macros section of the TeX blocks of your configuration:
    
    ```
    MathJax.Hub.Config({
      TeX: {
        Macros: {
          RR: "{\\bf R}",
          bold: ["{\\bf #1}",1]
        }
      }
    });
    ```
    
    Note that `MathJax.Hub.Config` is used in [inline configuration](https://docs.mathjax.org/en/v2.7-latest/configuration.html#configuring-mathjax). It is **case-sensitive**. `Macros` has capital `M`, and `TeX`, rather than `tex`, is used.
    
    - A LaTeX source document has a similar structure:
      
    ```latex
    \documentclass{book}

    % LaTeX preamble
    % insert in_header here
    
    \begin{document}
    % insert before_body here
    
    % body content here
    
    % insert after_body here
    \end{document}
    ```

- You can add a **table of contents** using the `toc` option and specify the depth of headers that it applies to using the `toc_depth` option. 
  
    - If the TOC depth defaults to 3 in `html_document`.
    - For `pdf_document`, if the TOC depth is not explicitly specified, it defaults to 2 (meaning that all level 1 and 2 headers will be included in the TOC).
    
    ````markdown
    ---
    bookdown::gitbook:
        toc:
            collapse: subsection
        toc_depth: 3
    ---
    ````
    
    `collapse` specifies a level to expand to by default, aka at `#`, `##`, or `###`.  
    
    I suggest collapsing at level 2. This way, you get a good overview of what each major topic (level 1 heading) includes, without showing the most detailed items.
    
    - `collapse: subsection`: At startup, the toc will collapse at the level 2 headings. As you go to one specific subsection, the content inside will expand. You can see level 3 headings. ✅
    - `collapse: section`: At startup, the toc will collapse at the level 1 headings, which keeps the appearance concise. However, a side effect is that level 3 headings will never be displaied when navigating to a specific level 2 heading.
    

bookdown 中文书籍 `_output.yml` 范例: <https://github.com/yihui/bookdown-chinese/blob/96d526572f0c6648d06c2d4bebf57c5fb4eafce3/_output.yml>

- You can set up a **tex template**. 

    Yihui sets up the Chinese support in the template file (`latex/template.tex`).

    ```yml
    bookdown::pdf_book:
      includes:
        in_header: latex/preamble.tex
        before_body: latex/before_body.tex
        after_body: latex/after_body.tex
      keep_tex: yes
      dev: "cairo_pdf"
      latex_engine: xelatex
      citation_package: natbib
      template: latex/template.tex
    ```
    
    The base format for `bookdown::pdf_book` is `rmarkdown::pdf_document`.
    
    `dev`: Graphics device to use for figure output, defaults to `pdf`.

-----------------------------------------------------------------------------

<a id="bookdown-config"></a>

### `_bookdown.yml` {.unnumbered}


**`_bookdown.yml`**  allows you to specify optional settings to build the book. For example:

- Set [`output_dir: docs`](https://rstudio4edu.github.io/rstudio4edu-book/make-book.html#book-output)
- Set [`new_session: yes`](https://bookdown.org/yihui/bookdown/new-session.html)

  When set to `yes`, it uses "Knit and Merge" (K–M), and creates a new R session for each chapter, which is useful for avoiding conflicts between packages or variables across chapters.

  The default is `no`, which uses "Merge and Knit" (M-K), where all chapters are knitted in one R session.
- Change themes
- Change the chapter name
- Change [chapter order](https://rstudio4edu.github.io/rstudio4edu-book/book-yours.html#book-order)



```yml
delete_merged_file: true
output_dir: "docs"
new_session: yes
language:
  ui:
    chapter_name: "Chapter "
```

Note that you don't need to manually create the `docs` folder, bookdown will create one if it doesn't exists.

- `delete_merged_file`: whether to delete the main Rmd file after the book is successfully rendered. An Rmd file that is merged from all chapters; by default, it is named `_main.Rmd`.

- [`before_chapter_script`](https://github.com/rstudio/bookdown/issues/1252#issuecomment-913530117): one or multiple R scripts to be executed before each chapter. 

- After you serve your site locally, all supporting files will be output to `docs`. Be sure to add one `.nojekyll` file in `docs` to tell GitHub that your website is not to be built via Jekyll. 

- Because bookdown only overwrites existing files and does not delete unused ones, you can simply delete the `docs` folder so that bookdown will recreate everything necessary without any redundancy. 
  
    Remember to recreate `.nojekyll` too after bookdown has created the new `docs`.

--------------------------------------------------------------------------------

<a id="bd-index"></a>

### `index.Rmd` {.unnumbered}


**`index.Rmd`** <span style='color:#008B45'>**homepage of your website**</span>. Contains the first chapter and the <span style='color:#008B45'>**YAML metadata**</span> which will be applied to all other Rmd pages. 

That is, `index.Rmd` sets the global YAML for the entire website. Moreover, `index.Rmd` is the **only** Rmd document that contains a **YAML frontmatter**. 

See [Chapter 2.2 in *R Markdown: The Definitive Guide*](https://bookdown.org/yihui/rmarkdown/compile.html) for YAML details.




Common uses of `index.Rmd`'s YAML frontmatter:

- Book cover, title, author, date, and description

- Add **bibliography**
  
    Once you have one or multiple `.bib` files, you may use the field bibliography in the YAML metadata of your first R Markdown document (which is typically `index.Rmd`), and you can also specify the bibliography style via biblio-style (this only applies to PDF output).
    
    ```yml
    bibliography: [book.bib, packages.bib]
    biblio-style: "apalike"
    ```
    
    Add your user citation to <span style='color:#008B45'>**`book.bib`**</span> in stead.
    
    Don't remove `packages.bib`; it is automatically generated and overwritten every time you rebuild the book.

- Link to your GitHub in the toolbar (also need `_output.yml`)

- Add a favicon

  Add the following line to `index.Rmd` YAML:

  ```yml
  favicon: "images/r-project-favicon.ico"
  ```

  Issue: Favicon shows ok on Chrome but couldn't display on Safari. Same issue reported in [Stack Overflow](https://stackoverflow.com/questions/66023588/r-bookdown-favicon-works-offline-but-not-online). \
  Fix: There is a delay for Safari to show Favicon. Wait for two hours and the issue resolves itself...


An example of `index.Rmd`

````markdown
---
title: "A Minimal bookdown Project"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
csl: chicago-fullnote-bibliography.csl
github-repo: my1396/R-Notes
favicon: "images/r-project-favicon.ico"
# typesetting for LaTeX output
papersize: a4 # The printed size of the thesis
geometry:
  - top=25.4mm
  - bottom=25.4mm
  - left=25.4mm
  - right=38.1mm
  # - bindingoffset=6.4mm  # removes a specified space from the inner-side for twoside.
  # - asymmetric  # disable alternating margins on odd/even pages
classoption: 
  - twoside
  - openright
---

# Preface

Some content
````

- `site: bookdown::bookdown_site` tells rmarkdown to use `bookdown` to build <u>all Rmd files</u>, instead of rendering a single Rmd file. 


--------------------------------------------------------------------------------

### `.Rmd` files {.unnumbered}


- Chapters (also sections) are based on separate Rmd files.

- Besides `index.Rmd`, other R Markdown files will make up the chapters of your book. By default, `bookdown` merges all Rmd files by the order of filenames, e.g., `01-intro.Rmd` will appear before `02-literature.Rmd`. 

- The Rmd files must start immediately with the chapter title using the first-level heading, e.g., `# Chapter Title`. Note that YAML metadata should <span style='color:#FF9900'>NOT</span> be included in these Rmd files, as it is inherited from the <a href="#bd-index">`index.Rmd`</a> file.


`01-intro.Rmd`

````markdown
# Introduction

This chapter is an overview of the methods that
we propose to solve an **important problem**.
````

`02-literature.Rmd`

````markdown
# Literature

Here is a review of existing methods.
````



[gitbook-config]: https://bookdown.org/yihui/bookdown/html.html#:~:text=%20We%20display%20the%20default%20sub%2Doptions%20of%20config%20in%20the%20gitbook%20format%20as%20YAML%20metadata%20below%20(note%20that%20they%20are%20indented%20under%20the%20config%20option "Default config for bookdown::gitbook"
[init-git]: https://my1396.github.io/Econ-Study/2023/10/12/GitHub101.html#push-an-existing-repository "Initialize git and link to remote"


