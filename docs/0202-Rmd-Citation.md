## Citations

For an overview of including bibliographies in your output document, you may see [Section 2.8](https://bookdown.org/yihui/bookdown/citations.html) of Xie ([2016](https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html#ref-bookdown2016)). 

The basic usage requires us to specify a bibliography file using the `bibliography` metadata field in YAML. For example:

```markdown
---
output: html_document
bibliography: references.bib  
---
```

where the BibTeX database is a plain-text file with the `*.bib` extension that consists of bibliography entries.

**How to cite in text**:

- Use `@citationkey` to cite references in text.

- To put citations in parentheses, use `[@citationkey]`.

- To cite multiple entries, separate the keys by semicolons, e.g., `[@key-1; @key-2; @key-3]`. 

- To suppress the mention of the author, add a minus sign before `@`, e.g., `[-@citationkey]`.

| Syntax                                                       | Result                                                       |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| `@adams1975` concludes that …                                | Adams (1975) concludes that …                                |
| `@adams1975[p.33]` concludes that …                          | Adams (1975, p. 33) concludes that …                         |
| … end of sentence `[@adams1975]`.                            | … end of sentence (Adams, 1975).                             |
| `[see @adams1975,p.33]`.                                     | … end of sentence (see Adams, 1975, p. 33).                  |
| delineate multiple authors with colon: `[@adams1975; @aberdeen1958]` | delineate multiple authors with colon: (Aberdeen, 1958; Adams, 1975) |
| Check Lo and MacKinlay `[-@Lo-Mackinlay1988; -@Lo1989]` for example. | Check Lo and MacKinlay (1988, 1989) for example.             |

--------------------------------------------------------------------------------

**Add an item to bibliography without using it**

By default, the bibliography will only display items that are directly referenced in the document. 

If you want to include items in the bibliography without actually citing them in the body text, you can define a dummy `nocite` metadata field and put the citations there.

```markdown
---
nocite: |
  @item1, @item2
---
```

--------------------------------------------------------------------------------

### Bibliographies


Users may also choose to use either `natbib` (based on bibtex) or `biblatex` as a "citation package". 
In this case, the bibliographic data files need to be in the bibtex or biblatex format, and the document output format is **limited to PDF**. 

````markdown
output:
  pdf_document:
    citation_package: natbib
  bookdown::pdf_book:
    citation_package: biblatex
````

If you use matching styles (e.g., `biblio-style: apa` for `biblatex` along with `csl: apa.csl` for `pandoc-citeproc`), output to PDF and to non-PDF formats will be very similar, though not necessarily identical.

Once you have one or multiple `.bib` files, you may use the field `bibliography` in the YAML metadata of your first R Markdown document (which is typically `index.Rmd`), and you can also specify the bibliography style via `biblio-style` (this only applies to PDF output), e.g.,

````markdown
---
bibliography: ["one.bib", "another.bib", "yet-another.bib"]
biblio-style: "apalike"
link-citations: true
---
````

The field `link-citations` can be used to add hyperlinks from the citations to the bibliography entries. Defaults to `false`.

For any non-PDF output format, `pandoc-citeproc` is the only available option. If consistency across PDF and non-PDF output formats is important, use `pandoc-citeproc` throughout.

To [change the bibliography style](https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html#changing-citation-style), you will need to specify a CSL (Citation Style Language) file in the csl metadata field, e.g.,

````markdown
---
output: html_document
bibliography: references.bib  
csl: biomed-central.csl
---
````

--------------------------------------------------------------------------------

### Bibliography placement

By default, the bibliography will be placed at the end of the document. So, you will want a final header titled `# References` or `# Bibliography` at the end your document.

If you want to place the bibliography somewhere else, for instance before the appendices, you can insert a `<div id="refs"></div>` html tag in source mode:

````markdown
# References

<div id="refs"></div>

# Appendix
````

If you use the `bookdown::gitbook` output format, by default, the bibliography is split and all citation items that are cited on a given html page are put at the end of that page, so that readers do not have to navigate to a different bibliography page to see the details of citations. 

This feature can be disabled by setting the `split_bib` YAML field to `false`, in which case all citations cited in the entire report or book are put on a separate bibliography page. To do this, you can add specific keys in the YAML header:

````markdown
---
author: Research Institute for Nature and Forest
date: '2025-05-14'
site: bookdown::bookdown_site
output:
  bookdown::gitbook:
    split_by: chapter
    split_bib: false
---
````





