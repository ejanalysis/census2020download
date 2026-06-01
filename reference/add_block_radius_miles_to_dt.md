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

[`radius_miles_from_area_sqmi()`](https://ejanalysis.github.io/census2020download/reference/radius_miles_from_area_sqmi.md)

## Examples

``` r
  passed_dt <- data.table::data.table(a = 1:10)
  x <- census2020download:::add_block_radius_miles_to_dt(passed_dt, 9001:9010)
  is.null(x)
#> [1] TRUE
  passed_dt
#>         a block_radius_miles
#>     <int>              <num>
#>  1:     1           53.52670
#>  2:     2           53.52967
#>  3:     3           53.53264
#>  4:     4           53.53562
#>  5:     5           53.53859
#>  6:     6           53.54156
#>  7:     7           53.54453
#>  8:     8           53.54751
#>  9:     9           53.55048
#> 10:    10           53.55345
```
