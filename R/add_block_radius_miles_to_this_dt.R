


#' Create a new column in the data.table passed to this function (by reference)
#' @details Note the table magically gets updated just by calling the function
#'   -- Do not assign the function results to the object!
#'   That would just turn the table into NULL.
#' @param dt data.table
#' @param area_sqmi vector of numbers that are area in square miles.
#'   If area were in square meters, it could be converted like this:
#'
#'   area_sqmi <-
#'     census2020download:::area_sqmi_from_area_sqmeters(area_sqmeters)
#'
#' @return NULL. The side effect is that a new column is created by reference in
#'   the data.table referred to here as dt, but
#'   the data.table passed to this function
#'   actually gets changed by reference in that calling environment
#'   without this function needing to return anything.
#' @export
#' @examples
#'   passed_dt <- data.table::data.table(a = 1:10)
#'   x <- add_block_radius_miles_to_dt(passed_dt, 9001:9010)
#'   is.null(x)
#'   passed_dt
#'
#' @seealso  [block_radius_miles_from_area_sqmi()]
add_block_radius_miles_to_dt <- function(dt, area_sqmi) {

  # if needed, note that
  #  area_sqmi <- dt$area / (EJAMejscreenapi::meters_per_mile^2)

  # This will add the new column by reference,
  # which adds the new column to the data.table in the calling environment !!

  # area_sqmi <- blockwts$area / (EJAMejscreenapi::meters_per_mile^2)
  # blockwts[ , block_radius_miles :=  sqrt(area_sqmi / pi)]
  block_radius_miles <- NULL # to make the lintr warning go away
  dt[, block_radius_miles := block_radius_miles_from_area_sqmi(area_sqmi)]
  return(NULL)
}
