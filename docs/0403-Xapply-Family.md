## `*apply()` Family

**`tapply(x, INDEX, FUN, ...)`** break `x` into **groups** based on `INDEX`, apply `FUN` to each group (subset), and return the results in a convenient form. 

- `INDEX`       a `list` of one or more factors, each of *same length* as `X`. The elements are<span style="color:red"> **coerced to factors**</span> by `as.factor`.
- Return a vecotr when `FUN` returns a single atomic value, length determined by # of component in `INDEX`; if `FUN` returns more than one value, `tapply` returns a list.

```R
tapply(X, INDEX, FUN = NULL)
Arguments:
-X: An object, usually a vector
-INDEX: A list containing factor, of length of X
-FUN: Function applied to each element of x
```




**`apply(x, MARGIN, FUN)`** 

```r
-x: an array or matrix
-MARGIN:  take a value or range between 1 and 2 to define where to apply the function:
-MARGIN=1: the manipulation is performed per row
-MARGIN=2: the manipulation is performed per column
-MARGIN=c(1,2) the manipulation is performed on rows and columns
```



**`lapply()`** takes list, vector or data frame as input and gives output in **list**.

```r
lapply(X, FUN)
Arguments:
-X: A vector or an object
-FUN: Function applied to each element of x	
```

`lapply(df, FUN)` is a shortcut to `apply(df, MARGIN=2, FUN)`, conducting `FUN` on each column.

We can use `unlist()` to convert the list into a vector.



**`sapply()`** function takes list, vector or data frame as input and gives output in vector or matrix. `sapply()` function does the same job as `lapply()` function but returns a **vector**. `sapply()` function is **more efficient** than `lapply()` in the output returned because `sapply()` store values direclty into a vector.

`sapply(X, FUN, ...)` 

-   `X`: A vector or an object
-   `FUN`: Function to be applied to each element of `X`. In the case of functions like `+`, `%*%`, the function name must be backquoted or quoted.
-   `...` :  optional arguments to `FUN`.



A summary for differences of **`*apply()`** functions.

| Function                                  | Arguments                                           | Objective                                                    | Input                                       | Output              |
| :---------------------------------------- | :-------------------------------------------------- | :----------------------------------------------------------- | :------------------------------------------ | :------------------ |
| apply                                     | apply(x, MARGIN, FUN)                               | Apply a function to the rows or columns or both, `MARGIN=1` on rows, `MARGIN=2` on cols | Data frame or matrix                        | vector, list, array |
| lapply                                    | lapply(X, FUN, ...)                                 | Apply a function to all the elements of the input            | List, vector or data frame                  | list                |
| sapply                                    | sappy(X, FUN, ...)                                  | Apply a function to all the elements of the input            | List, vector or data frame                  | vector or matrix    |
| <span style='color:red'>**mapply**</span> | mapply(FUN, ... , MoreArgs = NULL, SIMPLIFY = TRUE) | `mapply` is a **multivariate** version of `sapply`. `mapply` applies `FUN` to the first elements of each `...` argument, the second elements, the third elements, and so on. Arguments are recycled if necessary. | Multiple List or multiple Vector Arguments. | vector or matrix    |
| tapply                                    | tapply(X, INDEX, FUN = NULL)                        | applies a function or operation on subset of the vector broken down **by a given factor variable**. Similar to `group_by` and `summarize`. | List, vector or data frame                  | vector or list      |



A useful application is to combine `lapply()` or `sapply()` with subsetting:

```r
x <- list(1:3, 4:9, 10:12)
sapply(x, "[", 2)
#> [1]  2  5 11

# equivalent to
sapply(x, function(x) x[2])
#> [1]  2  5 11
```





**`mapply(FUN, ... , MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE)`**

- `...`		     `FUN` arguments to <span style='color:red'>**vectorize over** </span>(vectors or lists of strictly positive length, or all of zero length). 

- `MoreArgs`   passing a list of other arguments, **that don't need to vectorize**, to `FUN`.

- `SIMPLIFY`   logical or character string; attempt to reduce the result to a vector, matrix or higher dimensional array; 
  - For `sapply` it must be named and not abbreviated. The default value, `TRUE`, returns a vector or matrix if appropriate, whereas if `SIMPLIFY = "array"` the result may be an `array` of “rank” (=`length(dim(.))`) one higher than the result of `FUN(X[[i]])`.
- `USE.NAME`    logical; use names if the first `…` argument has names, or if it is a character vector, use that character vector as the names.



**`mapply`** calls `FUN` for the values of `...` (re-cycled to the length of the longest, unless any have length zero), followed by the arguments given in `MoreArgs`. The arguments in the call will be named if `...` or `MoreArgs` are named.

```R
mapply(rep, times = 1:4, x = 4:1)
# [[1]]
# [1] 4
# 
# [[2]]
# [1] 3 3
# 
# [[3]]
# [1] 2 2 2
# 
# [[4]]
# [1] 1 1 1 1

mapply(rep, times = 1:4, MoreArgs = list(x = 42))
# [[1]]
# [1] 42
# 
# [[2]]
# [1] 42 42
# 
# [[3]]
# [1] 42 42 42
# 
# [[4]]
# [1] 42 42 42 42
```



**`clusterMap(cl = NULL, fun, ..., MoreArgs = NULL, RECYCLE = TRUE,
           SIMPLIFY = FALSE, USE.NAMES = TRUE,
           .scheduling = c("static", "dynamic"))`** is the parallel version for **`mapply`.**

To iterate over more than one variable, `clusterMap` is very useful. Since you're only iterating over `int1` and `int2`, you should use the "MoreArgs" option to specify the variables that you *aren't* iterating over. `clusterMap` returns the results in a list by default, you should be able to combine the results using `do.call('rbind', result)`.

```R
cluster <- makeCluster(detectCores())
clusterEvalQ(cluster, library(xts))
result <- clusterMap(cluster, function1, int1=1:8, int2=c(1, rep(0, 7)),
                MoreArgs=list(df1=df1, df2=df2, char1="someString"))
df <- do.call('rbind', result)
```



`parApply(cl = NULL, X, MARGIN, FUN, ..., chunk.size = NULL)`

- `parApply` is the parallel version of `apply` while `clusterApply` apply a function to a list of arguments. 
- No vectorization is involved.



**`clusterApply(cl = NULL, x, fun, ...)`**

`clusterApply` calls `fun` on the first node with arguments `x[[1]]` and ..., on the second node with `x[[2]]` and ..., and so on, recycling nodes as needed. `clusterApply` only vectorize `x`. Example:

```R
> clusterApply(cl, c(2:4), sum, 10)
[[1]]
[1] 12

[[2]]
[1] 13

[[3]]
[1] 14
```



### <span style='color:#008B45'>Paralle</span> version of `apply` function

`parallel::parLapply` Performs the calculations in parallel, possibly on several nodes

`parLapply(cl = NULL, X, fun, ...)`

* `cl`   a cluster object
* `X` 	A vector (atomic or list) for `parLapply` and `parSapply`, an array for `parApply`.
* `fun` function or character string naming a function.
* `...` additional arguments to pass to `fun`: beware of partial matching to earlier arguments. e.g.: `parSapply(cl,var1,FUN=myfunction,var2=var2,var3=var3,var4=var4)`

Note that:

1. Can use several types of communications, including `PSOCK` and `MPI`
2. For parLapply, the worker processes must be prepared with any loaded packages with `clusterEvalQ`	or `clusterCall`.
3. For `parLapply`, large data sets can be exported to workers with `clusterExport`.
4. Best practice: Test interactively with `lapply` serially, and `mclapply` or `parLapply` (PSOCK) in parallel



```R
## Sample codes for using cluster
library(parallel)
# initialize a cluster
cl <- makeCluster(4, type='SOCK')
clusterEvalQ(cl, library(raster))  
cldCON <- parSapply(cl, as.list(cldNC), simulation_mask, 
                            tgt=con_shape[shape_dict[con_name],])   
# stop a cluster
stopCluster(cl)
```



`mclapply(X, FUN, ...)` is a parallelized version of `lapply`, it returns a list of the same length as `X`, each element of which is the result of applying `FUN` to the corresponding element of `X`.



`parallel::mcmapply(FUN, ...,
         MoreArgs = NULL, SIMPLIFY = TRUE, USE.NAMES = TRUE,
         mc.preschedule = TRUE, mc.set.seed = TRUE,
         mc.silent = FALSE, mc.cores = getOption("mc.cores", 2L),
         mc.cleanup = TRUE, affinity.list = NULL)` is a parallelized version of `mapply`.

`mc*apply` takes an argument, `mc.cores`. By default, `mc*apply` will use <u>all cores available</u> to it. 

-   If you don’t want to (either becaues you’re on a shared system or you just want to save processing power for other purposes) you can set this to a value lower than the number of cores you have. 
-   Setting it to 1 disables parallel processing, and setting it higher than the number of available cores has no effect.



`stackApply(r, indices=num_years, fun=mean, na.rm=T, ...)`

Apply a function on subsets of a RasterStack or RasterBrick. The layers to be combined are indicated with the vector `indices`. The function used should return a single value, and the number of layers in the output `Raster*` equals the number of unique values in `indices`. For example, if you have a `RasterStack` with 6 layers, you can use `indices=c(1,1,1,2,2,2)` and `fun=sum`. This will return a `RasterBrick` with two layers.

* `x` 			    `Raster*` object

* `indices`	 integer. Vector of length `nlayers(x)`




```r
num_yearss <- rep(1:55, each=12) # 55 years
r_year <- stackApply(r, indices=num_years, fun=mean, na.rm=T)

# A parallel version
beginCluster(4)
r_year <- clusterR(r, stackApply, 
                       args=list(indices=num_years, fun=mean, na.rm=T))
endCluster()
```



`snow` package for parallel computing

`snow::clusterMap(cl, fun, ..., MoreArgs=NULL, RECYCLE=TRUE)` 

-   `clusterMap` is a multi-argument version of `clusterApply`, analogous to `mapply`. If `RECYCLE` is true shorter arguments are recycled; otherwise, the result length is the length of the shortest argument. Cluster nodes are recycled if the length of the result is greater than the number of nodes.

`clusterApply(cl, x, fun, ...)` calls `fun` on the first cluster node with arguments seq[[1]] and ..., on the second node with seq[[2]] and ..., and so on. If the length of seq is greater than the number of nodes in the cluster then cluster nodes are recycled. A list of the results is returned; the length of the result list will equal the length of seq.

`clusterCall(cl, fun, ...)` calls a function `fun` with identical arguments `...` on each node in the cluster `cl` and returns a list of the results.

`clusterEvalQ(cl, expr)` evaluates a literal expression on each cluster node. It a cluster version of `evalq`, and is a convenience function defined in terms of `clusterCall`.

`clusterExport(cl, list, envir = .GlobalEnv)` assigns the values on the master of the variables named in list to variables of the same names in the global environments of each node. The environment on the master from which variables are exported defaults to the global environment.

```R
cl <- makeSOCKcluster(c("localhost","localhost"))

clusterApply(cl, 1:2, get("+"), 3)
clusterEvalQ(cl, library(boot)) # load packages needed
x<-1
clusterExport(cl, "x")
clusterCall(cl, function(y) x + y, 2)

endCluster()
```



