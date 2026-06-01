# Quiet R CMD check "no visible binding for global variable" NOTEs.
#
# These names fall into two groups:
#   1. Package data objects (lazy-loaded) referenced by bare name.
#   2. data.table columns referred to via non-standard evaluation (NSE),
#      e.g. blocks[ , area := arealand + areawater].
# Neither is a true global; this declaration just tells R CMD check so.
utils::globalVariables(c(
  # package data objects (see data/ and R/data_*.R)
  "lookup_states", "census_col_names_map",
  "census_col_names_map_vi", "census_col_names_map_as",
  "census_col_names_map_gu", "census_col_names_map_mp",
  # data.table NSE column names and special symbols
  ".", "..cols_to_keep_found",
  "area", "arealand", "areawater",
  "blockfips", "bgfips", "bgpop", "blockpop", "blockwt", "blockid", "bgid",
  "lat", "lon",
  "BLOCK_LAT_RAD", "BLOCK_LONG_RAD", "BLOCK_X", "BLOCK_Y", "BLOCK_Z",
  # optional EJAM helper, used only via exists() guard when EJAM is attached
  "create_quaddata"
))
