# Package index

## Key Functions

- [`census2020_get_data()`](https://ejanalysis.github.io/census2020download/reference/census2020_get_data.md)
  : Download and clean up US States,DC,PR, or Island Areas block data
  Census 2020 (for EJAM)
- [`census2020_save_datasets()`](https://ejanalysis.github.io/census2020download/reference/census2020_save_datasets.md)
  : Create separate data.tables, and optionally save them in the EJAM
  package

## Block data tables (created at run time, not bundled)

These data.tables are produced by census2020_save_datasets() for the
EJAM package; they are documented here but are not shipped with this
package.

- [`bgid2fips`](https://ejanalysis.github.io/census2020download/reference/bgid2fips.md)
  : Census FIPS code of each US Census 2020 block group
- [`blockid2fips`](https://ejanalysis.github.io/census2020download/reference/blockid2fips.md)
  : Census FIPS code of each US Census 2020 block
- [`blockpoints`](https://ejanalysis.github.io/census2020download/reference/blockpoints.md)
  : lat/lon location of internal point of each Census 2020 block, used
  in EJAM package
- [`blockwts`](https://ejanalysis.github.io/census2020download/reference/blockwts.md)
  : 2020 Census block weights (population as share of overall block
  group)
- [`quaddata`](https://ejanalysis.github.io/census2020download/reference/quaddata.md)
  : xyz location of internal point of each Census 2020 block, for
  spatial index in EJAM
