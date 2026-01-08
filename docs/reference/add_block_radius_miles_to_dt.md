# Create a new column in the data.table passed to this function (by reference)

Create a new column in the data.table passed to this function (by
reference)

## Usage

``` r
add_block_radius_miles_to_dt(dt, area_sqmi)
```

## Arguments

- dt:

  data.table

- area_sqmi:

  vector of numbers that are area in square miles.

## Value

NULL. The side effect is that a new column is created by reference in
the data.table referred to here as dt, but the data.table passed to this
function actually gets changed by reference in that calling environment
without this function needing to return anything.

## Details

Note the table magically gets updated just by calling the function – Do
not assign the function results to the object! That would just turn the
table into NULL.

## See also

[`radius_miles_from_area_sqmi()`](https://github.com/ejanalysis/census2020download/reference/radius_miles_from_area_sqmi.md)

## Examples

``` r
  passed_dt <- data.table::data.table(a = 1:10)
  x <- add_block_radius_miles_to_dt(passed_dt, 9001:9010)
  is.null(x)
  passed_dt
```
