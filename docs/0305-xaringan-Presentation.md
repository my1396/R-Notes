## xaringan Presentation

It is a slide template based on an HTML5 presentation framework `remark.js`.

You write slides in R Markdown, and then use the `xaringan` package to render the slides.

Features:

- Interactive like html notes, but in form of slides, making it equivalent to PowerPoint, which students are more used to.

- Support the choice of Google fonts.
  
  > Quote Xie, "The best fonts are always the fonts I have never used by myself." 
  > I cannot agree more. 🤣

When you decide to use `xaringan`, read tutorials [HERE](https://bookdown.org/yihui/rmarkdown/xaringan.html).

### Render Slides

1. Render `Rmd` to `html` with `rmarkdown::render`
2. Print `html` to `pdf` with `pagedown::chrome_print`

```r
rmarkdown::render('equity_valuation.Rmd')
pagedown::chrome_print('equity_valuation.html')
```

✅ use `renderthis` package to render slides and print to pdf in one function.

```r
renderthis::to_pdf('equity_valuation.Rmd')
```

This will call `rmarkdown::render` and then `pagedown::chrome_print` automatically. Will generate `equity_valuation.html` and `equity_valuation.pdf` accordingly based on your output formats.


### Basic

- Every new slide is created under three dashes (`---`).
- The content of the slide can be arbitrary, e.g., it does not have to have a slide title, and if it does, the title can be of any level you prefer (`#`, `##`, or `###`).
- A slide can have a few properties, including `class` and `background-image`, etc. 
  
  Properties are written in the beginning of a slide, e.g.,

  ```yaml
  ---

  class: center, inverse
  background-image: url("images/cool.png")

  # A new slide

  Content.
  ```

  - The `class` property assigns class names to the HTML tag of the slide, so that you can use CSS to style specific slides.
    
    This will apply class to the whole slide.
  - `background-image`: Sets a background image for the slide.
  - `name`: Assigns a unique name to a slide, allowing for direct linking or referencing within the presentation (e.g., `slides.html#my-slide-name`).


#### Apply class inline

If you want to apply a class to just a portion of a slide, you can use the special syntax `.class[ text block ]` to format the portion. For example,

```markdown
This is a normal paragraph.
.center.inverse[ This paragraph is centered and has an inverse color scheme. ]
```

This will apply class to the paragraph only.

#### Presenter Notes

In **xaringan**, presenter notes are written with `???`.

Everything after `???` (on the same slide) will **not appear on the slide**, but will show up in presenter mode when you press `p` to toggle presenter view.

**What is the behavior of presenter mode?**

The presenter mode shows thumbnails of the current slide and the next slide on the left, presenter notes on the right (see Section [7.3.5](https://bookdown.org/yihui/rmarkdown/xaringan-format.html#xaringan-notes)), and also a timer on the top right. 

The keys `c` and `p` can be very useful when you present with your own computer connected to a second screen (such as a projector). 

On the second screen, you can show the normal slides, while **cloning the slides to your own computer** screen and using the presenter mode. 

Only you can see the presenter mode, which means only you can see presenter notes and the time, and preview the next slide. You may press `t` to restart the timer at any time.

⚠️ One thing to check: if you mirror your display instead of extending it, then the audience will see exactly what you see (including notes). To avoid this, make sure you use **extended display mode** so only you get the presenter view.


#### Parser

-   **Remark default parser** (default in xaringan):

    -   Very lightweight, fast ✅

    -   Recognizes special syntaxes like `.class[ text ]`, `--` for incremental reveals, `???` for presenter notes

    -   But **doesn't support fenced divs** `:::` or Pandoc extensions like footnotes, definition lists, etc.

-   **Pandoc parser** (when you set `markdown: pandoc` in yaml):

    -   Full Pandoc Markdown support → you can use fenced divs, footnotes, definition lists, tables with alignment, math extensions, etc.

    -   However, some **remark-specific syntaxes may stop working or behave differently**, especially:

        -   `.class[ text ]` sometimes doesn't parse as expected

        -   Indentation rules for lists and code can be stricter

        -   Incremental slides (`--`) still work, but spacing quirks can appear

        -   Raw HTML might be handled slightly differently


--------------------------------------------------------------------------------

**Tutorials:**

- R Consortium: 
  - <https://www.youtube.com/watch?v=RPFh3y9UAX4&t=1237s>
