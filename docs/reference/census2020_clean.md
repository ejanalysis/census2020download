# Start to clean up download block data Renames columns, drops most, calculates total area.

Start to clean up download block data Renames columns, drops most,
calculates total area.

## Usage

``` r
census2020_clean(
  x,
  cols_to_keep = c("blockfips", "lat", "lon", "pop", "pop100", "area")
)
```

## Arguments

- x:

  data from
  [`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

- cols_to_keep:

  optional, which (renamed) columns to retain and return

## Value

data.table with these columns by default: blockfips lat lon pop area

## Details

Renames and drops columns based on names in
[census_col_names_map](https://github.com/ejanalysis/census2020download/reference/census_col_names_map.md)
and the parameter cols_to_keep, but see census_col_names_map for what
could be retained.

Returns table in data.table format.

area is in square meters and is sum of land and water areas.
