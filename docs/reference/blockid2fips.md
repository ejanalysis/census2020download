# Census FIPS code of each US Census 2020 block

data.table for use in EJAM

## Details

See EJAM package for more info.

Created by
[`census2020_get_data()`](https://github.com/ejanalysis/census2020download/reference/census2020_get_data.md)
and
[`census2020_save_datasets()`](https://github.com/ejanalysis/census2020download/reference/census2020_save_datasets.md)

This package can create this data table but does not store it.

Rows: 8,174,955

Columns:

- blockid (for joins among tables
  [blockwts](https://github.com/ejanalysis/census2020download/reference/blockwts.md),
  [blockpoints](https://github.com/ejanalysis/census2020download/reference/blockpoints.md),
  [quaddata](https://github.com/ejanalysis/census2020download/reference/quaddata.md),
  blockid2fips) unique integer 1 through number of rows (blocks), used
  as a more efficient ID than a 15-character FIPS code.

- blockfips (15-character string of FIPS code)
