## Citations

For an overview of including bibliographies in your output document, you may see [Section 2.8](https://bookdown.org/yihui/bookdown/citations.html) of Xie ([2016](https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html#ref-bookdown2016)). The basic usage requires us to specify a bibliography file using the `bibliography` metadata field in YAML. For example:

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

The field `link-citations` can be used to add internal links from the citation text of the author-year style to the bibliography entry in the HTML output.

For any non-PDF output format, `pandoc-citeproc` is the only available option. If consistency across PDF and non-PDF output formats is important, use `pandoc-citeproc` throughout.

To [change the bibliography style](https://bookdown.org/yihui/rmarkdown-cookbook/bibliography.html#changing-citation-style), you will need to specify a CSL (Citation Style Language) file in the csl metadata field, e.g.,

````markdown
---
output: html_document
bibliography: references.bib  
csl: biomed-central.csl
---
````







