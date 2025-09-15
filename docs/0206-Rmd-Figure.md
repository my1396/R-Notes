## Figures

The idea is to generate the figure, output to local, then reload using the following code. 

~~~~markdown
```{r car-plot, eval=TRUE, echo=FALSE, out.width="80%", fig.cap="Caption here." }
knitr::include_graphics(img1_path) 
```
~~~~

Use code chunk label to cross reference, e.g., <span style='color:#00CC66'>`Fig. \@ref(fig:car-plot)`</span>. 

- Note that you must specify <span class="env-green">`fig.cap`</span> to enable labeling and cross references. Otherwise, the cross reference will show `Fig. ??`.
- In you cross reference, note that there is <span class="env-orange">no space</span> between `fig:` and `car-plot`.
- `knitr::include_graphics` supports web url for html output, but NOT for latex output.


Alternatively, use `fig.width` to fix the figure width, and `fig.asp` to fix the aspect ratio (height:width).

~~~~markdown
```{r car-plot2, fig.width=6, fig.asp=0.6, fig.cap="Caption here." }
library(AER)
data(CASchools)
library(ggplot2)
ggplot(CASchools, aes(x = expenditure)) +
  geom_histogram(binwidth = 500, fill = "lightblue", color = "black") +
  labs(title = "Histogram of Expenditure per Student",
       x = "Expenditure per Student (USD)",
       y = "Frequency") +
  theme_minimal(base_size = 14)
```
~~~~


<div class="figure">
<img src="0206-Rmd-Figure_files/figure-html/histogram-1.png" alt="Historgram of Expenditure per Student. Fixed `fig.width` and `fig.asp`." width="576" />
<p class="caption">(\#fig:histogram)Historgram of Expenditure per Student. Fixed `fig.width` and `fig.asp`.</p>
</div>

--------------------------------------------------------------------------------

### Output directly to document


- You can let the code output to document directly, i.e., not generating a file and reload. 

    But in this case, scale the figure will change the plot text too. The text might be scaled unexpectedly too small/large. Just be careful with it.

Load data.


``` r
library(quantmod)
aapl <- getSymbols("AAPL", 
           src = 'yahoo', 
           from = "2014-08-01", 
           to = "2024-09-17",   
           auto.assign = FALSE
           )
```


--------------------------------------------------------------------------------

`out.width="50%"`

~~~~markdown
```{r out.width="50%", fig.asp = 0.62, fig.cap="`out.width=\"50%\"`, fig.asp set to 0.62."}
# plot text is scaled too
plot(aapl$AAPL.Close)
```
~~~~


<div class="figure">
<img src="0206-Rmd-Figure_files/figure-html/unnamed-chunk-2-1.png" alt="`out.width`=50%, fig.asp set to 0.62. Note that text font scales too, hard to read.test" width="50%" />
<p class="caption">(\#fig:unnamed-chunk-2)`out.width`=50%, fig.asp set to 0.62. Note that text font scales too, hard to read.test</p>
</div>



--------------------------------------------------------------------------------


`out.width="100%"`

~~~~markdown
```{r out.width="100%", fig.asp = 0.6, fig.cap="`out.width=\"100%\"`."}
plot(aapl$AAPL.Close)
```
~~~~

<div class="figure">
<img src="0206-Rmd-Figure_files/figure-html/unnamed-chunk-3-1.png" alt="`out.width`=100%, fig.asp set to 0.6. Note that the plot text got zoomed too, can be too large." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-3)`out.width`=100%, fig.asp set to 0.6. Note that the plot text got zoomed too, can be too large.</p>
</div>

--------------------------------------------------------------------------------

### Fixed `fig.width`

- Text does NOT scale with figure size; visibility is good. ✅

~~~~markdown
```{r fig.width=6, fig.asp=0.6}
# Text font does NOT scale, but figure title got cropped
plot(aapl$AAPL.Close)
```
~~~~

<div class="figure">
<img src="0206-Rmd-Figure_files/figure-html/unnamed-chunk-4-1.png" alt="Set `fig.width`. Note that text font does NOT scale with figure, BUT the figure title got cropped." width="480" />
<p class="caption">(\#fig:unnamed-chunk-4)Set `fig.width`. Note that text font does NOT scale with figure, BUT the figure title got cropped.</p>
</div>



--------------------------------------------------------------------------------

### Save and reload

This approach preserves your preference better, maintains the relative size of your figure and the text. 

No cropping, no fuss.


``` r
f_name <- "images/aapl.png"
png(f_name, width=2594, height=1600, res=300)
plot(aapl$AAPL.Close)
invisible(dev.off())
```

~~~~markdown
```{r out.width="50%", fig.cap="include_graphics with `out.width`=50%."}
knitr::include_graphics(f_name) 
```
~~~~

<div class="figure">
<img src="images/aapl.png" alt="include_graphics with `out.width`=50%." width="50%" />
<p class="caption">(\#fig:unnamed-chunk-6)include_graphics with `out.width`=50%.</p>
</div>

--------------------------------------------------------------------------------

~~~~markdown
```{r out.width="100%", fig.cap="include_graphics with `out.width`=100%." }
knitr::include_graphics(f_name) 
```
~~~~

<div class="figure">
<img src="images/aapl.png" alt="include_graphics with `out.width`=100%." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-7)include_graphics with `out.width`=100%.</p>
</div>


--------------------------------------------------------------------------------

Q: How to suppress the following `dev.off()` messages generated by code chunks in `Rmd`? 

```r
## quartz_off_screen 
##                 2
```

A: Enclose `dev.off()` within `invisible()`, or dump the result of `dev.off()` to a garbage variable. 

```r
invisible(dev.off())     # opt1
whatever <- dev.off()    # opt2
```

--------------------------------------------------------------------------------

### Control figure size

Specify code chunk options `fig.width` and `fig.height` for <span class="env-green">R-generated figures only</span>.

- Default is `fig.width = 7` and `fig.height = 5` (<span class="env-green">**in inches**</span>, though actual width will depend on screen resolution). Remember that these settings will default to `rmarkdown` values, not `knitr` values.
- If don't know what size is suitable, can right-click the Plots Viewer and choose "Copy Image Address". Scale by `/100` (in inches) and fill the values to chunk options.

--------------------------------------------------------------------------------

### Control output size

`out.width` and `out.height` apply to both <span class="env-green">existing images and R-generated figures</span>.

- Note that the percentage need to be put in **quotes**.

- <span class="env-green">`fig.width` do NOT scale font</span>, it shows the original font size. Suggest to use this one. ✅

- <span class="env-orange">`out.width` scales the whole figure.</span> If you want to fix aspect ratio, setting `fig.asp=0.6` will set height:width = 6:10.
    
    - `out.width` keeps the original aspect ratio of the figure and scale the text in the figure too.
    
        But what most people want is to scale the figure but NOT the text. For instance, you want to scale your figure to 70\% width of page, but you want to keep the original size of text so it is readable.
        
    - A caveat with `out.width`is that the <span class="env-orange">axis labels and ticks will be so small</span> and hard to read.


**Difference between figure size and output size**

We are allowed to specify the figure size, and secondly the size of the figure as to appear in the output. For example, if you set the size of a `ggplot` figure to large, then fonts etc. will appear tiny. Better do *not* scale up `fig.height`, but set `out.width` accordingly, eg., like this `out.width = "70%"`.

--------------------------------------------------------------------------------

Other chunk options related to figures:

`fig.cap = NULL` specify figure captions. 

- <span class="env-green">Must provide `fig.cap` if you need to cross reference the figure.</span>

Use code chunk label to cross reference, e.g., see <span style='color:#00CC66'>`Fig. \@ref(fig:car-plot)`</span>. 

- The chunk label (`car-plot`) provides the identifier for referencing the figure generated by the chunk.

- Tip: `Fig.&nbsp;\@ref(fig:logit-regression)` use `&nbsp;` to insert a <span style='color:#00CC66'>non-breaking space</span> to avoid line breaking between `Fig.` and numbering.

<span style='color:#00CC66'>`fig.align = "center"`</span> to set figure alignment. 

- Possible values are `default`, `left`, `right`, and `center`. The default is not to make any alignment adjustments.
- For bookdown, the default is to left align figures.

`fig.pos = "H"` fix placement.

<span style='color:#00CC66'>`fig.asp = 0.6`</span> aspect ratio height:width=6:10.

See [HERE](https://yihui.org/knitr/options/#plots) for a full list of chunk options related to figures.

--------------------------------------------------------------------------------


<span style='color:#00CC66'>**Suggested practice**</span> so that you have correct aspect ratio and automatically scaled text and labels in figures. ✅

1. Generate the figure and save to local

   The benefit is that you have full control to adjust the figure as needed, such as font size, and could reuse it later.

   ````markdown
   ```{r echo=FALSE, include=FALSE}
   p <- ggplot(contingency_table %>% 
              as_tibble() %>% 
              mutate(chd69=factor(chd69, levels=c("non-developed", "developed"))), 
          aes(x=smoke, y=n, fill=chd69)) +
       geom_bar(position="stack", stat="identity", color="black", linewidth=0.1) + 
       scale_fill_grey(start=0.88, end=0.7) +
       labs(y="Frequency") +
       theme(axis.title.x = element_blank(), legend.position = "bottom")
   f_name <- "images/stacked_bar.png"
   plot_png(p, f_name, 5.17, 5)
   ```
   ````

   Specify chunk options <span style='color:#00CC66'>`include=FALSE`</span> (Do not include code output) to suppress the graphic window information like the following.

   ```r
   ## quartz_off_screen 
   ##                 2
   ```

2. Add the figure using 

   ````markdown
   ```{r scatter-plot, echo=FALSE, fig.cap="Scatter plot of avearge wage against experience.", out.width = "80%"}
   include_graphics(f_name)
   ```
   ````

3. Cross reference 

   - `pdf_document`: using `\autoref{fig:scatter-plot}` from `hyperref` package or `Fig. \ref{fig:scatter-plot}` from base latex.

     `hyperref` uses `Figure`, could be changed to `Fig.` by putting the following cmd at the begin of the Rmd.

     ```latex
     \renewcommand\figureautorefname{Fig.}
     ```

   - `bookdown::html_document2`: using `\@ref(fig:scatter-plot)`.

--------------------------------------------------------------------------------

### Latex symbols in Fig. caption {.unnumbered}

**The R code block approach.**

- `\\Phi` works. You need to escape the `\` in `\Phi` .
- If there are quotation marks (`"`) in the figure caption, need to escape them using `\"...\"` to distinguish from the outer quotes of the caption parameter.
- You can use regular Markdown syntax in Fig captions, such as using `**Bold**` to make text bold.
- <span style='color:#00CC66'>Better to use R code blocks to include figures.</span> 

    Note that `include_graphics("https://link-to-Google-drive")` <span style='color:#FF9900'>does NOT work for pdf output</span>. Works for html output though.

    If using html tag `<figure>`, the numbering will be messed up. There is only automatic numbering with R code figures.

    Use example:
    
    ````markdown
    ```{r fig.cap="The $\\Phi$ and $\\phi$ ($f_Z(.)$) functions (CDF and pdf of standard normal).", out.width="70%", echo=FALSE}
    include_graphics("images/Phi_b.png")
    ```
    ````
    
    Will generate the following Fig \@ref(fig:fig1).
    
    <div class="figure">
    <img src="images/Phi_b.png" alt="The $\Phi$ and $\phi$ ($f_Z(.)$) functions (CDF and pdf of standard normal)." width="70%" />
    <p class="caption">(\#fig:fig1)The $\Phi$ and $\phi$ ($f_Z(.)$) functions (CDF and pdf of standard normal).</p>
    </div>


Alternatively, use **the HTML approach**, and enclose the caption inside `<figcaption>`. 
  
- Benefit: You can type equations as you normally do. Don't need to escape backslashes as using the R code blocks in the example above. 
- <span style='color:#FF9900'>Drawback: You need to manually add figure numbering.</span> 

❗️That means, when you change the order of sections or figures in your webpage, the numbering will be a mess. You need to change all capitals manually.

```html
<figure> 
<img src="https://drive.google.com/thumbnail?id=1nxfdIKXgZvOqXVSeA3h_hf0yxmsM361l&sz=w1000" alt="Phi_b" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />
<figcaption>Fig.1 The $\Phi$ and $\phi$ ($f_Z(.)$) functions (CDF and pdf of standard normal).</figcaption>
</figure>
```

<figure> 
<img src="https://drive.google.com/thumbnail?id=1nxfdIKXgZvOqXVSeA3h_hf0yxmsM361l&sz=w1000" alt="Phi_b" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />
<figcaption>Fig.1 The $\Phi$ and $\phi$ ($f_Z(.)$) functions (CDF and pdf of standard normal).</figcaption>
</figure>

--------------------------------------------------------------------------------

### Refer to another figure in figure caption {.unnumbered}

Just need to use double backslash  `\\@ref(fig:xxx)` in the figure caption.

Use example:

We first generate the figure to be referenced.

````markdown
```{r firstplot, out.width="60%", fig.cap="Source Figure to be referred to."}
library(ggplot2)
p <- ggplot(mtcars, aes(wt, mpg))
plot_A <- p + geom_point()
plot_A
```
````
<br>

<div class="figure">
<img src="0206-Rmd-Figure_files/figure-html/firstplot-1.png" alt="Source Figure to be referenced. **Note that when specifying `out.width=60%`, the text in the figure is scaled too small.**" width="60%" />
<p class="caption">(\#fig:firstplot)Source Figure to be referenced. **Note that when specifying `out.width=60%`, the text in the figure is scaled too small.**</p>
</div>

Now a second plot with a reference to Fig.: \@ref(fig:firstplot).

````markdown
```{r secondplot, fig.cap = "This is the same as Fig.: \\@ref(fig:firstplot) but now with a red line." }
plot_A + geom_line(alpha = .75,col = "red")
```
````

<br>

<div class="figure">
<img src="0206-Rmd-Figure_files/figure-html/secondplot-1.png" alt="This is the same as Fig.: \@ref(fig:firstplot) but now with a red line and `out.width=100%`." width="672" />
<p class="caption">(\#fig:secondplot)This is the same as Fig.: \@ref(fig:firstplot) but now with a red line and `out.width=100%`.</p>
</div>






