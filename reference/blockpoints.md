# lat/lon location of internal point of each Census 2020 block, used in EJAM package

data.table created at run time for use in the EJAM package (not bundled
with this package).

## Details

See EJAM package for more info.

Created by
[`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md)
and
[`census2020_save_datasets()`](https://ejanalysis.github.io/census2020download/reference/census2020_save_datasets.md)

This package can create this data table but does not store it.

Rows: 8,174,955

Columns:

- blockid (for joins among tables
  [blockwts](https://ejanalysis.github.io/census2020download/reference/blockwts.md),
  blockpoints,
  [quaddata](https://ejanalysis.github.io/census2020download/reference/quaddata.md),
  [blockid2fips](https://ejanalysis.github.io/census2020download/reference/blockid2fips.md))
  unique integer 1 through number of rows (blocks), used as a more
  efficient ID than a 15-character FIPS code.

- lat Latitude decimal degrees

- lon Longitude decimal degrees
