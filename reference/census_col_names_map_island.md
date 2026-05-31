# Generic Census variable name map for Island Areas

A column-name lookup table (the same shape as
[census_col_names_map](https://github.com/ejanalysis/census2020download/reference/census_col_names_map.md))
kept for the Island Areas. The per-area maps
[census_col_names_map_vi](https://github.com/ejanalysis/census2020download/reference/census_col_names_map_vi.md),
[census_col_names_map_as](https://github.com/ejanalysis/census2020download/reference/census_col_names_map_as.md),
[census_col_names_map_gu](https://github.com/ejanalysis/census2020download/reference/census_col_names_map_gu.md),
and
[census_col_names_map_mp](https://github.com/ejanalysis/census2020download/reference/census_col_names_map_mp.md)
are used in preference to this generic version, because the Island Areas
encode the same variable with different Census field codes.

## Details

data.frame: 19 obs. of 3 variables:

\$ ftpname : chr "LOGRECNO" "GEOCODE" "AREALAND" "AREAWATR" etc

\$ rname : chr "logrecno" "blockfips" "arealand" "areawater" etc

\$ longname: chr "logical record number" "15 digit Census FIPS" etc

## See also

[census_col_names_map](https://github.com/ejanalysis/census2020download/reference/census_col_names_map.md)
