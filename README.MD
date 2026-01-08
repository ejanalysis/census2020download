# Download all Census 2020 blocks to use in EJAM


This package is just a set of helper functions used by the [EJAM](https://ejanalysis.com/EJAM) package.

It creates block datasets (and some blockgroup tables) for use in the EJAM package.
It has basic functions for downloading from Census Bureau, 
unzipping, reading the 2020 Census data for some or all US States
into data.table format. Also some limited tools for Island Areas (VI,GU,MP,AS).

It can retain a few key variables like 

- lat and lon of block internal point
- FIPS codes
- population count or weight
- area (or effective radius)


For more information see 

- [census2020download package documentation](https://ejanalysis.github.io/census2020download/reference/census2020download.html)
- [EJAM package documentation](https://ejanalysis.com/docs)
- [Census vs ACS geos info](https://www.census.gov/programs-surveys/acs/geography-acs/geography-boundaries-by-year.html)


 *Key functions and data.tables created include*

 - `census2020_get_data()` Download/ Unzip/ Read/ Clean data on
   all US Census blocks
 - `census2020_save_datasets()` Use the data to create separate data.tables,
   and save for use in the EJAM package.

 *Key data.table objects created:*

 - `blockid2fips` - data.table with FIPS code to blockid lookup
 - `blockpoints`  - data.table with latitude and longitude of internal points
 - `quaddata` - data.table with xyz format locations of blocks,
   used to create spatial index of blocks in the EJAM package.
 - `blockwts` - data.table with Census 2020 population-based weight
   as fraction of parent block group population, and size of block
