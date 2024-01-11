#' @name blockid2fips
#' @docType data
#' @title Census FIPS code of each US Census 2020 block
#' @description data.table for use in EJAM
#' @details See EJAM package for more info.
#' 
#'   Created by [census2020_get_data()] and [census2020_save_datasets()]
#'   
#'   This package can create this data table but does not store it.
#'   
#'   Rows: 8,174,955
#'   
#'   Columns:
#'   
#'   - blockid (for joins among tables [blockwts], [blockpoints], [quaddata], [blockid2fips])
#'   unique integer 1 through number of rows (blocks), 
#'   used as a more efficient ID than a 15-character FIPS code.
#'   
#'   - blockfips (15-character string of FIPS code)
#' 
NULL
