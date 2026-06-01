# like census2020_unzip() but for Island Areas

like census2020_unzip() but for Island Areas

## Usage

``` r
census2020_unzip_islandareas(
  zpathslocal,
  folderout,
  filegeogrep = "geo2020\\.dhc$",
  filedatagrep = "[^o]2020\\.dhc$"
)
```

## Arguments

- zpathslocal:

  zip file paths with filename, unlike in
  [`census2020_unzip()`](https://ejanalysis.github.io/census2020download/reference/census2020_unzip.md)

- folderout:

  see
  [`census2020_unzip()`](https://ejanalysis.github.io/census2020download/reference/census2020_unzip.md)

- filegeogrep:

  regular expression matching the geographic header file names to list
  after unzipping (default matches the `geo2020.dhc` files)

- filedatagrep:

  regular expression matching the data file names to list after
  unzipping (default matches the `2020.dhc` data files)

## Value

see
[`census2020_unzip()`](https://ejanalysis.github.io/census2020download/reference/census2020_unzip.md)
