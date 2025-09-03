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

If you want to apply a class to just a portion of a slide, you can use the special syntax `.className[ text block ]` to format the portion. For example,

```markdown
This is a normal paragraph.
.center.inverse[ This paragraph is centered and has an inverse color scheme. ]
```

This will apply class to the paragraph only.

- The content inside `[ ]` can be anything, such as several paragraphs, or lists.

- You can design your own content classes if you know CSS, e.g., if you want to make text red via `.red[ ]`, you may define this in CSS:

  ```css
  .red { color: red; }
  ```

### Math Environments

Display math enclosed in double dollar signs, but note that

- the environment should not appear <span class="env-green">on separate lines</span>
- <span class="env-orange">No space</span> between `$$` and the math content

```markdown

This won't work:
$$
E = mc^2
$$

This will work:
$$E = mc^2$$
```


#### Presenter Notes

Q: Why using presenter notes? 

A: A common mistake in presentations, especially for presenters without much experience, is to stuff a slide with too much content. The consequence is either a speaker, out of breath, reading the so many words out loud, or the audience starting to read the slides quietly by themselves without listening. Slides are not papers or books, so you should try to be brief in the visual content of slides but verbose in verbal narratives. If you have a lot to say about a slide, but cannot remember everything, you may consider using presenter notes.

--------------------------------------------------------------------------------

Q: How to add presenter notes in xaringan?

A: In **xaringan**, presenter notes are written with `???`.

Everything after `???` (on the same slide) will **not appear on the slide**, but will show up in presenter mode when you press `p` to toggle presenter view.

```yaml
---

The holy passion of Friendship is of so sweet and steady
and loyal and enduring a nature that it will last through
a whole lifetime...

???
This is notes for presenter only.
```

--------------------------------------------------------------------------------

Q: **What is the behavior of presenter mode?**

A: The presenter mode shows thumbnails of the current slide and the next slide on the left, presenter notes on the right (see Section [7.3.5](https://bookdown.org/yihui/rmarkdown/xaringan-format.html#xaringan-notes)), and also a timer on the top right. 

The keys `c` and `p` can be very useful when you present with your own computer connected to a second screen (such as a projector). 

On the second screen, you can show the normal slides, while **cloning the slides to your own computer** screen and using the presenter mode. 

Only you can see the presenter mode, which means only you can see presenter notes and the time, and preview the next slide. You may press `t` to restart the timer at any time.

⚠️ One thing to check: if you mirror your display instead of extending it, then the audience will see exactly what you see (including notes). To avoid this, make sure you use **extended display mode** so only you get the presenter view.

The figure below shows the **Displays** settings on macOS for extended display mode.

- Do not check the box “Mirror Displays”.
- Instead, separate the two displays, so you can drag the window with the normal view of slides to the second screen.

<img src="https://bookdown.org/yihui/rmarkdown/images/mirror-display.png" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

Ref: [R Markdown: The Definitive Guide, Section 7.3.5](https://bookdown.org/yihui/rmarkdown/xaringan-format.html#xaringan-notes)

#### CSS and themes

The format `xaringan::moon_reader` has a `css` option, to which you can pass a vector of CSS file paths, e.g.,

```yaml
---
output:
  xaringan::moon_reader:
    css:["default","extra.css"]
---
```

- The file path should contain the extension `.css`. If a path does not contain a filename extension, it is assumed to be a built-in CSS file in the `xaringan` package.
- To see all built-in CSS files, call `xaringan:::list_css()` in R.
  ```r
  xaringan:::list_css() # print path of built-in CSS files
  names(xaringan:::list_css()) # print names only
  ```
- When you only want to override a few CSS rules in the default theme, you do not have to copy the whole file `default.css`; instead, create a new (and hopefully smaller) CSS file that only provides new CSS rules.
- Users have contributed a few themes to `xaringan`. For example, you can use the `metropolis` theme (<https://github.com/pat-s/xaringan-metropolis>):


Read [R Markdown: The Definitive Guide, Section 7.5](https://bookdown.org/yihui/rmarkdown/css-and-themes.html) for more details about CSS and themes.


#### Working offline

Making the slides work offline can be tricky, since you may have other dependencies. For example, if you used Google web fonts in slides (the default theme uses *Yanone Kaffeesatz*, *Droid Serif*, and *Source Code Pro*), they will not work offline unless you download or install them locally.

To make slides work offline, you need to download a copy of remark.js in advance, because `xaringan` uses the online version by default. 

Refer to [R Markdown: The Definitive Guide, Section 7.6.4](https://bookdown.org/yihui/rmarkdown/some-tips.html#working-offline) for details.


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
