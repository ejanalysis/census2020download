# Download and clean up VI,GU,MP,AS Island Areas block data Census 2020 (for EJAM)

Download and clean up VI,GU,MP,AS Island Areas block data Census 2020
(for EJAM)

## Usage

``` r
census2020_get_data_islandareas(
  mystates = c("VI", "GU", "MP", "AS"),
  folder = NULL,
  folderout = NULL,
  do_download = TRUE,
  do_unzip = TRUE,
  do_read = TRUE,
  do_clean = TRUE,
  overwrite = TRUE,
  sumlev = 150
)
```

## Arguments

- mystates:

  Default is c('VI','GU','MP','AS') data were at
  https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/
  Also see page a-22 in
  https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/supplemental-demographic-and-housing-characteristics-file/2020census-supplemental-dhc-techdoc.pdf

- folder:

  For downloaded files. Default is a tempdir. Folder is created if it
  does not exist.

- folderout:

  path for assembled results files, default is what folder was set to.

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

  set to 150, meaning blockgroup not block.

  However, note this from Census Bureau: "With this release of the 2020
  IAC Demographic and Housing Characteristics Summary File, the Census
  Bureau provides additional demographic and housing characteristics for
  the Island Areas down to the block, block group, and census tract
  levels." Despite this, it appears that H1 (housing) table data are
  provided at block resolution, but P1 (population count) is only at
  block group, tract, etc. according to page 3 of the [Island Areas
  Tech.
  Doc.](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf)

## Value

invisibly returns a data.table of US Census units with columns like the
id, lat lon pop area (area in square meters), or intermediate info
depending on do_read, do_clean, etc.

## Details

Table 1 with pop seems unavailable from this source for island areas if
trying to use the same approach to reading files as done for the US
States.

For Island areas, see
https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf
or e.g.,
(https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/american-samoa/demographic-and-housing-characteristics-file/2020-iac-dhc-readme.pdf)

For technical details on the files downloaded and tables and variables,
see the detailed references in the help for
[`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md).

## Examples
