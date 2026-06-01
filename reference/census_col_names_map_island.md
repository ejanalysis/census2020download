# Generic Census variable name map for Island Areas

A column-name lookup table (the same shape as
[census_col_names_map](https://ejanalysis.github.io/census2020download/reference/census_col_names_map.md))
kept for the Island Areas. The per-area maps
[census_col_names_map_vi](https://ejanalysis.github.io/census2020download/reference/census_col_names_map_vi.md),
[census_col_names_map_as](https://ejanalysis.github.io/census2020download/reference/census_col_names_map_as.md),
[census_col_names_map_gu](https://ejanalysis.github.io/census2020download/reference/census_col_names_map_gu.md),
and
[census_col_names_map_mp](https://ejanalysis.github.io/census2020download/reference/census_col_names_map_mp.md)
are used in preference to this generic version, because the Island Areas
encode the same variable with different Census field codes.

## Details

data.frame: 19 obs. of 3 variables:

\$ ftpname : chr "LOGRECNO" "GEOCODE" "AREALAND" "AREAWATR" etc

\$ rname : chr "logrecno" "blockfips" "arealand" "areawater" etc

\$ longname: chr "logical record number" "15 digit Census FIPS" etc

Caution: The same indicator such as "nhba" is assigned a different P00\*
number depending on which geographic area the data came from. For
example, "nhba" is

P0020006 in the US DHC data,

P0050005 in the VI DHC data, and

P0050027 in the Guam DHC data
