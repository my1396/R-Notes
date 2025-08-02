## Multipanel Plot

https://felixfan.github.io/stacking-plots-same-x/

https://stackoverflow.com/questions/13649473/add-a-common-legend-for-combined-ggplots



### With Base R

`par(mfrow=c(ncol, nrow))`  to create a grid for subfigures.

`text(labels="(a)", x, y, xpd=T, ...)`  add labels to subfigures. `x` and `y` here are absolute positions. 

- Can use `grconvertX` to convert `x`-axis aboslute postions to relative positions.
- Can use `grconvertY` to convert `y`-axis aboslute postions to relative positions.

```r
# add labels to multi-panel figures
put.fig.letter <- function(label, location="topleft", x=NULL, y=NULL, 
                           offset=c(0, 0), ...) {
    # offset[1]: x-axis buffer, negative to move to the left; positive to move to the right
    # offset[2]: y-axis buffer, negative to move downward; positive to move upward
    if(length(label) > 1) {
        warning("length(label) > 1, using label[1]")
    }
    if(is.null(x) | is.null(y)) {
        coords <- switch(location,
                         topleft = c(0.015,0.98),
                         topcenter = c(0.5525,0.98),
                         topright = c(0.985, 0.98),
                         bottomleft = c(0.015, 0.02), 
                         bottomcenter = c(0.5525, 0.02), 
                         bottomright = c(0.985, 0.02),
                         c(0.015, 0.98) )
    } else {
        coords <- c(x,y)
    }
    this.x <- grconvertX(coords[1] + offset[1], from="nfc", to="user")
    this.y <- grconvertY(coords[2] + offset[2], from="nfc", to="user")
    text(labels=label[1], x=this.x, y=this.y, xpd=T, ...)
}
my.locations <- rep("topleft", 2)

f_name <- "~/Library/CloudStorage/OneDrive-Norduniversitet/FIN5005 2024Fall/OLS lab/images/diagnostic_plot3.png"
# ggsave(f_name)
f_name
png(f_name, width=8.91*ppi, height=4.85*ppi, res=ppi)
par(mfrow=c(1,2))
plot(fit.auto2, 1)
put.fig.letter(label="(a)", location=my.locations[1], font=2, offset = c(0.1, -0.1))
plot(fit.auto2, 2)
put.fig.letter(label="(b)", location=my.locations[2], font=2, offset = c(0.1, -0.1))
dev.off()
```





**plots alignment**

`grid::grid.draw(x)` 	draw a grid grob

-   `x` 	 An object of class `"grob"` or NULL.

```R
grid::grid.draw(rbind(ggplotGrob(CI_plot_converted), 
                      ggplotGrob(CI_plot_simple), 
                size = "last")) # same width, same height

# or
gridExtra::grid.arrange(CI_plot_converted, CI_plot_simple, ncol=1, heights = c(0.8, 1))
```



### With `cowplot` package

**`cowplot::plot_grid(p1, p2, p3,
           align = 'vh',
           labels = c("A", "B", "C"),
           hjust = -1,
           nrow = 1)`** Arrange multiple plots into a grid.



`plot_grid(..., plotlist = NULL, align = c("none", "h", "v", "hv"),
  axis = c("none", "l", "r", "t", "b", "lr", "tb", "tblr"),
  nrow = NULL, ncol = NULL, rel_widths = 1, rel_heights = 1,
  labels = NULL, label_size = 14, label_fontfamily = NULL,
  label_fontface = "bold", label_colour = NULL, label_x = 0,
  label_y = 1, hjust = -0.5, vjust = 1.5, scale = 1,
  greedy = TRUE)`

- `...` 	Plots to be arranged into the grid, separated by comma, e.g., `plot_grid(p1, p2, ...)`.

- `plotlist`   A `list` of plots to display. Alternatively, the plots can be provided individually as the first n arguments of the function `plot_grid`.

  ```r
  p_list <- list()
  p_list[[1]] <- p1
  p_list[[2]] <- p2
  plot_grid(plotlist = p_list)
  ```

- `align`     how graphs in the grids should be aligned.

  - `h`    horizontally
  - `v`    vertically 
  - `hv`   both horizontally and vertically 
  - `none` default

- `rel_widths`, `rel_heights`   Numerical vector of relative columns widths. For example, in a two-column grid, `rel_widths = c(2, 1)` would make the first column twice as wide as the second column.

- `labels`   List of labels to be added to the plots. You can also set `labels="AUTO"` to auto-generate **upper-case** labels or `labels="auto"` to auto-generate **lower-case** labels.

  - `labels=sprintf("(%s)", letters[1:6])`   lower-case letters with parentheses.

- <span style="color:#008B45'">`label_size`</span>     lable font size;

- <span style="color:#008B45'">`hjust`</span>     left: positive, right: negative; (label position)

- `vjust`     down: positive, up: negative;

  ​    

```R
# load cowplot
library(cowplot)

# down-sampled diamonds data set
dsamp <- diamonds[sample(nrow(diamonds), 1000), ]

# Make three plots.
# We set left and right margins to 0 to remove unnecessary spacing in the
# final plot arrangement.
# plot.margin = unit(c(top, right, bottom, left), "pt") for outer margins of plotting area
p1 <- qplot(carat, price, data=dsamp, colour=clarity) +
   theme(plot.margin = unit(c(6,0,6,0), "pt"))
p2 <- qplot(depth, price, data=dsamp, colour=clarity) +
   theme(plot.margin = unit(c(6,0,6,0), "pt")) + ylab("")
p3 <- qplot(color, price, data=dsamp, colour=clarity) +
   theme(plot.margin = unit(c(6,0,6,0), "pt")) + ylab("")

# arrange the three plots in a single row
prow <- plot_grid( p1 + theme(legend.position="none"),
           p2 + theme(legend.position="none"),
           p3 + theme(legend.position="none"),
           align = 'vh',
           labels = sprintf("(%s)", letters[1:3]), # auto lower case letter for labels
           label_size = 14, # label font size
           hjust=0,  # left: positive, right: negative (adjust label position)
           vjust=-1, # down:positive, up:negative
           nrow = 1
           )

# extract the legend from one of the plots
# (clearly the whole thing only makes sense if all plots
# have the same legend, so we can arbitrarily pick one.)
legend_b <- get_legend(p1 + theme(legend.position="bottom"))

# add the legend underneath the row we made earlier. Give it 10% of the height
# of one plot (via rel_heights).
p <- plot_grid( prow, legend_b, ncol = 1, rel_heights = c(1, .1))
p
```

Iregular girds can be created using nested `plot_grid`

For instance, the first plot is narrower than the second plot, you can create a buffer for the first plot.

```r
# the first figure is half the width of the second figure
plot_grid(plot_grid(p_hist, NULL, nrow=1, rel_widths = c(1,1)),
          p_map_diff + theme(plot.margin = margin(0,0,0,0)),
          nrow=2,
          rel_heights = c(1, 1.2),
          labels=sprintf("(%s)", letters[1:4]), 
          label_size=12)
```

<img src="https://drive.google.com/thumbnail?id=1VflWZmC0mH8bbZSMR8Yt18gAev1uGRFN&sz=w1000" alt="Iregular grid" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

