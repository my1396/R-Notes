## Panel

**Declare panel data**

You must `xtset` your data before you can use other `xt` commands.

`xtset panelvar timevar [, tsoptions]` declares the data to be a panel in which the order of observations is relevant. When you specify `timevar`, you can then use time series operators (e.g., `L`, `D`).

`tsoptions` can be specified using

- unit of `timevar`, e.g., `yearly`, `quarterly`.
- `delta(#)` specifies the time increment between observations in `timevar` units.

**Example**

To set a panel dataset:

```stata
// string variables not allowed in varlist; need to convert them to numeric
. egen float country_id = group(iso)
. egen float year_id = group(year)

. xtset country_id year_id, yearly

Panel variable: country_id (strongly balanced)
 Time variable: year_id, 1 to 59
         Delta: 1 year
```

**Menu**

Statistics > Longitudinal/panel data > Setup and utilities > Declare dataset to be panel data

- `panelvar`  panel variable that identifies the unit
- `timevar` optional time variable that identifies the time within panels

Use `describe` to show an overview of data structure.

Sometimes numbers will get recorded as string variables, making it impossible to do almost any command.

```stata
destring [varlist], {gen(newvarlist) | replace} [options]
```

- `gen(newvarlist)` generate new variables for each variable in `varlist`.
- `replace` replace string variables with numeric variables
- `ignore("chars")` specifies nonnumeric characters be removed.

```stata
// from logd_gdp to rad, convert to numeric, replace "NA" with missing
destring logd_gdp-rad, replace ignore(`"NA"')
```



--------------------------------------------------------------------------------

`xtreg` is Stata's feature for fitting linear models for panel data.

`xtreg, fe` estimates the parameters of fixed-effects models:


```stata
xtreg depvar [indepvars] [if] [in] [weight] , fe [FE_options]
```

Menu: Statistics > Longitudinal/panel data > Linear models > Linear regression (FE, RE, PA, BE, CRE)

Options

- `vce(robust)` use clustered variance that allows for intragroup correlation within
  groups.
  
    By default, SE uses OLS estimates.



