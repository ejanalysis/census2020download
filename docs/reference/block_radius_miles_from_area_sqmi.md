# simple formula to calculate radius given area Just the square root of (area/pi)

simple formula to calculate radius given area Just the square root of
(area/pi)

## Usage

``` r
block_radius_miles_from_area_sqmi(area_sqmi)
```

## Arguments

- area_sqmi:

  vector of numbers that are the area of each block, in square miles. If
  area is available only in square meters, it can be converted like
  this:

  area_sqmi \<-
  census2020download:::area_sqmi_from_area_sqmeters(area_sqmeters)

## Value

vector of numbers same shape as input

## See also

[`add_block_radius_miles_to_dt()`](https://github.com/ejanalysis/census2020download/reference/add_block_radius_miles_to_dt.md)
[`add_block_radius_miles_to_dt()`](https://github.com/ejanalysis/census2020download/reference/add_block_radius_miles_to_dt.md)
