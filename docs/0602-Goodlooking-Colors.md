## Goodlooking Colors

色相-饱和度-亮度 (HSL)

颜色的三大基本属性是：

1. **色相 (Hue):** 什么颜色
   
   表示颜色的种类，是我们通常所说的“红色、黄色、蓝色”等。例如红色和绿色属于不同的色相。色相是由光的波长决定的。

2. **饱和度 (Saturation / chroma / colorfulness):** 颜色有多“纯”或多“灰”
   
   又称**纯度**或**艳度**，描述颜色的鲜艳程度。饱和度越高，颜色越鲜明；饱和度越低，颜色越灰暗、偏向无彩色（如灰色）。

3. **明度 (Brightness / Lightness / Value):** 颜色是亮还是暗
   
   表示颜色的明亮程度。明度高的颜色看起来更接近白色，明度低的颜色看起来更接近黑色。
 
**HSC** (Hue-Saturation-Value) is a simple transformation of the RGB (red-green-blue) space. However, HSV colors capture the perceptual properties hue, colorfulness / saturation / chroma, and lightness / brightness / luminance/ value only <span style='color:#FF4C4C; font-style:italic;'>poorly</span> and consequently the corresponding palettes are typically <span style='color:#FF4C4C; font-style:italic;'>not</span> a good choice for statistical graphics and data visualization. [EndRainbow](http://colorspace.r-forge.r-project.org/articles/endrainbow.html).

**HCL** (Hue-Chroma-Luminance) color space is believed to accords with human perception of color. HCL are <span style='color:#008B45'>*much more suitable*</span> for capturing human color perception. ✅


--------------------------------------------------------------------------------

**Color picking guidelines:**

- Recoloring primary data, such as fluorescence images (避免使用荧光色), to color-safe combinations such as green and magenta, turquoise and red, yellow and blue or other accessible color palettes is strongly encouraged. 

- Use of the rainbow color scale should be avoided.

**Other figure guidelines**

- Figures divided into parts should be labeled with a lower-case, boldface 'a', 'b', etc in the top-left corner. 
- Labeling of axes, keys and so on should be in 'sentence case' (first word capitalized only) with no full stop. 
- Units must have a space between the number and the unit, and follow the nomenclature common to your field.
- Commas should be used to separate thousands.

--------------------------------------------------------------------------------

**Resources to find your preferred colors:**

- [HTML color names](https://www.rapidtables.com/web/color/html-color-codes.html)

- Preview color palettes: 
  - <http://colrd.com/palette/19002/>
  - [my color space](https://mycolor.space/?hex=%23FFFF54&sub=1): recommended, good for generating color **palettes**

- Color picker tools:
  - [System Color Picker](https://apps.apple.com/us/app/system-color-picker/id1545870783?mt=12) (Mac): Pick colors from anywhere using the built-in color picker.
  - If you don't want to install additional app, you can use this [website](https://redketchup.io/color-picker), it allows you to upload an image and choose color from.

- Preview of [classes of colormaps](https://matplotlib.org/stable/tutorials/colors/colormaps.html): 
  - Sequential: use a single hue (单一色相); the lightness and saturation value increases monotonically (亮度 饱和度); used for ordered data.
  - **Diverging**: use two contrasting hues (对比色); the lightness and saturation value increases monotonically from the center to the edges; used for data with a meaningful center point, such as topography or when the data deviates around zero. 
  - Cyclic: start and end on the same color, and meet a symmetric center point in the middle; should be used for values that wrap around at the endpoints, such as phase angle, wind direction, or time of day.
  - Qualitative: often are miscellaneous colors; should be used to represent information which does not have ordering or relationships.



- Verify readability of colors. 
  
  Colors should stand out (large contrast ratio), but not be too harsh on the eyes.
  - [Check WVAG contrast ratio](https://webaim.org/resources/contrastchecker/)
  - Check the [notion icon colors](https://notionicons.so/icon-set/atlas) on both light and dark background


**Note** that some times you need to convert colors from one format to another, e.g., from hexadecimal to RGB or vice versa. Use the **Color conversion** tool:
<https://convertingcolors.com/hex-color-E4E5E5.html?search=#e4e5e5>

--------------------------------------------------------------------------------

**Color exploration web**:

HTML color codes: <https://htmlcolorcodes.com/color-chart/>

- [Picker](https://htmlcolorcodes.com/color-picker/): can used to generate color palette given a start point using the following approaches. 可根据需要产生不同的色板。

  - complementary colors / 互补色

    色轮上相对的颜色（例如红色和绿色），并列使用时会产生强烈对比。

    <img src="https://drive.google.com/thumbnail?id=1JIMcvcqT-Sn6fAw-1gzol6_oHV2qaOfJ&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

  - Triadic Colors / 三元色

    在色轮上等间距分布的三种颜色（如红、黄、蓝），既有对比也有协调感。

    <img src="https://drive.google.com/thumbnail?id=1NRSYb1uY2NGq6R474x699D3rOfhmyChF&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

  - Tetradic Colors / 四方色 (双互补色)

    两组互补色组成的配色方案（如红+绿 和 蓝+橙），颜色丰富，层次感强。

    <img src="https://drive.google.com/thumbnail?id=1xtPtfB9Gnq-CDpRRiyJkrXXF31EkrQG0&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

  - Analogous Colors / 类似色

    类似色是色轮上相邻的颜色（如蓝、蓝绿、绿），配色感觉和谐柔和。

    <img src="https://drive.google.com/thumbnail?id=1ZAMYFCDPA6ClAqI1YDBd7DokeYJR5mJ4&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

  - Neutral Colors / 中性色

    Neutral schemes, like analogous harmonies, are formed by taking the colors on either side of a chosen color but at half the distance. While analogous schemes typically use colors 30 degrees apart, neutral harmonies use colors 15 degrees apart.

  - Tones / 色调

    色调是将颜色与**灰色**（黑色和白色混合）混合后得到的颜色，使原色变得柔和。

    <img src="https://drive.google.com/thumbnail?id=1_6z1SAeZTzXbQvhxh-sA1GA5FDC6x-Ce&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

  - Shades / 暗色 (加黑)

    A shade is a color mixed with **black**, making it darker.

    <img src="https://drive.google.com/thumbnail?id=1r-xZimLkbwlvKjS4oPy9Gl8tUMe8hXPd&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

  - Tints / 浅色 (加白)

    A tint is a color mixed with **white**, making it lighter.

    <img src="https://drive.google.com/thumbnail?id=1UpyrMYA-sRTnQiOg27O1o2KzWYVe9l6W&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:30%;" />

- [Chart](https://htmlcolorcodes.com/color-chart/): flat design color chart [standard colors]

- [HTML Color Names](https://htmlcolorcodes.com/color-names/)


### Color models

**hexadecimal color – RGB**

<span style='color:#0099FF'>*Hexadecimal*</span>  is a base-16 number system used to describe color. **Red, green, and blue are each represented by two characters** (`#rrggbb`), start with `#`. Each character has 16 possible symbols: 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F:

> i.e., red= #FF0000 , black=#000000, white = #FFFFFF

- The RGB is given as coordinates, for example, `rgb(red, green, blue)`. 

  The three different numbers in the RGB code is what determines the intensity of each of the colours red, green, and blue. The range of the intensity goes from 0 to 255.

- RGBA color values are an extension of RGB color values with an Alpha channel - which specifies the opacity for a color, e.g., `rgb(red, green, blue, alpha)`. 

  The **alpha** parameter is a number between 0.0 (fully transparent) and 1.0 (not transparent at all).

  Sometimes you see **opaque** used to denote transparency. Opacity is the opposite of transparency, 1 means opaque (完全不透明), 0 means transparent (完全透明).

- The hex-colour is written with `#` and then a 6-digit code combining letters and numbers, e.g., `#RRGGBB`.

  It is a <u>short code for RGB color</u>. The first two numbers represent red, the middle two represent green, and the last two represent blue. Each can take values from `00` to `FF`, which is 0 to 255 in decimal.

  Sometimes you encounter 8-digit code, e.g., `#RRGGBBAA`. `AA` represents the alpha channel for transparency; takes value from `00` (full transparency, invisible) to `FF` (fully opaque, completely solid). Anything in between is semi-transparent.

### Base R functions to specify colors

`RGB (red, green, blue)`: The default intensity scale in R ranges from 0-1; but another commonly used scale is 0–255. `alpha` decides transparency.

> rgb(r, g, b, maxColorValue=255, alpha=255)



`grDevices` comes with the *base* installation and `colorRamps` must be installed. Each palette’s function has an argument for the number of colors and transparency (alpha):

```r
heat.colors(4, alpha=1)
```

<span style='color:red'>**`grDevices` palettes**</span>: `cm.colors`, `topo.colors`, `terrain.colors`, `heat.colors`, `rainbow`.


**`colorRampPalette(colors)`** 	returns functions that **interpolate a set of given colors** to create new color palettes (like `topo.colors`) and color ramps.

```R
cls <- colorRampPalette(c("black","red","yellow","white"))
levelplot(globalRAD[,,timeLayer], row.values=lonVec, column.values=latVec,
main=paste("predicted radiation:",timeVals[timeLayer]), ylab="latitude",xlab="longitude", col.regions=cls(256), cuts=255, at=seq(0,450,length.out=256))
```



`palette()` 8 colors available in base R, col=1:8 responds to `palette()[1:8]`

```r
palette() # obtain the current palette
palette(rainbow(6)) # six color rainbow
palette("default") # reset back to the default
```

An example:

```r
# set a palette of your choice
palette(gray(seq(0,.9,len = 25))) # gray scales; print old palette
# then you can use color by numeric vector to access colors in your palette
matplot(outer(1:100, 1:30), type = "l", lty = 1,lwd = 2, col = 1:30,
        main = "Gray Scales Palette",
        sub = "palette(gray(seq(0, .9, len=25)))")
palette("default")      # reset back to the default
```



--------------------------------------------------------------------------------

**Commonly used colors:**

\#FF0099 - 255, 0, 153 - <span style='color:#FF0099'>PinkPurple</span>
\#FF9900 - 255, 153, 0 - <span style='color:#FF9900'>OrangeYellow</span>
\#66CC00 - 102, 204, 0 - <span style='color:#66CC00'>GreenBlue</span>

\#9900FF - 153, 0, 255 - <span style='color:#9900FF'>PurpleViolet</span>
\#0099FF - 0, 153, 255 - <span style='color:#0099FF'>BlueCyan</span>
\#008B45 - 0, 204, 102 - <span style='color:#008B45'>BlueGreen</span>

\#008B45FF  <span style='color:#008B45FF'>DarkGreen</span> Good on light, not good on dark theme

\#337ab7 <span style='color:#337ab7'>DarkBlue</span> Good on light, not good on dark theme

Two series:  `c('darkred', 'steelblue2')`; <span style='color:#0099FF'>**`c("#00BFC4","#F8766D")`**</span>, `#00BFC4` is bluish, `#F8766D` is coral.

Three lines: `c('green','blue','red')` 

Five lines: `c('black', 'magenta', 'blue', 'cyan', 'red')`	 (cyan is a greenish-blue color)

```r
# palette() get the current color palette
# insert() insert colors at certain positions
colvec <- R.utils::insert(palette(), 6, c('steelblue','steelblue2'))
colvec <- insert(colvec, 3, 'darkred')
colvec
plot(1:length(colvec), 1:length(colvec), pch=19, col=colvec)
```



```R
cols <- c("precip.cru"="#00BFC4", "precip.udel"="#F8766D")
labels <- c("precip.cru.#00BFC4", "precip.udel.#F8766D")
p_global <- ggplot(global_data_plot, aes(x=year, y=value, col=variable)) +
    geom_line() +
    labs(y=pre_label) +
    scale_color_manual(values=cols, labels = labels) +
    theme(legend.position = c(0.12, 0.9),
          legend.title = element_blank() )
```



<img src="https://drive.google.com/thumbnail?id=1QYdo3syeBzt0Nj5QCbfknN3ZAX6gviZ9&sz=w1000" alt="col" style="zoom:80%;" />




### `colorspace` Package

`colorspace::hcl_palettes()` retrieve all available palettes names.

<img src="https://drive.google.com/thumbnail?id=1Q0d1zuXmDl-g-AxJSj8WCKDtOcybfQq4&sz=w1000" alt="hcl" style="display: block; margin-right: auto; margin-left: auto; zoom:100%;" />

Useful functions to choose palette:

* `pal <- colorspace::choose_palette(gui='shiny')` will give you an GUI interface to choose colors manually.

* `colvec <- colorspace::rainbow_hcl(5)` automatically choose 5 colors from `rainbow` palette. 

`colorspace` provides 4 types of color palettes: qualitative, sequential single-hue, sequential multi-hue, diverging. Use `sequential_hcl()`, and `diverging_hcl()` to choose palettes. 

- can use `colorspace` palette names to specify colors in `ggplot`.

  ```r
  library("ggplot2")
  ggplot(iris, aes(x = Sepal.Length, fill = Species)) + geom_density(alpha = 0.6) +
    scale_fill_discrete_qualitative(palette = "Dark 3")
  ```

- use `hcl_palettes(palette="Blue-Yellow", plot=TRUE, n=5)` to plot the color palette. Use  `diverge_hcl(n=5, palette="Blue-Yellow")` to print the colors names.

  ```r
  > diverge_hcl(5, "Blue-Yellow")
  [1] "#4F53B7" "#AAABD5" "#F1F1F1" "#B5AF80" "#6B6100"
  > hcl_palettes(palette="Blue-Yellow", plot=TRUE, n=5)
  ```

  <img src="https://drive.google.com/thumbnail?id=1XuVukxdT9aypctjiXlaS6fqBHIQ7YGR6&sz=w1000" alt="color palette" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

- use `scales::show_col(colours)` to preview colors.

  ```r
  sequential_hcl(5, "Blue-Yellow")
  # [1] "#26A63A" "#9BB306" "#E1BB4E" "#FFC59E" "#F1F1F1"
  sequential_hcl(5, "Terrain") %>% show_col()
  ```

  <img src="https://drive.google.com/thumbnail?id=1KRn8UVpsUhRwMdWNB9oNAISj3gNkfjV2&sz=w1000" alt="color palette" style="display: block; margin-right: auto; margin-left: auto; zoom:100%;" />



`ggplot()` color space, `scale_colour_manual` and  `scale_colour_gradient`.

**`ggplot_build()`** takes the plot object, and performs all steps necessary to produce an object that can be rendered. This function outputs two pieces: a list of data frames (one for each layer), and a panel object, which contain all information about axis limits, breaks etc.


```r
# get color scheme/palettes used in ggplot figure
p_data <- ggplot2::ggplot_build(p)$data[[1]]
mask <- !colnames(p_data) %in% c('x', 'y')
p_color <- p_data[,mask] %>% distinct
> p_color
#  alpha  size colour   PANEL  group  linetype
# 1  1.00  1.2 #F8766D     1     1        1
# 2  0.75  0.7 #C49A00     1     2        1
# 3  0.75  0.7 #53B400     1     3        1
# 4  0.75  0.7 #00C094     1     4        1
# 5  0.75  0.7 #00B6EB     1     5        1
# 6  0.75  0.7 #A58AFF     1     6        1
# 7  1.00  1.2 #FB61D7     1     7        1
```





**Choose color around the color wheel**


```r
n = 4
colVec = hue_pal()(n)
plot(1:n, pch = 16, cex = 2, col = colVec)
```

<img src="https://drive.google.com/thumbnail?id=1qdUMfHzU3JBRFHLdBJw9xPzCuwa7UY-d&sz=w1000" alt="gghue" style="zoom:80%;" />

### RColorBrewer

- <span style='color:#008B45'>*Sequential*</span> palettes names are `Blues` `BuGn` `BuPu` `GnBu` `Greens` `Greys` `Oranges` `OrRd` `PuBu` `PuBuGn` `PuRd` `Purples` `RdPu` `Reds` `YlGn` `YlGnBu` `YlOrBr` `YlOrRd`. All the sequential palettes are available in variations from 3 different values up to 9 different values. 

- <span style='color:#008B45'>*Diverging*</span> palettes are `BrBG` `PiYG` `PRGn` `PuOr` `RdBu` `RdGy` `RdYlBu` `RdYlGn` `Spectral`. All the diverging palettes are available in variations from 3 different values up to 11 different values. Suited to centered data with extremes in either direction.

  > For temperature and radiation data visulization, it's recommended to use diverging palettes from **blue to red**. 


- <span style='color:#008B45'>*Qualitative*</span> palettes, the lowest number of distinct values available always is 3, but the largest number is different for different palettes. { Accent 8 Dark2 8 Paired 12 Pastel1 9 Pastel2 8 Set1 9 Set2 8 Set3 12 }

```R
library(RColorBrewer)
## display a divergent palette
RColorBrewer::display.brewer.pal(7,"BrBG")

## display a qualitative palette
display.brewer.pal(7,"Accent")

## display a gradient color palette, used for sequential series
RColorBrewer::brewer.pal(9,"Blues") # show color names
display.brewer.pal(9,"Blues") # show a color strip
```


<figure style="display: flex; flex-direction: column; align-items: center;">
<img src="https://drive.google.com/thumbnail?id=1ZDMhtRyk2q82JKIA_F0lYbdc_IYcKHY1&sz=w1000" alt="rcolorbrewer-palette-rcolorbrewer-palettes" style="zoom:80%;" />
<figcaption> From top to bottom, represent sequential, qualitative, and diverging color palettes, respectively.</figcaption>
</figure>

--------------------------------------------------------------------------------

#### ggplot + ColorBrewer

`scale_colour_brewer`, `scale_fill_brewer` used with `ggplot()` to specify color palettes. 

`scale_color_brewer(type="seq", direction = 1)` 

- `type` 	One of `"seq"` (sequential), `"div"` (diverging) or `"qual"` (qualitative)
- `direction = 1`      Sets the order of colours in the scale. If 1, the default, colours are as output by `RColorBrewer::brewer.pal()`. If -1, the order of colours is reversed.

--------------------------------------------------------------------------------

#### Reverse color palette

- Use `rev(brewer_pal())` when specifying colors.

```r
library(ggplot2)
library(RColorBrewer)

ggplot(mtcars,aes(x = mpg, y = disp)) + 
    geom_point(aes(colour = factor(cyl))) + 
    scale_colour_manual(values = rev(brewer.pal(3, "BuPu")))
```

- use `factor` to change the level order of the data.

  Note that here `factor(-cyl)` is used.

```r
ggplot(mtcars, aes(x = mpg, y = disp)) + 
    geom_point(aes(colour = factor(-cyl))) + 
    scale_colour_manual(values = brewer.pal(3, "BuPu") )
```

--------------------------------------------------------------------------------

### Grey Scale

Grey scale is colour blind friendly and can still be distinguishable even if you print black and white.

If you are intending a discrete colour scale to be printed in black and white, it is better to explicitly use `scale_fill_grey()` which maps discrete data to grays, from dark to light.

- `start`/`end` 数值越小，颜色越深。数值越大，颜色越浅。

  1: white; 0: black

Default scales are from dark (0) to light (1)

```r
bars + scale_fill_grey()
bars + scale_fill_grey(start = 0.5, end = 1)
bars + scale_fill_grey(start = 0, end = 0.5)
```

<img src="https://drive.google.com/thumbnail?id=1-uSUL2F8J5CpsDy1a8HFlqVPHInXjtAC&sz=w1000" alt="Grey Scale" style="zoom:80%;" />

From light (1) to dark (0). Can just start at a larger number and end at a small number.

```r
 bars + scale_fill_grey(start = 1, end = 0.5)
 bars + scale_fill_grey(start = 0.5, end = 0)
```

<img src="https://drive.google.com/thumbnail?id=1JSg7LuVA9dwClXBaYDJ-tkaUraxou4Ej&sz=w1000" alt="Gray scale 2" style="zoom:50%;" />


--------------------------------------------------------------------------------

### `ggsci`

Scientific Journal and [Sci-Fi Themed Color Palettes](https://cran.r-project.org/web/packages/ggsci/vignettes/ggsci.html) for ggplot2


```R
library(ggsci) # color palette functions
library(scales) # display color palette in a panel

scales::show_col(pal_aaas()(3)) # use `pal_aaas()` palette
scales::show_col(pal_d3()(4))   # use `pal_d3()` palette
# `npg` and `simpsons` look good
show_col(pal_npg(alpha = 0.6)(9))
show_col(pal_simpsons("springfield")(9))
```





**Show color palette**

```R
show_palette <- function(colors) {
    n <- length(colors)
    image(1:n, 1, as.matrix(1:n), col = colors, 
          xlab = "", ylab = "", xaxt = "n", 
          yaxt = "n", bty = "n")
}

show_palette(heat.colors(6))

# Or equivalently using `scales:: show_col(colors)`
scales::show_col(colors)

## radiation color palette
cold <- colorRampPalette(c("#172DA6", "#7AACED", "white"))(10) # from blue to white
col_vec <- c( "#FFD4D4", "#FF7F7F", "#FF2A2A", "#FF7F00", "#FFD400")
cl <- colorRampPalette(col_vec)
warm <- cl(10+1)[c(1:5,8:11)]
myColors <- c(cold, warm)
show_palette(myColors)
```





```R
## use package RColorBrewer
library(RColorBrewer)
brewer.pal(11,"Spectral") # generate a series of color
display.brewer.pal(11,"Spectral") # show a legend of colors
```

 
### viridis

The **`viridis`** package contains four sequential color scales: “Viridis” (the primary choice) and three alternatives with similar properties (“magma”, “plasma”, and “inferno”).

`viridis(n, alpha = 1, begin = 0, end = 1, direction = 1, option = "D")`

- `n` 	The number of colors (*≥ 1*) to be in the palette.

- `alpha`     The alpha transparency, a number in [0,1], see argument alpha in `hsv`.

- `begin`, `end`    The (corrected) hue in [0,1] at which the viridis colormap begins/ends.

- `direction`     Sets the order of colors in the scale. If 1, the default, colors are ordered from darkest to lightest. If **-1**, the order of colors is **reversed**.

- `option`     "magma" (or "A"), "inferno" (or "B"), "plasma" (or "C"), "**viridis**" (or "**D**", the default option) and "cividis" (or "E").

  <img src="https://drive.google.com/thumbnail?id=1z9Ld2g6oiC46Jut0hOl7KfQKavXSJ9_w&sz=w1000" alt="viridis-scales" style="zoom:100%;" />

```R
## Choose color from viridis
# n <- 20 # number of colors you want
# mycolor <- viridis(n, alpha = 1, begin = 0, end = 1, direction = 1, option = "A")
# mycolor[10]
# show_palette(mycolor[10])
```





### **Generate Color Palettes**

```R
gg_color_hue <- function(n) {
    # generates a sequence of color
    hues = seq(15, 375, length=n+1)
    hcl(h=hues, l=65, c=100)[1:n]
}
> gg_color_hue(2)
# "#F8766D"(coral) "#00BFC4"(bluish)
```



`hcl(h = 0, c = 35, l = 85, alpha, fixup = TRUE)`	Create a vector of colors from vectors specifying `hue`, `chroma` and `luminance`.

- `h` 	The hue of the color  specified as an angle in the range `[0,360]`. **0** yields **red**, **120** yields **green** **240** yields **blue**, etc. 色相，色调 (颜色的性质)
- `c`    chrome (purity of intensy of color) 浓淡度，色度
- `l`     A value in the range [0,100] giving the luminance of the colour. 明暗度
- `alpha`   numeric vector of values in the range `[0,1]` for alpha transparency channel (0 means transparent and 1 means opaque).
- `fixup`   a logical value which indicates whether the resulting RGB values should be corrected to ensure that a real color results. if `fixup` is `FALSE` RGB components lying outside the range [0,1] will result in an `NA` value.



`hcl.colors(n, palette = "viridis", alpha = NULL, rev = FALSE)`	provides a basic and lean implementation of the pre-specified palettes in the **colorspace** package. 



### Color Interpolation

**`colorRampPalette(colors, ...)`** interpolate a set of given colors to create new color palettes

```R
col_vec <- c("#172DA6", "#7AACED", "white","#FFFF00","red")
cl <- colorRampPalette(col_vec)
colors <- cl(n)
```



`colorRampPalette(colors, bias = 1, space = c("rgb", "Lab"), interpolate = c("linear", "spline"), alpha = FALSE))`

<span style='color:#008B45'>Color interpolation function</span>.  Interpolate a set of given colors to create new color palettes.

- `colors` 	 vector of any of the three kinds, i.e., either 
  - a color name (as listed by `colors()` ), 
  - a hexadecimal string of the form `"#rrggbb"` or `"#rrggbbaa"` (see `rgb`), or 
  - a positive integer `i` meaning `palette()[i]`.

- `bias`      a positive number. Higher values give more widely spaced colors at the high end.
- `space`    character string; interpolation in RGB or CIE Lab color spaces.

```R
## Gradient of n colors ranging from color 1 and color 2
start <- "#C6DBEF"
end <- "#08519C"
n <- 10
colorRampPalette(c(start, end))(n)
```



```R
## specify vector color with mapview
# col.regions can be a function to interpolate colors
tracts <- tracts("IN", "St. Joseph County", year = 2021)
reds = colorRampPalette(c('pink', 'dark red'))
mapview(tracts, zcol="AWATER", col.regions = reds, at=seq(0, 2514920, 500000))
```



<img src="https://drive.google.com/thumbnail?id=1-4U2Qn1-00RkstUy9BU5BlvrZf13gano&sz=w1000" alt="Picture1" style="display: block; margin-right: auto; margin-left: auto; zoom:68%;" />

