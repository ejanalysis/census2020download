# helper - just calculates radius from area Just the square root of (area/pi)

helper - just calculates radius from area Just the square root of
(area/pi)

## Usage

``` r
radius_miles_from_area_sqmi(area_sqmi)
```

## Arguments

- area_sqmi:

  vector of areas of blocks in square miles.

  If area is available only in square meters, it can be converted like
  this:

  area_sqmeters \<- 100000

  area_sqmi \<-
  census2020download:::area_sqmi_from_area_sqmeters(area_sqmeters)

  radius \<- radius_miles_from_area_sqmi(area_sqmi)

## Value

vector of numbers same shape as input

## See also

[`add_block_radius_miles_to_dt()`](https://github.com/ejanalysis/census2020download/reference/add_block_radius_miles_to_dt.md)
[`add_block_radius_miles_to_dt()`](https://github.com/ejanalysis/census2020download/reference/add_block_radius_miles_to_dt.md)
