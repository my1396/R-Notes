
## Data Splitting and Grouping

*Functions for splitting data into groups and applying operations.*

### The `split()` Function

`split(x, f, drop = FALSE, …)` divides the data in the vector `x` into the groups defined by `f`. 

**Parameters:**

- `x` - vector or data frame containing values to be divided into groups.
- `f` - a 'factor' in the sense that `as.factor(f)` defines the grouping; `f` is recycled as necessary and if the length of `x` is not a multiple of `f`, a warning is printed.
  - if `x` is a data frame, <span style='color:#00CC66'>`f` can be a lambda formula</span> of the form `~ g` to split by the variable `g`, or by the <span style='color:#00CC66'>interaction of more variables</span>, e.g., `~ g1+g2`.

**Return Value:**

`split` returns a **list** of vectors containing the values for the groups. The components of the list are named by the levels of `f`. 

**Key Advantage:**

The advantage of `split` is to <u>index groups by their key names</u> directly, which is not true for `dplyr::group_by`, which can <u>only be indexed by group number</u>.

#### Basic Vector Splitting {-}

```r
> a <- c(x = 3, y = 5, x = 1, x = 4, y = 3)
> a
x y x x y 
3 5 1 4 3 

> split(a, f=names(a))
$x
x x x 
3 1 4 

$y
y y 
5 3

# split into two groups with roughly equal size
> split(a, f=factor(1:2))
$`1`
x x y 
3 1 3 

$`2`
y x 
5 4 

Warning message:
In split.default(a, f = factor(1:2)) :
  data length is not a multiple of split variable
```

#### Data Frame Splitting {-}

You can use the `split` function to split data frames in groups.

**Single Variable Splitting:**

```r
# split `df` based on `Treatment`
> split(df, f = df$Treatment)
$`nonchilled`
   Plant        Type  Treatment conc uptake
15   Qn3      Quebec nonchilled   95   16.2
49   Mn1 Mississippi nonchilled 1000   35.5
48   Mn1 Mississippi nonchilled  675   32.4
10   Qn2      Quebec nonchilled  250   37.1
44   Mn1 Mississippi nonchilled  175   19.2

$chilled
   Plant        Type Treatment conc uptake
68   Mc1 Mississippi   chilled  500   19.5
32   Qc2      Quebec   chilled  350   38.8
27   Qc1      Quebec   chilled  675   35.4
23   Qc1      Quebec   chilled  175   24.1
79   Mc3 Mississippi   chilled  175   18.0
```

`split` can be based on a combination of columns.

```r
# split by `Treatment` and `Type`
> split(df, f = list(df$Type, df$Treatment))
$`Quebec.nonchilled`
   Plant   Type  Treatment conc uptake
15   Qn3 Quebec nonchilled   95   16.2
10   Qn2 Quebec nonchilled  250   37.1

$Mississippi.nonchilled
   Plant        Type  Treatment conc uptake
49   Mn1 Mississippi nonchilled 1000   35.5
48   Mn1 Mississippi nonchilled  675   32.4
44   Mn1 Mississippi nonchilled  175   19.2

$Quebec.chilled
   Plant   Type Treatment conc uptake
32   Qc2 Quebec   chilled  350   38.8
27   Qc1 Quebec   chilled  675   35.4
23   Qc1 Quebec   chilled  175   24.1

$Mississippi.chilled
   Plant        Type Treatment conc uptake
68   Mc1 Mississippi   chilled  500   19.5
79   Mc3 Mississippi   chilled  175   18.0
```

You can recover the original data frame with the `unsplit` function:

```r
unsplit(dfs, f = list(df$Type, df$Treatment))
```

More options for spiting data frames: <https://www.spsanderson.com/steveondata/posts/2024-10-01/>

--------------------------------------------------------------------------------


### Split-and-Apply Operations

*Combining splitting with function application for grouped operations.*

#### Manual Split-Apply Pattern {-}

The most common pattern is: `split` → `lapply`

**Example Usage:**

```r
# Sample order data
orders <- data.frame(
  order_id = 1:10,
  product = c("A", "B", "A", "C", "B", "A", "C", "B", "A", "C"),
  amount = c(100, 150, 200, 120, 180, 90, 210, 160, 130, 140)
)

# Split orders by product
orders_by_product <- split(orders, orders$product)

# Analyze each product category
lapply(orders_by_product, function(x) sum(x$amount))
```

#### All-in-One Approach {-}

**`plyr::ddply()`** - For each subset of a data frame, apply function then combine results into a data frame.

| Parameter    | Definition                                                   |
| ------------ | ------------------------------------------------------------ |
| `.data`      | data frame to be processed                                   |
| `.variables` | variables to split data frame by, as `as.quoted` variables, a formula or character vector |
| `.fun`       | function to apply to each piece                              |
| `...`        | other arguments passed on to `.fun`                          |

**Usage example:**

```r
library(plyr)
ddply(BData[,c("iso","gdp")], .(iso), function(x) sum(is.na(x[,-1])))
```



<span style='color:#008B45'>**`by(data, INDICES, FUN, …, simplify = TRUE)`**  </span> an object-oriented wrapper for `tapply` applied to **data frames**. Apply a function to a data frame split by factors.

- `data` 	     a data frame, matrix
- `INDICES`    a factor or a list of factors, each of length `nrow(data)`
- `FUN`            a function to be applied to (usually data-frame) subsets of `data`.
- `...`            further arguments to `FUN`.

```R
x <- by(mtcars, mtcars$cyl, function(x) apply(x,2,mean))        
# reshape to a data frame        
do.call(rbind, x) 
# or
t(sapply(x, I)) 
#     mpg     cyl     disp        hp     drat       wt     qsec        vs
# 4 26.66364   4 105.1364  82.63636 4.070909 2.285727 19.13727 0.9090909
# 6 19.74286   6 183.3143 122.28571 3.585714 3.117143 17.97714 0.5714286
# 8 15.10000   8 353.1000 209.21429 3.229286 3.999214 16.77214 0.0000000
#         am     gear     carb
# 4 0.7272727 4.090909 1.545455
# 6 0.4285714 3.857143 3.428571
# 8 0.1428571 3.285714 3.500000
```







#### Efficient spliting with `data.table` {-}

For large datasets, the `data.table` package offers high-performance data manipulation tools. Here’s how you can split a data frame using `data.table`:

```r
library(data.table)
# a simple example
> set.seed(123)
> df <- data.frame(
  id = 1:6,
  group = sample(LETTERS[1:3], 6, replace=TRUE),
  value = c(10, 15, 20, 25, 30, 35)
	)

# Convert the data frame to a data.table
> dt <- as.data.table(df)
> dt
   id group value
1:  1     C    10
2:  2     C    15
3:  3     C    20
4:  4     B    25
5:  5     C    30
6:  6     B    35

# Split the data.table
> split_dt <- dt[, .SD, by = group]

# This creates a data.table with a list column
> split_dt
   group id value
1:     C  1    10
2:     C  2    15
3:     C  3    20
4:     C  5    30
5:     B  4    25
6:     B  6    35

# use print(.SD) to print by group
> dt[, print(.SD), by = group]
   id value
1:  1    10
2:  2    15
3:  3    20
4:  5    30
   id value
1:  4    25
2:  6    35
Empty data.table (0 rows and 1 cols): group
```

You will notice the data.table comes back as one but you will see that were `id` was, is now a factor column called `group`.

`.SD` stands for something like "`S`ubset of `D`ata.table".  It refers to the current group.

`.BY` gives a list of the current value of the groupping variable.

There's no significance to the initial `"."`, except that it makes it even more unlikely that there will be a clash with a user-defined column name.

```r
library(data.table)
# Simulate a large dataset
set.seed(123)
large_df <- data.table(
  id = 1:1e6,
  group = sample(LETTERS[1:5], 1e6, replace = TRUE),
  value = rnorm(1e6)
)

# Split and process the data efficiently
result <- large_df[, .(mean_value = mean(value), count = .N), by = group]

print(result)
```





