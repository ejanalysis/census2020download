# Download Census 2020 data files by State/DC/PR

Download Census 2020 data files by State/DC/PR

## Usage

``` r
census2020_download(
  folder = NULL,
  mystates = c(state.abb, "DC", "PR"),
  allstates = c(c(state.abb, "DC", "PR"), c("VI", "GU", "MP", "AS")),
  baseurl =
    "https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/",
  urlmiddle = "",
  zipnames_suffix = "2020.pl.zip",
  overwrite = TRUE
)
```

## Arguments

- folder:

  Default is a tempdir. Folder and subfolder for data are created if
  they do not exist.

- mystates:

  Default is 50 states + DC + PR here. Island Areas are VI GU MP AS.
  Character vector of 2 letter abbreviations.

- allstates:

  Default is same as mystates default.

- baseurl:

  Default is the URL of the folder with the data

- urlmiddle:

  Default is empty for States info, but for Island Areas, urlmiddle =
  "demographic-and-housing-characteristics-file/"

- zipnames_suffix:

  last part of the filenames Census provides - default should work

- overwrite:

  set to FALSE to skip download if filename already in folder, but note
  it does not check if any existing file is corrupt/size
  zero/obsolete/etc.

## Value

Effect is to download and save locally a number of data files.

## Details

Attempts to download some basic data files for specified states/etc.
from the US Census Bureau's site for Decennial Census file data.

see
(https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf)

see
(https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/american-samoa/demographic-and-housing-characteristics-file/2020-iac-dhc-readme.pdf)

## See also

[`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
[`census2020_download_islandareas()`](https://github.com/ejanalysis/census2020download/reference/census2020_download_islandareas.md)

## Examples

``` r
if (FALSE) { # \dontrun{
 # library(census2020download)
 census2020_download('./census2020zip', mystates = c('RI', 'DE'))
 census2020_unzip('./census2020zip','./census2020out')
 c2 <- census2020_read(folder = './census2020out', mystates = c('RI', 'DE'))
 save(c2,file = 'census2020blocks.rdata')
 dim(c2)
 str(c2)
 head(c2)
 sum(c2$POP100)
 plot(
   c2$INTPTLON[substr(c2$GEOCODE,1,2)=='10'],
   c2$INTPTLAT[substr(c2$GEOCODE,1,2)=='10'], pch='.')
 } # }
```
