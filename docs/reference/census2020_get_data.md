# Download and clean up US States,DC,PR, or Island Areas block data Census 2020 (for EJAM)

Download and clean up US States,DC,PR, or Island Areas block data Census
2020 (for EJAM)

## Usage

``` r
census2020_get_data(
  folder = NULL,
  folderout = NULL,
  mystates = c(state.abb, "DC", "PR"),
  do_download = TRUE,
  do_unzip = TRUE,
  do_read = TRUE,
  do_clean = TRUE,
  overwrite = TRUE,
  ...
)
```

## Arguments

- folder:

  For downloaded files. Default is a tempdir. Folder is created if it
  does not exist.

- folderout:

  path for assembled results files, default is what folder was set to.

- mystates:

  default is DC, PR, and the 50 states – lacks the island areas
  c('VI','GU','MP','AS') – but census2020_get_data() can in some cases
  handle a mix of States/DC/PR and/or island areas via helper function
  [`census2020_get_data_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data_islandareas.md),
  returning either type of data, or a combined data.table if both are
  requested. But block resolution is not available from these files for
  island areas, so default for those is to get block groups, which would
  not make sense to mix with blocks for states. And Table 1 with pop
  seems unavailable from this source for island areas.

- do_download:

  whether to do
  [`census2020_download()`](https://github.com/ejanalysis/census2020download/reference/census2020_download.md)

- do_unzip:

  whether to do
  [`census2020_unzip()`](https://github.com/ejanalysis/census2020download/reference/census2020_unzip.md)

- do_read:

  whether to do
  [`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

- do_clean:

  whether to do
  [`census2020_clean()`](https://github.com/ejanalysis/census2020download/reference/census2020_clean.md)

- overwrite:

  passed to
  [`census2020_download()`](https://github.com/ejanalysis/census2020download/reference/census2020_download.md)

- ...:

  passed to
  [`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

## Value

invisibly returns a data.table of US Census blocks with columns like
blockid lat lon pop area (area in square meters), or just intermediate
info depending on do_read, do_clean, etc.

## Details

      To create certain data tables used by EJAM,
      EJAM uses scripts like EJAM/data-raw/datacreate_....R
      to do something like this:

      blocks <- census2020_get_data() # default excludes Island Areas
      mylist <- census2020_save_datasets(blocks)

      bgid2fips    = mylist$bgid2fips
      blockid2fips = mylist$blockid2fips
      blockpoints  = mylist$blockpoints
      blockwts     = mylist$blockwts
      quaddata     = mylist$quaddata

## See also

[`census2020_save_datasets()`](https://github.com/ejanalysis/census2020download/reference/census2020_save_datasets.md)
creates individual data.tables, after `census2020_get_data()` has done
these:

- [`census2020_download()`](https://github.com/ejanalysis/census2020download/reference/census2020_download.md)

- [`census2020_unzip()`](https://github.com/ejanalysis/census2020download/reference/census2020_unzip.md)

- [`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

- [`census2020_clean()`](https://github.com/ejanalysis/census2020download/reference/census2020_clean.md)
  . and see
  [`census2020_get_data_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data_islandareas.md)

## Examples

``` r
 if (FALSE) { # \dontrun{
 x = census2020_get_data()
 y = census2020_get_data()
 } # }
```
