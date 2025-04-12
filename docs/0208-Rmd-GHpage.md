## Rmd GitHub Pages

**Stage-commit-push many files**

1.  Use the Terminal `git add .` to “stage” all the files that I want to commit as that’s quicker than clicking on all the files often that I want to commit.

2.  Go to RStudio `Commit Pending changes` icon (the white docs icon with a tick in a Git pane) to write the commit as I find `git commit -m "Write your message here"` a bit too long!

3.  Use the Push and Pull buttons in RStudio as that’s easier than typing `git push` or `git pull` in the terminal.



Note that the minimum requirement for any R Markdown website is that it have an `index.Rmd` file as well as a `_site.yml` file. If you execute the `rmarkdown::render_site()` function from within the directory containing the website, the following will occur:

1. All of the `*.Rmd` and `*.md` files in the root website directory will be rendered into HTML. Note, however, that Markdown files beginning with `_` are not rendered (this is a convention to designate files that are to be included by top level Rmd documents as child documents).

   1. `index.Rmd` controls the content on your main page.

2. The generated HTML files and any supporting files (e.g., CSS and JavaScript) are copied into an output directory (`_site` by default, on Github Pages the output folder is `docs`).

   - `_site.yml` controls the styling.

   - The HTML files within the output directory are now ready to deploy as a standalone static website.



`_site.yml`

```yml
name: "my-website"
output_dir: "docs"
include: ["import.R"]
exclude: ["docs.txt", "*.csv"]
```

- `name` provides a suggested URL path for your website when it is published

- `output_dir` field indicates which directory to copy site content into.

- The `include` and `exclude` fields enable you to override the default behavior vis-à-vis what files are copied into the output directory. By default, all files within the website directory are copied into the output directory (e.g. “_site”) except for the following:

  1. Files beginning with `"."` (hidden files).
  2. Files beginning with `"_"`
  3. Files known to contain R source code (e.g. `".R"`, `".s"`, `".Rmd"`), R data (e.g. `".RData"`, `".rds"`), or configuration data (e.g. `"rsconnect"` ,`"packrat"`, `"renv"`)).

  The `include` and `exclude` fields of **_site.yml** can be used to override this default behavior (wildcards can be used to specify groups of files to be included or excluded). Note that the `include` and `exclude` fields target only top-level files and directories (i.e. a directory is either included or not, you can’t exclude a subset of files within a directory).

  Note also that `include` and `exclude` are *not* used to determine which Rmd files are rendered (all of them in the root directory save for those named with the `_` prefix will be rendered).

--------------------------------------------------------------------------------

<span style='color:#00CC66'>**Workflow**</span>: Edit your site, **build** it, then push and commit to GitHub to publish your changes online.

To render <span style='color:#00CC66'>all of the pages</span> in the website, you use the `Build` pane, which calls `rmarkdown::render_site()` to build and then preview the entire site 

As you work on the <span style='color:#00CC66'>individual pages</span> of your website, you can render them using the `Knit` button just as you do with conventional standalone R Markdown documents. Or use the command line `rmarkdown::render("0100-RStudio.Rmd")`. It will generate the html output `RStudio.html` in the same directory. You can see it in the Output pane > `Files` tab. Click the file and choose `View in Web Browser`.

Note:

- Each time you run `rmarkdown::render_site()`, the `docs/` folder will be overwritten with updated HTML versions of your `.Rmd`s. This means DON’T EVER EDIT FILES IN THE `docs/` FOLDER! Nothing catastrophic will happen if you do, but you will overwrite and lose all your changes the next time you knit or `render_site()`.
- Don't forget to update 
  - `index_Rmd` (home page) and 
  - `_site.yml` (cross references files `include: ["w1.rmd", "w2.rmd"]`)
    - This will copy files into `docs` so that you can put a downloadable link to them.


--------------------------------------------------------------------------------

CSS Style

```markdown
---
output: 
  html_document:
    theme: cosmo
   # css: style.css # link to external CSS
---

<style type = "text/css"> 
h2 {
  color: red; /* internal CSS */
}
</style>

## R Markdown
```



--------------------------------------------------------------------------------

**Refer to your posts using relative links**

If you have a Markdown file in your repository at `docs/project1.html`, and you want to link from that file to `docs/another-page.md`, you can do so with the following markup:

```scss
[a relative link](project1.html)
```

When you view the source file on GitHub.com, the relative link will continue to work, but now, when you publish that file using GitHub Pages, the link will be silently translated to `docs/another-page.html` to match the target page’s published URL.

Link to another file

```css
[download](w1.rmd)
<a href="w1.rmd">Download File</a>
```


--------------------------------------------------------------------------------


**TOC** on home page: 

- source code: <https://github.com/lmullen/rmd-notebook/blob/master/index.Rmd>
- webpage: <https://lmullen.github.io/rmd-notebook/>

```r
# replacing with the following options
# {r TOC, echo=FALSE, results='asis'}
rmd <- Sys.glob("*.[Rr]md")
rmd <- rmd[!rmd %in% c("index.Rmd", "about.Rmd")]
html <- sub(".Rmd", ".html", rmd)
lines <- lapply(rmd, readLines)
yaml <- lapply(lines, rmarkdown:::parse_yaml_front_matter)
cat("<ul>")
for (i in seq_along(rmd)) {
  cat(paste0("<li><a href='", html[i], "'>", yaml[[i]]$title, "</a><br/>",
             "<code>", rmd[i], "</code>", "</li>"))
}
cat("</ul>")
```

--------------------------------------------------------------------------------

Project website:

- Structure: <https://www.storybench.org/convert-google-doc-rmarkdown-publish-github-pages/>

- Multi-page website: <https://phuston.github.io/patrickandfrantonarethebestninjas/howto>

- Blogdown: <https://github.com/liuyanguu/Blogdown?tab=readme-ov-file>

- Distill: <https://rstudio.github.io/distill/website.html>

- Bookdown Notes for One Course: 

    <https://github.com/bcallaway11/econ_4750_notes>

    <https://bcallaway11.github.io/econ_4750_notes/law-of-iterated-expectations.html#>



