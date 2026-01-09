# Create separate data.tables, and optionally save them in the EJAM package This is just done when Census FIPS or bounds or points change.

Create separate data.tables, and optionally save them in the EJAM
package This is just done when Census FIPS or bounds or points change.

## Usage

``` r
census2020_save_datasets(
  x,
  metadata = NULL,
  add_metadata = TRUE,
  save_as_data_for_package = FALSE,
  overwrite = TRUE,
  keep_pop = FALSE
)
```

## Arguments

- x:

  a single data.table called blocks that is from
  [`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md),
  with colnames blockfips, pop, area, lat, lon

- metadata:

  default is Census 2020 related, tries to use [EJAM
  package](https://ejanalysis.com/ejam-code)

- add_metadata:

  logical, whether to add EJAM-related metadata about date and version

- save_as_data_for_package:

  logical, whether to do
  [`usethis::use_data()`](https://usethis.r-lib.org/reference/use_data.html)
  here

- overwrite:

  default is TRUE, but only relevant if usethis = TRUE

- keep_pop:

  set to TRUE to keep the blockpop (population counts) column, but it is
  not used by EJAM except here to create the weights before it is
  dropped by default.

## Value

A named list of these huge data.tables for the EJAM package:

- [bgid2fips](https://ejanalysis.github.io/EJAM/reference/bgid2fips.html)

- [blockid2fips](https://github.com/ejanalysis/census2020download/reference/blockid2fips.md)https://ejanalysis.github.io/EJAM/reference/blockid2fips.html

- [blockpoints](https://github.com/ejanalysis/census2020download/reference/blockpoints.md)https://ejanalysis.github.io/EJAM/reference/blockpoints.html

- [blockwts](https://github.com/ejanalysis/census2020download/reference/blockwts.md)https://ejanalysis.github.io/EJAM/reference/blockwts.html

- [quaddata](https://github.com/ejanalysis/census2020download/reference/quaddata.md)https://ejanalysis.github.io/EJAM/reference/quaddata.html

## See also

`census2020_save_datasets()` creates individual data.tables, after
[`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
has done these:

- [`census2020_download()`](https://github.com/ejanalysis/census2020download/reference/census2020_download.md)

- [`census2020_unzip()`](https://github.com/ejanalysis/census2020download/reference/census2020_unzip.md)

- [`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

- [`census2020_clean()`](https://github.com/ejanalysis/census2020download/reference/census2020_clean.md)
