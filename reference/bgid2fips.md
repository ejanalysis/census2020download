# Census FIPS code of each US Census 2020 block group

data.table created at run time for use in the EJAM package (not bundled
with this package).

## Details

See EJAM package for more info.

Created by
[`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md)
and
[`census2020_save_datasets()`](https://ejanalysis.github.io/census2020download/reference/census2020_save_datasets.md).

This package can create this data table but does not store it.

Columns:

- bgid The unique integer ID of each block group (for joins with
  [blockwts](https://ejanalysis.github.io/census2020download/reference/blockwts.md)),
  used as a more efficient ID than a 12-character FIPS code.

- bgfips (12-character string of block group FIPS code)
