# Download Census 2020 data files from Census Bureau - For Island Areas VI GU MP AS

Download Census 2020 data files from Census Bureau - For Island Areas VI
GU MP AS

## Usage

``` r
census2020_download_islandareas(
  folder = NULL,
  mystates = c("VI", "GU", "MP", "AS"),
  allstates = c("VI", "GU", "MP", "AS"),
  baseurl = "https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/",
  urlmiddle = "demographic-and-housing-characteristics-file/",
  zipnames_suffix = "2020.dhc.zip",
  overwrite = TRUE
)
```

## Arguments

- folder:

  Default is a tempdir. Folder and subfolder for data are created if
  they do not exist.

- mystates:

  Character vector of 2 letter abbreviations, optional,

  - Default is VI GU MP AS

- allstates:

  Default is VI GU MP AS

- baseurl:

  default is the URL of the Census Bureau site's folder with the data

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

## See also

[`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
[`census2020_download()`](https://github.com/ejanalysis/census2020download/reference/census2020_download.md)

## Examples

``` r
if (FALSE) { # \dontrun{
  blocks_islandareas <- census2020_download_islandareas()
 } # }
```
