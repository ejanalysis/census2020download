# unzip Census 2020 zipped files already downloaded, for States and DC, PR

unzip Census 2020 zipped files already downloaded, for States and DC, PR

## Usage

``` r
census2020_unzip(
  zipfolder = NULL,
  folderout = NULL,
  filenumbers = 1,
  mystates = NULL
)
```

## Arguments

- zipfolder:

  Default is current working directory. Should contain .zip file(s)

- folderout:

  path to where you want to put files, created if does not exist

- filenumbers:

  a vector with any or all of 1,2,3 – default is file 1. File01 has
  Tables P1 and P2, which have population counts by race ethnicity.
  File02 has Tables P3, P4, and H1. File03 has Table P5.

- mystates:

  optional vector of 2letter state abbreviations for which to unzip

## Value

Vector of filenames of unzipped contents

## See also

[`census2020_download()`](https://github.com/ejanalysis/census2020download/reference/census2020_download.md)
[`census2020_read()`](https://github.com/ejanalysis/census2020download/reference/census2020_read.md)

## Examples

``` r
if (FALSE) { # \dontrun{
 # library(census2020download)
 census2020_download('./census2020zip', mystates = c('MD', 'DC'))
 census2020_unzip('./census2020zip','./census2020out')
 c2 <- census2020_read(folder = './census2020out', mystates = c('MD', 'DC'))
 save(c2, file = 'census2020blocks.rdata')
 dim(c2)
 str(c2)
 head(c2)
 sum(c2$POP100)
 plot(c2$INTPTLON[substr(c2$GEOCODE,1,2)=='24'], c2$INTPTLAT[substr(c2$GEOCODE,1,2)=='24'], pch='.')
 } # }
```
