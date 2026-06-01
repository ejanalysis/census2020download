#' @name bgid2fips
#' @docType data
#' @title Census FIPS code of each US Census 2020 block group
#' @description data.table created at run time for use in the EJAM package
#'   (not bundled with this package).
#' @details See EJAM package for more info.
#'
#'   Created by [census2020_get_data()] and [census2020_save_datasets()].
#'
#'   This package can create this data table but does not store it.
#'
#'   Columns:
#'
#'   - bgid The unique integer ID of each block group (for joins with [blockwts]),
#'   used as a more efficient ID than a 12-character FIPS code.
#'
#'   - bgfips (12-character string of block group FIPS code)
#'
NULL
