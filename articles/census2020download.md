# Getting started with census2020download

## What this package does

`census2020download` is a small set of helper functions used by the
[EJAM](https://ejanalysis.com/ejamdocs) package. It downloads the 2020
Census redistricting (PL94-171) files for US states, DC, and Puerto Rico
— plus the Demographic and Housing Characteristics (DHC) files for the
Island Areas (VI, GU, MP, AS) — then unzips, reads, and reshapes them
into compact `data.table`s.

The full pipeline has four steps, wrapped by the single function
[`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md):

1.  [`census2020_download()`](https://ejanalysis.github.io/census2020download/reference/census2020_download.md)
    — fetch the zip files from the Census Bureau
2.  [`census2020_unzip()`](https://ejanalysis.github.io/census2020download/reference/census2020_unzip.md)
    — unzip the data and geographic header files
3.  [`census2020_read()`](https://ejanalysis.github.io/census2020download/reference/census2020_read.md)
    — read and merge the pipe-delimited files
4.  [`census2020_clean()`](https://ejanalysis.github.io/census2020download/reference/census2020_clean.md)
    — rename columns, compute total area, subset

``` r

library(census2020download)
```

## The one-call pipeline

[`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md)
runs all four steps. Try it with a couple of small states so the
download is quick:

``` r

blocks <- census2020_get_data(c("DE", "DC"))
dim(blocks)
head(blocks)
```

By default it returns the columns `blockfips`, `lat`, `lon`, `pop`, and
`area` (area in square meters). To keep every available column —
including the race/ethnicity breakdown — pass `cols_to_keep = "all"`:

``` r

blocks_all <- census2020_get_data(c("DE", "DC"), cols_to_keep = "all")

# The race/ethnicity subgroups sum exactly to the total block population:
groups <- c("hisp", "nhwa", "nhba", "nhaiana", "nhaa",
            "nhnhpia", "nhotheralone", "nhmulti")
all.equal(blocks_all$pop, rowSums(blocks_all[, ..groups]))
```

## Controlling downloads

- `folder` — where zip files are saved (default: a temporary directory).
- `overwrite = FALSE` — skip downloading any zip already present in
  `folder`.
- `timeout` — seconds before an individual download times out (default
  180).

``` r

blocks <- census2020_get_data(
  c("DE", "DC"),
  folder = "~/census2020zip",
  overwrite = FALSE,
  timeout = 300
)
```

## Building the EJAM data tables

[`census2020_save_datasets()`](https://ejanalysis.github.io/census2020download/reference/census2020_save_datasets.md)
splits the cleaned blocks into the five tables EJAM uses, and computes
each block’s population weight within its parent block group:

``` r

tables <- census2020_save_datasets(blocks)
names(tables)
#> "bgid2fips" "blockid2fips" "blockpoints" "blockwts" "quaddata"
```

## Island Areas

Block-level data are not published for the Island Areas, so these come
at block-group resolution via a dedicated helper:

``` r

islands <- census2020_get_data_islandareas()  # VI, GU, MP, AS
```

[`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md)
can also accept a mix of mainland states and Island Areas and will
dispatch each to the appropriate reader.

## Technical references

See the help for
[`?census2020_read`](https://ejanalysis.github.io/census2020download/reference/census2020_read.md)
for links to the Census Bureau technical documentation describing the
files, tables, and variables.
