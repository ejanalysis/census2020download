# Create separate data.tables, and optionally save them in the EJAM package

This is just done when Census FIPS or bounds or points change.

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
  [`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md),
  with colnames blockfips, pop, area, lat, lon

- metadata:

  default is Census 2020 related, tries to use [EJAM
  package](https://ejanalysis.com/ejamdocs)

- add_metadata:

  logical, whether to add EJAM-related metadata about date and version

- save_as_data_for_package:

  logical, whether to do `usethis::use_data()` here

- overwrite:

  default is TRUE, but only relevant if save_as_data_for_package = TRUE

- keep_pop:

  set to TRUE to keep the blockpop (population counts) column, but it is
  not used by EJAM except here to create the weights before it is
  dropped by default.

## Value

A named list of these (large) data.tables for the EJAM package. They are
created at run time and are not bundled with this package; see each help
topic for its columns:

- [bgid2fips](https://ejanalysis.github.io/census2020download/reference/bgid2fips.md)

- [blockid2fips](https://ejanalysis.github.io/census2020download/reference/blockid2fips.md)

- [blockpoints](https://ejanalysis.github.io/census2020download/reference/blockpoints.md)

- [blockwts](https://ejanalysis.github.io/census2020download/reference/blockwts.md)

- [quaddata](https://ejanalysis.github.io/census2020download/reference/quaddata.md)

## See also

`census2020_save_datasets()` creates individual data.tables, after
[`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md)
has done these:

- [`census2020_download()`](https://ejanalysis.github.io/census2020download/reference/census2020_download.md)

- [`census2020_unzip()`](https://ejanalysis.github.io/census2020download/reference/census2020_unzip.md)

- [`census2020_read()`](https://ejanalysis.github.io/census2020download/reference/census2020_read.md)

- [`census2020_clean()`](https://ejanalysis.github.io/census2020download/reference/census2020_clean.md)
