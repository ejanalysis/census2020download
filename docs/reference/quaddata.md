# xyz location of internal point of each Census 2020 block, for spatial index in EJAM

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
  quaddata,
  [blockid2fips](https://github.com/ejanalysis/census2020download/reference/blockid2fips.md))
  unique integer 1 through number of rows (blocks), used as a more
  efficient ID than a 15-character FIPS code.

- x, y, z coordinates as shown below:


      str(quaddata)

      Classes ‘data.table’ and 'data.frame':    8174955 obs. of  4 variables:

       $ BLOCK_X: num  205 205 204 204 204 etc
       $ BLOCK_Z: num  2125 2125 2125 2126 2126 etc
       $ BLOCK_Y: num  -3334 -3334 -3334 -3334 -3334 etc
       $ blockid: int  1 2 3 4 5 6 7 8 9 10 etc

         - attr(*, ".internal.selfref")=<externalptr>
         - attr(*, "sorted")= chr "blockid"
         - attr(*, "census_version")= num 2020
         - attr(*, "acs_version")= chr "2016-2020"
         - attr(*, "ejscreen_version")= chr "2.1"
         - attr(*, "ejscreen_releasedate")= chr "September 2022"
