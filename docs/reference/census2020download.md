# 2020 Census Blocks and Tools to Download from Census Bureau

Basic functions for downloading from Census website, unzipping, reading
the 2020 Census data for some or all US States into a single data.table,
and splitting into a few tables for use in the EJAM package.

## Details

This package is just a set of helper functions used by the EJAM package.

It creates block datasets (and some blockgroup tables) for use in the
EJAM package. It has basic functions for downloading from Census,
unzipping, reading the 2020 Census data for some or all US States into
data.table format.

It can retain a few key variables like

- lat and lon of block internal point

- FIPS codes

- population count or weight

- area (or effective radius)

For more information see

- [census2020download package
  documentation](https://ejanalysis.github.io/census2020download/reference/census2020download.html)

- [census2020download package github
  repository](https://github.com/ejanalysis/census2020download)

- [EJAM package](https://ejanalysis.com/EJAM)

- [Census vs ACS geos
  info](https://www.census.gov/programs-surveys/acs/geography-acs/geography-boundaries-by-year.html)

*Key functions and data.tables created include*

- [`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
  Download/ Unzip/ Read/ Clean data on all US Census blocks

- [`census2020_save_datasets()`](https://github.com/ejanalysis/census2020download/reference/census2020_save_datasets.md)
  Use the data to create separate data.tables, and save for use in the
  EJAM package.

*Key data.table objects created:*

- [blockid2fips](https://github.com/ejanalysis/census2020download/reference/blockid2fips.md) -
  data.table with FIPS code to blockid lookup

- [blockpoints](https://github.com/ejanalysis/census2020download/reference/blockpoints.md) -
  data.table with latitude and longitude of internal points

- [quaddata](https://github.com/ejanalysis/census2020download/reference/quaddata.md) -
  data.table with xyz format locations of blocks, used to create spatial
  index of blocks in the EJAM package.

- [blockwts](https://github.com/ejanalysis/census2020download/reference/blockwts.md) -
  data.table with Census 2020 population-based weight as fraction of
  parent block group population, and size of block

## See also

Useful links:

- <https://github.com/ejanalysis/census2020download>

- <https://ejanalysis.github.io/census2020download/>

## Author

**Maintainer**: Mark Corrales <info@ejanalysis.com>
