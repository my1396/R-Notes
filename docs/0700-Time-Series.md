# Time Series



<http://r-statistics.co/Time-Series-Analysis-With-R.html>

Commonly used R packages for processing Financial data:

- `quantmod`

- `quandl`

- `tidyquant`   <https://cran.r-project.org/web/packages/tidyquant/vignettes/TQ00-introduction-to-tidyquant.html>

- [`PerformanceAnalytics`](https://rdrr.io/cran/PerformanceAnalytics/#vignettes), `zoo`, `xts`

  - [PerformanceAnalytics Charts and Tables Overview](https://rdrr.io/cran/PerformanceAnalytics/f/inst/doc/PA-charts.pdf)

    [PA-charts.R](https://github.com/cran/PerformanceAnalytics/blob/master/inst/doc/PA-charts.R)

  - Github.io page by Carl and Peterson: <https://timelyportfolio.github.io/PerformanceAnalytics/index.html>

  - Brian Peterson's PA website:
    <https://braverock.r-universe.dev/PerformanceAnalytics>




## Date

`as.POSIXct(zoo::as.yearmon(seq(1960,2014)) + 11/12, frac = 1)` generate yearly date (the end of year) sequence.

`Sys.getlocale("LC_TIME")`  Check your **locale**. The locale describes aspects of the **internationalization** of a program. Initially most aspects of the locale of **R** are set to `"C"` (which is the default for the **C** language and reflects North-American usage – also known as `"POSIX"`). 

- R uses the current "LC_TIME" locale when parsing or writing dates (see [format.Date](https://docs.tibco.com/pub/enterprise-runtime-for-R/6.0.0/doc/html/Language_Reference/base/format.Date.html)), to determine the appropriate words for the days of the weeks and the months.
- Locale affects how R processes date time representations, e.g., languages.

`Sys.setlocale(category = "LC_TIME", locale = "C")`   this set the time language to English. Same as `Sys.setlocale(category = "LC_TIME", locale = "en_US.UTF-8")`.

- `locale = ""` 	means set to the default locale for your system. 

  - `locale` also accepts locales such as "en_US" (for the English-language locale in the Unites States) or "fr_FR" (for the French-language locale in France). 
  - First two-letter lowercase stands for the language code (using the ISO-639 standard); followed by a two-letter uppercase country code (using the ISO-3166 standard). 

  ```r
  # examples
  Sys.setlocale("LC_TIME", "de")     # Solaris: details are OS-dependent
  Sys.setlocale("LC_TIME", "de_DE")  # Many Unix-alikes
  Sys.setlocale("LC_TIME", "de_DE.UTF-8")  # Linux, macOS, other Unix-alikes
  Sys.setlocale("LC_TIME", "de_DE.utf8")   # some Linux versions
  Sys.setlocale("LC_TIME", "German") # Windows
  ```

  

Every time you start a new R session, you get back to native setting. Should you want a permanent change, put

```r
.First <- function() {
   Sys.setlocale("LC_TIME", "C")
   }
```

in the `$(R RHOME)/etc/Rprofile.site` file. Read `?Startup` for how to customize R startup and the use of `.First`.





**From string/numeric to date**

`lubridate::ymd(...), mdy(...), dmy(...)`: They automatically work out the format once you specify the order of the component. To use them, identify the order in which year, month, and day appear in your dates, then arrange “y”, “m”, and “d” in the same order. 

* `...` a *character* or numeric vector of suspected dates
* E.x.  


```r
ymd(20101215)
#> [1] "2010-12-15"
mdy("4/1/17")
#> [1] "2017-04-01"
dmy("31-Jan-2017")
#> [1] "2017-01-31"

# create year-month-01 date series from individual components columns in df
df$date <- with(df, ymd(sprintf('%04d%02d%02d', YR, MON, 1)))
```



Get year and month from date

```r
lubridate::year(date)
lubridate::month(date)
```



**From date to string**

Convert date `x` to a string of your choosing format using base R: 

- `format(x, format="%Y-%m-%d")`
- `strftime(x, format="%Y-%m-%d")`
- From string to date, one can use `strptime`, but `lubridate` is more flexible.
- Use `?strptime` to check how to represent date components using strings, usually start with `%` and followed by a letter.



**Format code list**

This code list corresponds to user's **locale** setting and platform. For instance, `%b` will return English if your language setting is English, return German is your language setting is German.

| Specification | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| %d            | Day of the month: 01-31                                      |
| %m            | 2 digits month: 01-12                                        |
| %b            | Abbreviated month name in the current locale on this platform: Jan, Feb, ... |
| %B            | Month's name in full: January, February etc.                 |
| %y            | 2 digits year without century: 00-99                         |
| %Y            | 4 digits year. Year with century on input:<br/>00 to 68 prefixed by 20; e.g., 2005<br/>69 to 99 prefixed by 19; e.g., 1968 |



<span style='color:#008B45'>`zoo.as.yearmon(x)`</span> to convert `date` to `yearmon`. This is useful when you want to join tables by year-month combination. 

```r
as.yearmon("mar07", "%b%y")
as.yearmon("2007-03-01")
as.yearmon("2007-12")

# year-quarter
> as.yearqtr("2019-01")
[1] "2019 Q1"

# returned Date is the fraction of the way through
# the period given by frac (= 0 by default)
as.Date(x)
as.Date(x, frac = 1)
as.POSIXct(x)
```

`as.Date(x, frac=0)`  

- `frac` 	specifies the fractional amount through the month to use so that 
  - `0` is beginning of the month. The default value of `frac` is 0.
  - `1` is the end of the month.



Add one month to `date`

`%m+%` and `%m-%` add and subtract months to a date without exceeding the last day of the new month.

```r
d <- ymd("2012-01-31")
[1] "2012-01-31 UTC"
d %m+% months(1) # `%m+%` avoid rollover
[1] "2012-02-29 UTC"
> d + months(1) # this is invalid as Feb doesn't have 31th day
[1] NA
> d %m+% months(-1)
[1] "2011-12-31"
> d %m-% months(1) # same as last code
[1] "2011-12-31"
> d %m+% years(1)
[1] "2013-01-31"
> d %m+% years(1:3)  # add a sequence
[1] "2013-01-31" "2014-01-31" "2015-01-31"
> d %m+% days(1:3)
[1] "2012-02-01" "2012-02-02" "2012-02-03"
```



A vector of dates

```r
d <- ymd("2014-03-31")
d %m+% months(seq(3,30,3))
 [1] "2014-06-30" "2014-09-30" "2014-12-31" "2015-03-31" "2015-06-30"
 [6] "2015-09-30" "2015-12-31" "2016-03-31" "2016-06-30" "2016-09-30"
```

Initialize an empty vector of dates

```r
# if you use d<-c(), this will create a numeric vector
# cannot concatenate afterwards
d <- lubridate::ymd()
c(d, ymd("2014-03-31"))
```





## Process Data

Download stock data using `quantmod::getSymbols`

`getSymbols` loads data in the current environment using the **symbol/tick** of the asset. 

Returned data will have column names `symbol.Open`, `symbol.High`, `symbol.Low`, `symbol.Close`, `symbol.Volume`, and `symbol.Adjusted`.

<img src="https://drive.google.com/thumbnail?id=1OXgxZ30KWTnKrLNI6Z82dupA0omyR0EW&sz=w1000" alt="getSymbols" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

```r
# Stock prices
stock_prices <- getSymbols(c("SPY", "AAPL"), 
           src = 'yahoo', 
           from="2014-12-01", # add an extra month before the start date such that 
           to="2023-12-31",   # the 1st month has non-NA return data;
                           		#	Note: need to start from "12-01";
           auto.assign=TRUE   # return 2 "xts" object in the current env: "SPY" and "AAPL"
           ) 
> stock_prices # returned value is a vector of tickers
[1] "SPY"  "AAPL"

# Treasury Bill
Tbill_1m <- getSymbols("DGS1MO", src="FRED", auto.assign=FALSE)

# Market index: OSEBX
mkt_idx_prices <- getSymbols("OSEBX.OL", 
                             from="2014-12-01", 
                             to="2023-12-31", 
                             src="yahoo",
                             auto.assign = FALSE)
mkt_idx_prices
# from xts to tibble or data.frame
mkt_idx_prices <- data.frame(mkt_idx_prices) %>% 
    rownames_to_column(var = "Date") %>% # this converts Date to a string
    mutate(Date = ymd(Date)) # convert back to Date type
mkt_idx_prices %>% str()
mkt_idx_prices %>% head()
mkt_idx_prices %>% tail()
# for index, adjusted is equal to closing prices
with(mkt_idx_prices, all.equal(OSEBX.OL.Adjusted, OSEBX.OL.Close)) 
f_name <- "data/market/OSEBX_prices_2015-2023_daily.csv"
write_csv(mkt_idx_prices, f_name)
mkt_idx_prices <- read_csv(f_name)
```

- `src`		data sources. Options: `yahoo`, `google`, `MySQL`, `FRED`, `csv`, `RData`, and `Oanda`. Defaults to `yahoo`.

  - `yahoo`   returns 6 columns: OHLC, **adjusted price**, and volume.

  - `google` returns OHLC and volume.

  - `FRED`      interest rates and other economic series data for <span style='color:#008B45'>US</span>, including 

    • CPIAUCSL (CPI)
    • POP (Population)
    • DNDGRA3M086SBEA (Real Consumption) 
    • INDPRO (Industrial Production)
    • OILPRICE
    • BAA
    • DTB3 (3 month T-bills)
    • DGS10 (10 year Treasuries)

    • UNRATE (unemployment rate)

    To find the series name, refer to [FRED's website](https://fred.stlouisfed.org/categories/32991) for all available indicators.

  - `Oanda`   [The Currency Site](http://www.oanda.com/) (FX and Metals)

  - Before doing any analysis you <span style='color:#008B45'>**must always check the data to ensure quality**</span>. 

    Do not assume that because you are getting it from a source such as Yahoo! or Google that it is clean.

- `auto.assgin`  	Defaults to `True`, data are loaded silently to the current environment, i.e., the workspace. 

  - If `FALSE`, need to assign the returned results to a variable.  Note that only *one* symbol at a time may be requested when auto assignment is disabled.
  - Objects loaded by `getSymbols` with `auto.assign=TRUE` can be viewed with `showSymbols` and removed by a call to `removeSymbols`. 


- `env = globalenv()`  where to create objects. Defaults to the global environment. 

  Setting `env=NULL` is equal to `auto.assign=FALSE`.

  Alternatively, you can create a separate environment to store the downloaded data.

  ```r
  # create a new env called `sp500`
  sp500 <- new.env()
  # save the S&P 500 (symbol:^GSPC) to `sp500`
  getSymbols("^GSPC", env = sp500, src = "yahoo",
             from = as.Date("1960-01-04"), to = as.Date("2009-01-01"))
  ```

  To load the variable GSPC from the environment sp500 to a variable in the global environment (also known as the workspace), three options:

  ```r
  # opt 1
  GSPC <- sp500$GSPC
  # opt 2
  GSPC1 <- get("GSPC", envir = sp500)
  # opt 3
  GSPC2 <- with(sp500, GSPC)
  ```

- `periodicity="daily"`    periodicity of data to query and return. Defaults to "daily". 

  Must be one of "daily", "weekly", "monthly". 

  ```r
  # this returns beginning of month data
  getSymbols(Symbols = "AAPL", from="2010-01-01", to="2018-03-01", periodicity="monthly")
  ```

  





**Download index components data**

1. download a csv file containing all company symbols and names.

   ```r
   nasdaq100 <-
        read.csv("nasdaq100list.csv",
                 stringsAsFactors = FALSE, strip.white = TRUE)
   dim(nasdaq100) # check dimension
   nasdaq100$Name[duplicated(nasdaq100$Name)] # remove duplicates
   ```

2. Download data

   By using the command `tryCatch` we handle unusual conditions, including errors and warnings. 

   In this case, if the data from a company are not available from yahoo finance, the message `Symbol ... not downloadable!` is given. 

   (For simplicity, we only download the symbols starting with `A`.)

   ```r
   nasdaq <- new.env()
   for(i in nasdaq100$Symbol[startsWith(nasdaq100$Symbol, "A")]) {
       cat("Downloading time series for symbol '", i, "' ...\n", sep = "")
       status <- tryCatch(getSymbols(i, env = nasdaq, src = "yahoo",
                                     from = as.Date("2000-01-01")),
                          error = identity)
       if(inherits(status, "error"))
       cat("Symbol '", i, "' not downloadable!\n", sep = "")
   }
   # check AAPL time series
   with(nasdaq, head(AAPL))
   # visualize
   chartSeries(nasdaq$AAPL)
   ```

   Have a look at the `quantmod` [homepage](www.quantmod.com/examples/intro/) for further examples.

   See the [manual](https://www.quantmod.com/documentation/00Index.html) of the `quantmod` package for the whole list of available plot and visualization functions.



**Download only the close price**

Use `getSymbols()[,4]` to subset the close price column.

```r
tickers <- c("0011.HK", "1299.HK", "1083.HK", "0823.HK", "0669.HK", "0992.HK")

portfolioPrices <- NULL
for (Ticker in tickers)
  portfolioPrices <- cbind(portfolioPrices,
                           getSymbols(Ticker, from = "2012-09-01", 
                                      to = "2022-08-31", 
                                      periodicity = "weekly", 
                                      auto.assign=FALSE)[, 4])
colnames(portfolioPrices) <- c("HSBC", "AIA", "TG", "LinkReit", "Techronic", "Lenovo")
portfolioPrices
```



**Technical Indicators**

<https://bookdown.org/kochiuyu/technical-analysis-with-r-second-edition2/technical-indicators.html>



___



### `tidyquant`

Useful resources: 

<https://www.tidy-pm.com/s-2data>

Nice thing about `tidyquant` is that it works directly with `tibble`, making it work seamlessly with `tidyverse`.  This means we can:

- Seamlessly scale data retrieval and mutations
- Use the pipe (`%>%`) for chaining operations
- Use `dplyr` and `tidyr`: `select`, `filter`, `group_by`, `nest`/`unnest`, `spread`/`gather`, etc
- Use `purrr`: mapping functions with `map`



`tq_get(x, get, from, to)` 	get trading data, such as OHLC, and return as `tibble`.

- `x` 	 A single character string, a character vector or tibble representing a single (or multiple) stock symbol, metal symbol, currency combination, FRED code, etc.
- `get`     A character string representing the type of data to get for `x`.  Possible options:
  - `"stock.prices"`: Get the open, high, low, close, volume and adjusted stock prices for a stock symbol from Yahoo Finance (https://finance.yahoo.com/). Wrapper for `quantmod::getSymbols()`.
  - `"dividends"`: Get the dividends for a stock symbol from Yahoo Finance (https://finance.yahoo.com/). Wrapper for `quantmod::getDividends()`.
  - `"splits"`: Get the split ratio for a stock symbol from Yahoo Finance (https://finance.yahoo.com/). Wrapper for `quantmod::getSplits()`.
  - `tq_get_options()` returns a list of valid `get` options you can choose from.

- Use `from` and `to` to specify the period of interest.

```r
tq_get("AAPL",get = "stock.prices")
# A tibble: 2,687 × 8
   symbol date        open  high   low close    volume adjusted
   <chr>  <date>     <dbl> <dbl> <dbl> <dbl>     <dbl>    <dbl>
 1 AAPL   2014-01-02  19.8  19.9  19.7  19.8 234684800     17.3
 2 AAPL   2014-01-03  19.7  19.8  19.3  19.3 392467600     16.9
 3 AAPL   2014-01-06  19.2  19.5  19.1  19.4 412610800     17.0
 4 AAPL   2014-01-07  19.4  19.5  19.2  19.3 317209200     16.8
 5 AAPL   2014-01-08  19.2  19.5  19.2  19.4 258529600     17.0
 6 AAPL   2014-01-09  19.5  19.5  19.1  19.2 279148800     16.7
 7 AAPL   2014-01-10  19.3  19.3  19.0  19.0 304976000     16.6
 8 AAPL   2014-01-13  18.9  19.4  18.9  19.1 378492800     16.7
 9 AAPL   2014-01-14  19.2  19.5  19.2  19.5 332561600     17.0
10 AAPL   2014-01-15  19.8  20.0  19.7  19.9 391638800     17.4
# ℹ 2,677 more rows
# ℹ Use `print(n = ...)` to see more rows

# get Facebook data for the past five years
from = today() - years(5)
Stocks <- tq_get("FB", get = "stock.prices", from = from)
Stocks
```

<span style='color:#008B45'>**Mutiple stocks**</span>

```r
# get historical data for multiple stocks. e.g. GAFA
tq_get(c("GOOGL","AMZN","FB","AAPL"), get="stock.prices")
```





`tq_index(x)` 	returns the stock symbols and various attributes for every stock in an index or exchange. Eighteen indexes and three exchanges are available.

`tq_index_options()` returns a list of stock indexes you can choose from.

`tq_exchange(x)` 	Get all stocks in a stock exchange in `tibble` format.

`tq_exchange_options()` returns a list of stock exchanges you can choose from. The options are `AMEX`, `NASDAQ` and `NYSE`.

```r
tq_index("SP500")
# A tibble: 504 × 8                                                                             
   symbol company                     identifier sedol   weight sector shares_held local_currency
   <chr>  <chr>                       <chr>      <chr>    <dbl> <chr>        <dbl> <chr>         
 1 AAPL   APPLE INC                   037833100  2046251 0.0686 -        171416583 USD           
 2 MSFT   MICROSOFT CORP              594918104  2588173 0.0654 -         88389092 USD           
 3 NVDA   NVIDIA CORP                 67066G104  2379504 0.0563 -        292528720 USD           
 4 AMZN   AMAZON.COM INC              023135106  2000019 0.0342 -        108870351 USD           
 5 META   META PLATFORMS INC CLASS A  30303M102  B7TL820 0.0242 -         26074570 USD           
 6 GOOGL  ALPHABET INC CL A           02079K305  BYVY8G0 0.0198 -         69889995 USD           
 7 BRK-B  BERKSHIRE HATHAWAY INC CL B 084670702  2073390 0.0187 -         21540450 USD           
 8 GOOG   ALPHABET INC CL C           02079K107  BYY88Y7 0.0166 -         58143623 USD           
 9 LLY    ELI LILLY + CO              532457108  2516152 0.0163 -          9488573 USD           
10 AVGO   BROADCOM INC                11135F101  BDZ78H9 0.0145 -         51827325 USD           
# ℹ 494 more rows
# ℹ Use `print(n = ...)` to see more rows

## This takes forever to run ... 
sp_500 <- tq_index("SP500") %>%
  tq_get(get = "stock.prices")
sp_500
> dim(sp_500)
[1] 1310963      15
# tq_index loads data for the last 10 years
sp_500$date %>% unique() %>% head()
[1] "2014-01-02" "2014-01-03" "2014-01-06" "2014-01-07" "2014-01-08" "2014-01-09"
sp_500$date %>% unique() %>% tail()
[1] "2024-08-28" "2024-08-29" "2024-08-30" "2024-09-03" "2024-09-04" "2024-09-05"
```

<img src="https://drive.google.com/thumbnail?id=1WZ_oNvKi6Rka_rLwcN9VXhWtWfkfKgzx&sz=w1000" alt="tq_index" style="display: block; margin-right: auto; margin-left: auto; zoom:100%;" />



`tq_transmute_fun_options()` 	to see which functions are available

Calculate monthly return.

```r
# calculate monthly return of single stock
tq_get(c("GOOGL"), get="stock.prices") %>%
  tq_transmute(select = adjusted,
               mutate_fun = periodReturn,
               period = "monthly",
               col_rename = "monthly_return")
```

Plot closing price.

```r
tq_get(c("GOOGL"), get="stock.prices") %>%
  ggplot(aes(date, close)) +
  geom_line()
```



**Group by and perform operations on individual stocks**

- from daily to monthly data

  ```r
  sp_500 %>%
    group_by(symbol) %>%
    tq_transmute(select = adjusted, mutate_fun = to.monthly, indexAt = "lastof")
  ```

  

- calculate monthly returns.

  ```R
  sp_500 %>%
    group_by(symbol) %>%
    tq_transmute(adjusted, mutate_fun = monthlyReturn)
  ```

  

___

`stats::ts(data, start, frequency)` base R function for time series.

```R
# quarterly data
> ts(1:10, start = c(1959, 2), frequency = 4) # 2nd Quarter of 1959
     Qtr1 Qtr2 Qtr3 Qtr4
1959         1    2    3
1960    4    5    6    7
1961    8    9   10   

# monthly data
> ts(cumsum(1 + round(rnorm(18), 2)), start = c(1954, 7), frequency = 12)
       Jan   Feb   Mar   Apr   May   Jun   Jul   Aug   Sep   Oct   Nov   Dec
1954                                      1.63  2.67  3.21  4.42  4.80  6.56
1955  7.51  8.53 10.12 10.81 12.23 12.52 13.89 13.90 14.75 15.58 16.37 19.34
```

Difference with `zoo`

- `ts` objects are regularly spaced and have numeric times and are good for months and quarters whereas `zoo` objects can be irregularly spaced and can use most common index classes.





___

### From tibble to `xts`

`xts(x, order.by)` `x` can only contain values in a *matrix* or *atomic vector* which places constraints on the values that can be used (generally numeric, but necessarily all of a single mode, i.e., not a mix of numeric and character values)

```r
xts(FF_factor, order.by = FF_factor$Date)
```

If `Date` is the 1st column 

```r
FF_factor %>% xts(x=.[,-1], order.by=.[[1]])
```



From `xts` to tibble

1. using `data.frame`. `Date` will be converted to `chr` first, then need to convert back to `Date`.

   ```r
   data.frame(price_data) %>% 
       rownames_to_column(var = "Date") %>% # this converts Date to a string
       mutate(Date = ymd(Date)) # convert back to Date type
   ```

2. using `as_tibble()`. `Date` will remain to be `Date`.

   ```r
   price_data %>% 
       as_tibble() %>% 
       add_column(Date=index(price_data), .before = 1)
   ```

3. `fortify.zoo` takes a zoo object and converts it into a data frame.

   ```r
   price_data %>% fortify.zoo()
   ```

   



**Fill missing values**

It is very common for daily prices to have missing values. The common practice is to fill missing values using the last non-NA observation.

```r
# Last obs. carried forward
na.locf(x)                

# Next obs. carried backward
na.locf(x, fromLast = TRUE) 
```



**Subset a period**

`window(x, start='YYYY-MM-DD', end='YYYY-MM-DD')` 	extract a subperiod window.

`x[between(index(x), start=ymd('YYYY-MM-DD'), end=('YYYY-MM-DD') ), ]` can also be used to subset a subperiod.

To get all observations in March 1970:

```r
# GSPC is xts
GSPC["1970-03"]
```

It is also possible to specify a range of timestamps using ‘/’ as the range separator, where both endpoints are optional: e.g.,

```r
# data before 1960-01-06
GSPC["/1960-01-06"]
# data after 2008-12-25
GSPC["2008-12-25/"]
```





**Change column names**

This can be done easily using either ` names ` , ` colnames ` , or ` setNames ` .

```r
my_xts <- with(reg_data, xts(AdjustedPrice, order.by = Date))
my_xts
colnames(my_xts) <- "AdjustedPrice"                  # opt1
names(my_xts) <- "AdjustedPrice"								     # opt2
my_xts <- my_xts %>% setNames("AdjustedPrice")			 # opt3 can be used in a pipe sequence
my_xts
```



`apply.monthly(x, FUN=colSums)`  apply one function periodically per column. 

- Note that `colSums` is used when calculating the sum of observations per period.
- If `FUN=sum`, then `sum` is not only applied to each time window, but also the sum of all columns is calculated.

```r
# from daily to monthly return
apply.monthly(R, Return.cumulative)
```





**Add new column** to `xts`: `xts$new_column <- col_data`.

Not convenient to do operations on `xts`. First convert to `data.frame`, then do operations as usual.





`to.monthly(x, indexAt='yearmon', name=NULL, OHLC = TRUE, ...)`

- `indexAt` 	Convert final index to new class or date. Can be set to one of the following: 

  | Option    | Meaning                                       |
  | --------- | --------------------------------------------- |
  | `yearmon` | The final index will then be `yearmon`        |
  | `yearqtr` | The final index will then be  `yearqtr`       |
  | `firstof` | the first time of the period                  |
  | `lastof`  | the last time of the period                   |
  | `startof` | the starting time in the data for that period |
  | `endof`   | the ending time in the data for that period   |

- `OHLC`        If an OHLC object should be returned.

```R
prices <- prices %>% na.locf() # fill missing values in daily prices
prices_monthly <- prices %>% to.monthly(indexAt = "last", OHLC = FALSE)
# alternative ways to achieve the same results as the last line
prices_monthly <- prices %>% xts::apply.monthly(last)
prices_monthly <- prices[xts::endpoints(prices, on="months"), ] 

head(prices_monthly)
                SPY      EFA      IJS      EEM      AGG
2012-12-31 127.7356 48.20629 74.81863 39.63340 97.98471
2013-01-31 134.2744 50.00364 78.82265 39.51723 97.37608
2013-02-28 135.9876 49.35931 80.10801 38.61464 97.95142
2013-03-28 141.1512 50.00364 83.39879 38.22143 98.04794
2013-04-30 143.8630 52.51315 83.50081 38.68614 98.99760
2013-05-31 147.2596 50.92775 87.08048 36.81840 97.01658
```

- Note that  `to.monthly` removes rows with missing values; be cautious with that.

`endpoints(prices, on="months")`   Extract index locations for an `xts` object that correspond to the *last* observation in each period specified by `on`.

- Alternatively, one could use `prices %>% apply.monthly(last) ` which takes the last day of each month in the time series. Data for all months is returned including those with NA in some of the time series.



`period.apply(samplexts, INDEX = endpoints(samplexts, on = "months"), FUN = mean, ...)` Apply a function periodically.

- `...`   Additional arguments for `FUN`.

`apply.monthly(samplexts, mean)`    This has the same results as the code above.





`quantmod::monthlyReturn(x, subset=NULL, type='arithmetic', leading=TRUE, ...)`	Given a set of prices, return **periodic returns**.

- `subset`	 an xts/ISO8601 style subset string.
- `type`	      type of returns: arithmetic (discrete) or log (continuous).
- `leading`	should incomplete leading period returns be returned



Now we’ll call `PerformanceAnalytics::Return.calculate(prices_monthly, method = "log")` to convert to returns and save as an object called `asset_returns_xts`. 

- Note this will give us log returns by the `method = "log"` argument, $z_t = \Delta \ln P_t = \ln P_t-\ln P_{t-1}=\ln\frac{P_t}{P_{t-1}}$.

- We could have used `method = "discrete"` to get simple returns, $r_t = \frac{P_t}{P_{t-1}}-1$. This is the default value.

- Relationship between $z_t$ and $r_t$: 
  $$
  \begin{align*}
  \ln(1+r_t)=z_t
  \end{align*}
  $$

```R
asset_returns_xts <- na.omit(Return.calculate(prices_monthly, method = "log"))

head(asset_returns_xts)
                   SPY         EFA          IJS          EEM           AGG
2013-01-31  0.04992311  0.03660641  0.052133484 -0.002935494 -0.0062309021
2013-02-28  0.01267821 -0.01296938  0.016175381 -0.023105250  0.0058910464
2013-03-28  0.03726766  0.01296938  0.040257940 -0.010235048  0.0009849727
2013-04-30  0.01903006  0.04896773  0.001222544  0.012085043  0.0096390038
2013-05-31  0.02333571 -0.03065563  0.041976371 -0.049483592 -0.0202136957
2013-06-28 -0.01343432 -0.02715331 -0.001402974 -0.054739116 -0.0157787232
```



`prices[endpoints(prices, on="months"), ]` converts daily to monthly prices.

`endpoints(x, on="month")` 

- `x` 	an `xts` object
- `on`      retrieve the last observation of each period. Supported periods include:  “us” (microseconds), “microseconds”, “ms” (milliseconds), “milliseconds”, “secs” (seconds), “seconds”, “mins” (minutes), “minutes”, “hours”, “days”, “weeks”, “months”, “quarters”, and “years”.



**Calculate returns by tidyverse**

```r
lag <- dplyr::lag # have to use dplyr::lag, base R lag has problems
returns <- prices_monthly %>% 
    group_by(ISIN) %>% 
    mutate(delta.P = c(NA, diff(AdjustedPrice)), # fill the first obs with NA
           lag.P = lag(AdjustedPrice),
           Return = delta.P/lag.P,
           Return2 = AdjustedPrice/lag(AdjustedPrice)-1,
           Return_log = log(AdjustedPrice)-lag(log(AdjustedPrice))
           ) 
```

**Note**: 

- Base R `lag` and `diff` works perfect with `xts`, but not ideal for groupped tibbles in tidyverse.
- Be careful whenever call `lag`, better to print check if you get the correct lag as the function from different packages has differing features and output.







___

## Portfolio Return

```r
w <- c(0.25, 0.25, 0.20, 0.20, 0.10)

portfolio_returns_xts_rebalanced_monthly <- 
  Return.portfolio(asset_returns_xts, weights = w, rebalance_on = "months") %>%
  `colnames<-`("returns") 
```





`PerformanceAnalytics::Return.portfolio(R=Return_xts, weights=NULL, rebalance_on, verbose=FALSE)` Using a time series of returns and any regular or irregular time series of weights for each asset, this function calculates the returns of a portfolio with the same periodicity of the returns data. Returns a time series of returns weighted by the `weights` parameter, or a list that includes intermediate calculations

- `R`   An xts, vector, matrix, data frame, timeSeries or zoo object of **asset returns**.

- `weights` 	  A time series or single-row matrix/vector containing asset weights, as decimal percentages, treated as beginning of period (BOP) weights.

  - If the user does not specify weights, an equal weight portfolio is assumed. 

  - if `weights` is an `xts` object, then any value passed to `rebalance_on` is ignored. 

    This is useful when you have varying assets across time.

    The `weights` index specifies the rebalancing dates, therefore a regular rebalancing frequency provided via `rebalance_on` is not needed and ignored.

    Note that `weights` and `R` should be matched by period.

  - **Irregular rebalancing** can be done by specifying a time series of weights. The function uses the date index of the weights for xts-style subsetting of rebalancing periods.

- `rebalance_on`  Default "none"; alternatively "daily" "weekly" "monthly" "annual" to specify calendar-period rebalancing supported by `endpoints`. 

  - Ignored if `weights` is an xts object that specifies the rebalancing dates.

- `verboase` 	If verbose is TRUE, return a list of intermediary calculations, such as asset contribution and asset value through time. 

  - The resultant list contains `$returns`, `$contributions`, `$BOP.Weight`, `$EOP.Weight`, `$BOP.Value`, and `$EOP.Value`.



`chartSeries`  plot an OHLC object.

```r
chartSeries(AMZN, type="candlesticks", subset='2016-05-18::2017-01-30', theme = chartTheme('white', up.col='green', dn.col='red'))
```

- `type="candlesticks"` 	can be `line`, `bar`, default to `candlesticks`.

  - A candle has four points of data:

    1. **Open** – the first trade during the period specified by the candle
    2. **High** – the highest traded price
    3. **Low** – the lowest traded price
    4. **Close** – the last trade during the period specified by the candle

    <img src="https://drive.google.com/thumbnail?id=1d5d3Q2PShsNiPF4rUU2Gk4P-2sUAaDmW&sz=w1000" alt="candle" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

    A candle has three parts: body (open/close prices), upper shadow (high price), and lower shadow (low price).

    The color of the body can tell them if the stock price is rising or falling. Usually, red stands for falling and green stands for rising.

- `theme = chartTheme("black")`   defaults to black theme.

  - `up.col`   up bar/candle color
  - `dn.col`   down bar/candle color



`charts.RollingPerformance(R, width=12)`  creates a rolling annualized returns chart, rolling annualized standard deviation chart, and a rolling annualized sharpe ratio chart.

Note that if your portfolio return is on a daily basis, first <span style='color:#008B45'>convert to monthly</span>, then run the rolling function. Otherwise, daily rolling frequency can be too computaionally intensive.



Rolling window

<img src="https://drive.google.com/thumbnail?id=1eOCGGKfxXJsuExtpVqPS0_NVKQ7RvY6I&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />

Rolling window estimation

<img src="https://drive.google.com/thumbnail?id=1qy1FaxutGBxwkXIhGeUVp6JfT69xrmBV&sz=w1000" alt="" style="display: block; margin-right: auto; margin-left: auto; zoom:80%;" />



## Plot TS

### `plot.xts`

```R
plot(msftSbuxMonthlyPrices, main="Monthly Closing Prices", 
     legend.loc="topleft")
```

The default plot style in `plot.xts()` is a single-panel plot with multiple series. You can also create multi-panel plots by setting the optional argument `multi.panel = TRUE` in the call to `plot.xts()`.

```R
plot(msftSbuxMonthlyPrices, 
     main = "Monthly Closing Prices", 
     multi.panel = TRUE)
```

Add legend to multiple series using `addLegend`

```r
plot_data <- reg_data %>% 
    select(eRi, rmrf) %>% 
    xts(order.by = the_group$Date)
plot_data

col_vec <- c("black", "red") # color series
plot.xts(plot_data, col = col_vec, main = "Excess Return on Asset and Market")
addLegend("topright", 
          legend.names = c("eRi", "rmrf"), 
          lty = c(1, 1), 
          lwd = c(2, 2),
          col = col_vec,
          bg = "white", # legend background
          bty = "o",    # box border style, doesn't work
          box.col = "white" # box border color
         )
```

Another example

```r
plot(x = basket[,"SPY.Close"], xlab = "Time", ylab = "Cumulative Return",
main = "Cumulative Returns", ylim = c(0.0, 2.5), major.ticks= "years",
        minor.ticks = FALSE, col = "red")
lines(x = basket[,"QQQ.Close"], col = "darkgreen")
lines(x = basket[,"GDX.Close"], col = "goldenrod")
lines(x = basket[,"DBO.Close"], col = "darkblue")
lines(x = basket[,"VWO.Close"], col = "darkviolet")
legend(x = 'topleft', legend = c("SPY", "QQQ", "GDX", "DBO", "VWO"),
      lty = 1, col = myColors)
```

- `main.timespan = FALSE` to remove the time span label in the top right corner.



`plot.xts` overrides figure margins set by `par`. If you want to change figure margins, set it inside `plot.xts` function.

`plot.xts` set `mar = c(3, 2, 0, 2)` by default.



### `autoplot`

For plotting `xts` objects, especially with multiple columns (data series), the **ggplot2** function `autoplot()` is especially convenient and easy:

```R
library(ggplot2)
# all series in one panel
autoplot(msftSbuxDailyPrices, facets = NULL) + 
  ggtitle("Daily Closing Prices") +
  ylab("Closing Price Per Share") +
  xlab("Year")
```

or produce a multi-panel plot call `autoplot()` with `facets = Series ~ .`:

```R
# one panel for each series
autoplot(msftSbuxDailyPrices, facets = Series ~ .) +
  ggtitle("Daily Closing Prices") +
  ylab("Closing Price Per Share") +
  xlab("Year")
```

More refined setting

Set colors

```r
# using autoplot from earlier, I placed it into an object
p <- autoplot(prcomp(df), data = iris, colour = 'Species', shape='Species', frame=T)
# then I added on scale_color_manual and scale_fill_manual with the wacky color combos that would never be publishable 
a + scale_fill_manual(values = c("#FF1BB3","#A7FF5B","#99554D")) + scale_color_manual(values = c("black","white","orange")) 
```

Set date breaks

```r
# auto date breaks every 6 mons
autoplot(plot_data, facets = NULL) +
    scale_color_manual(values = c("black", "red")) +
    scale_x_date(date_breaks = "6 month",
                 date_labels = "%b %y",
                 limits=c(ymd("2014-12-30"), ymd("2021-12-30") )
                 )

# explicit date breaks 
autoplot(plot_data, facets = NULL) +
    scale_color_manual(values = c("black", "red")) +
    scale_x_date(breaks = seq(from=index(plot_data)[1] %m-% months(1), 
                              to=tail(index(plot_data), 1), 
                              by="6 month"),
                 date_labels = "%b %y",
                 limits=c(ymd("2014-12-30"), ymd("2021-12-30") )
                 )
```



Simulate a autocorrelated time series.

`arima.sim(model, n, sd=1)`

- `model`   a list with the following elements. The coefficients must be provided through the elements `ar` and `ma`.

  - `order `   a vector of length 3 containing the `ARIMA(p, d, q)` order

    `p` specifies AR order;  `d` is the differencing order; `q` specifies MA order.

    `order = c(0, 0, 0)` will generate White Noise.

    `order = c(2, 0, 0)` will generate an AR(2) series.

    `order = c(0, 0, 2)` will generate an MA(2) series.

  - `ar` 	 a vector of length `p` containing the `AR(p)` coefficients

  - `ma`          a vector of length `q` containing the `MA(q)` coefficients

- `n` 	   length of simulated time series

- `sd`  	the standard deviation of the Gaussian errors. Defaults to 1.

- `rand.gen = rnorm`   can specify a function to generate the innovations. Defaults to normal distribution generator.

- `innov = rand.gen(n, ...)` can specify your own series of error here.

```r
# AR(1), with rho=0.7
ar.epsilon <- arima.sim(model = list(order = c(1,0,0), ar = 0.7), n = 200, sd=20)
# AR(2), with with parameters 1.5 and -.75
AR <- arima.sim(model = list(order = c(2, 0, 0), ar = c(1.5, -.75)), n = 200) 
# MA(3), with parameters 0.5, 0.4, and 0.2
sim_ma3_05 <- arima.sim(model = list(order = c(0,0,3), ma = c(0.5, 0.4, 0.2)), n=200)
```









