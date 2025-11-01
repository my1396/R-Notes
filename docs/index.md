--- 
title: "R Notes"
author: "Menghan Yuan"
# date: "2025-10-31"
site: bookdown::bookdown_site
bibliography: [book.bib, packages.bib]
# url: your book url like https://bookdown.org/yihui/bookdown
# cover-image: path to the social sharing image like images/cover.jpg
description: |
  This is a minimal example of using the bookdown package to write a book.
  The HTML output format for this example is bookdown::gitbook,
  set in the _output.yml file.
link-citations: yes
github-repo: my1396/R-Notes
favicon: "images/r-project-favicon.ico"
# typesetting for LaTeX output
documentclass: book
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


# About

This is a _sample_ book written in **Markdown**. You can use anything that Pandoc's Markdown supports; for example, a math equation $a^2 + b^2 = c^2$.

## Usage 

Each **bookdown** chapter is an .Rmd file, and each .Rmd file can contain one (and only one) chapter. A chapter *must* start with a first-level heading: `# A good chapter`, and can contain one (and only one) first-level heading.

Use second-level and higher headings within chapters like: `## A short section` or `### An even shorter section`.

The `index.Rmd` file is required, and is also your first book chapter. It will be the homepage when you render the book.

## Render book

You can render the HTML version of this example book without changing anything:

1. Find the **Build** pane in the RStudio IDE, and

1. Click on **Build Book**, then select your output format, or select "All formats" if you'd like to use multiple formats from the same book source files.

Or build the book from the R console:


``` r
bookdown::render_book()
```

To render this example to PDF as a `bookdown::pdf_book`, you'll need to install XeLaTeX. You are recommended to install TinyTeX (which includes XeLaTeX): <https://yihui.org/tinytex/>.

## Preview book

As you work, you may start a local server to live preview this HTML book. This preview will update as you edit the book when you save individual .Rmd files. You can start the server in a work session by using the RStudio add-in "Preview book", or from the R console:


``` r
bookdown::serve_book(dir = ".", output_dir = "_book", preview = TRUE, quiet = FALSE)
```

You pass the root directory of the book to the `dir` argument, and this function will start a local web server so you can view the book output using the server. The default URL to access the book output is `http://127.0.0.1:4321`.

Depending on your IDE, the url will be opened in either internal or external web browser.

The server will listen to changes in the book root directory: whenever you **modify any files** in the book directory, `serve_book()` can detect the changes, recompile the Rmd files, and refresh the web browser automatically.

- If you set `preview = FALSE`, the function will recompile the book, which can take a longer time.

- `quiet = TRUE` will suppress output (e.g., the knitting progress) in the console.
  
  Even if the compiling messages are distracting, they tell you the status of the book rendering, so you may want to keep the default anyway.


**To stop the server**, run `servr::daemon_stop(1)` or restart your R session.


`bookdown::serve_book()` is better than using live preview in VS Code because the html viewer does not blink continuously when you edit and save the .Rmd files. Besides, live preview do not refresh contents automatically.

💡 **Tip:** 

- Use `serve_book()` while working on your book to see live changes, then run `render_book()` once you are ready to publish.
- `serve_book()` and `preview_chapter` are slow as they recompile the entire book when you save any file. 
  
  Suggested action: `rmarkdown::render_site("onefile.Rmd")` to render the current active file. Go to `docs/` and right-click `onefile.html` > select `Show Preview` to open in browser. ✅

  The web preview will not update automatically (no flashing), so you need to re-render the file when you make changes.

--------------------------------------------------------------------------------

**Bibliography**


``` r
# automatically create a bib database for R packages
knitr::write_bib(c(
  .packages(), 'bookdown', 'knitr', 'rmarkdown'
), 'packages.bib')
```

