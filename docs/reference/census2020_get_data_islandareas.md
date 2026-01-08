# Download and clean up VI,GU,MP,AS Island Areas block data Census 2020 (for EJAM)

Download and clean up VI,GU,MP,AS Island Areas block data Census 2020
(for EJAM)

## Usage

``` r
census2020_get_data_islandareas(
  folder = NULL,
  folderout = NULL,
  mystates = c("VI", "GU", "MP", "AS"),
  do_download = TRUE,
  do_unzip = TRUE,
  do_read = TRUE,
  do_clean = TRUE,
  overwrite = TRUE,
  sumlev = 150,
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

  Default is c('VI','GU','MP','AS')

- do_download:

  whether to do
  [`census2020_download_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_download_islandareas.md)

- do_unzip:

  whether to do
  [`census2020_unzip_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_unzip_islandareas.md)

- do_read:

  whether to do
  [`census2020_read_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

- do_clean:

  whether to do
  [`census2020_clean_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_clean.md)

- overwrite:

  passed to
  [`census2020_download_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_download_islandareas.md)

- sumlev:

  set to 150, meaning blockgroup not block, since no block data for
  island areas in these files!

- ...:

  passed to
  [`census2020_read_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

## Value

invisibly returns a data.table of US Census blocks with columns like
blockid lat lon pop area (area in square meters), or intermediate info
depending on do_read, do_clean, etc.

## Details

Table 1 with pop seems unavailable from this source for island areas.

## Examples

``` r
 if (FALSE) { # \dontrun{
 x = census2020_get_data()
 y = census2020_get_data_islandareas()
 } # }
```
