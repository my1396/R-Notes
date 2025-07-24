## Heatmap

The `lattice` package allows to build [heatmaps](https://www.r-graph-gallery.com/heatmap.html) thanks to the `levelplot()` function.

```R
# Load the lattice package
library("lattice")
 
# Dummy data
x <- seq(1,10, length.out=20)
y <- seq(1,10, length.out=20)
data <- expand.grid(X=x, Y=y)
data$Z <- runif(400, 0, 5)

## Try it out
levelplot(Z ~ X*Y, data=data  ,xlab="X",
          main="")
```



Previous example of this document was based on a data frame at the long format. In pactice, however, a **square matrix** is more often used. 

```R
## S3 method for class 'matrix'
levelplot(z, data = NULL, aspect = "iso",
          ..., xlim, ylim,
          row.values = seq_len(nrow(x)),
          column.values = seq_len(ncol(x)),
          main=paste("predicted radiation:",timeVals[timeLayer]), 
          ylab="latitude", xlab="longitude",
          col.regions=cls(256), cuts=255, at=seq(0,450,length.out=256))
```

- `z`               `z` is a numeric response evaluated on a rectangular grid defined by row.values and column.values
- `col.regions` 	color vector to be used 
- `cuts`          The number of levels the range of `z` would be divided into.
- `at`              A numeric vector giving breakpoints along the range of `z`.



A wrapper for `layerplot` with pre-defined color palette, axis title and etc.

```R
level_plot <- function(r, col_vec=c("black","red","yellow","white")){
  	## for plotting 0.5*0.5 degree map
    # @params r: RasterLayer or matrix
    # @params col_vec: color vector palette for legend
  
    cl <- colorRampPalette(col_vec)
  	latVec <- seq(from=-89.75,to=89.75,by=0.5)  #for plotting
		lonVec <- seq(from=-179.75,to=179.75,by=0.5)  #for plotting
  
    if (class(r) == "RasterLayer"){
        # flip raster upside down, raster reads from top left
        layerPlot <- levelplot(t(as.matrix(r))[,seq(360,1)],row.values=lonVec,column.values=latVec,main=paste("predicted radiation:",getZ(r)),ylab="latitude",xlab="longitude",col.regions=cls(256),cuts=255,at=seq(0,450,length.out=256))
    } else if(class(r) == "matrix"){
        # levelplot reads from bottom left
        layerPlot <- levelplot(r,row.values=lonVec,column.values=latVec,ylab="latitude",xlab="longitude",col.regions=cls(256),cuts=255,at=seq(0,450,length.out=256))
    }
    print(layerPlot)
}
```



