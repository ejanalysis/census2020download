#' @name census_col_names_map_island
#' @docType data
#' @title Generic Census variable name map for Island Areas
#' @description
#'   A column-name lookup table (the same shape as [census_col_names_map])
#'   kept for the Island Areas. The per-area maps
#'   [census_col_names_map_vi], [census_col_names_map_as],
#'   [census_col_names_map_gu], and [census_col_names_map_mp] are used in
#'   preference to this generic version, because the Island Areas encode the
#'   same variable with different Census field codes.
#' @details
#'
#'  data.frame:	19 obs. of  3 variables:
#'
#'  $ ftpname : chr  "LOGRECNO" "GEOCODE" "AREALAND" "AREAWATR" etc
#'
#'  $ rname   : chr  "logrecno" "blockfips" "arealand" "areawater" etc
#'
#'  $ longname: chr  "logical record number" "15 digit Census FIPS"  etc
#'
#'  Caution: The same indicator such as "nhba" is assigned
#'  a different P00* number depending on which geographic area the data came from.
#'  For example, "nhba" is
#'
#'  P0020006 in the US DHC data,
#'
#'  P0050005 in the VI DHC data, and
#'
#'  P0050027 in the Guam DHC data
NULL
