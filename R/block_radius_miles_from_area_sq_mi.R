#' simple formula to calculate radius given area
#' Just the square root of (area/pi)
#' @param area_sqmi vector of numbers that are the area of each block,
#'   in square miles.
#'   If area is available only in square meters, it can be converted like this:
#'
#'   area_sqmi <-
#'     census2020download:::area_sqmi_from_area_sqmeters(area_sqmeters)
#'
#' @seealso [add_block_radius_miles_to_dt()] [add_block_radius_miles_to_dt()]
#' @return vector of numbers same shape as input
#' @export
#'
block_radius_miles_from_area_sqmi <- function(area_sqmi) {
  sqrt(area_sqmi / pi)
}


area_sqmi_from_area_sqmeters <- function(area_sqmeters) {
  # area in the data.table blockwts after initial cleaning was called area
  # and was in square meters

  # These ways of checking the conversion all report the same thing,
  # the factor to divide by 2589988
  #
  # meters_per_mile^2  (using the meters_per_mile object 
  #  from the EJAMejscreenapi package)
  # format(1 /  convert(1, from = 'm2', towhat = 'mi2'), scientific = FALSE)
  #  # convert() is from the proxistat package
  # 1 %>% units::set_units(m2) %>% units::set_units(1 / mi2)

  area_sqmeters / 2589988
}
