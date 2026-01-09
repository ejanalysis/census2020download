# Start to clean up download block data Renames columns, drops most, calculates total area.

Start to clean up download block data Renames columns, drops most,
calculates total area.

## Usage

``` r
census2020_clean(
  x,
  cols_to_keep = c("blockfips", "lat", "lon", "pop", "area"),
  sumlev = 750,
  mystates,
  census_col_names_defined = census_col_names_map
)
```

## Arguments

- x:

  data from
  [`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

- cols_to_keep:

  optional, which (renamed or not) columns to retain and return. "all'
  means keep them all. They will be renamed via census_col_names_map
  even if listed in cols_to_keep in the un-renamed form, like P0020002
  vs hisp.

- sumlev:

  just used by
  [`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
  to correctly name the fips column.

- mystates:

  just used by
  [`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
  to correctly rename the data columns.

## Value

data.table with these columns by default: blockfips lat lon pop area

## Details

Renames and drops columns based on names in census_col_names_defined
such as in
[census_col_names_map](https://github.com/ejanalysis/census2020download/reference/census_col_names_map.md)
for the US/DC/PR (or island area specific versions) and the parameter
cols_to_keep, but see census_col_names_map for what could be retained.

Returns table in data.table format.

area is in square meters and is sum of land and water areas.
