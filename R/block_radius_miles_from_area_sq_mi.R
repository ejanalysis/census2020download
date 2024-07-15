

#' helper - just calculates radius from area
#' Just the square root of (area/pi)
#' @param area_sqmi vector of areas of blocks in square miles.
#' 
#'   If area is available only in square meters, it can be converted like this:
#'   
#'   area_sqmeters <- 100000
#'   
#'   area_sqmi <-
#'     census2020download:::area_sqmi_from_area_sqmeters(area_sqmeters)
#' 
#'   radius <- radius_miles_from_area_sqmi(area_sqmi)
#'   
#' @seealso [add_block_radius_miles_to_dt()] [add_block_radius_miles_to_dt()]
#' @return vector of numbers same shape as input
#' 
#'
radius_miles_from_area_sqmi <- function(area_sqmi) {
  
  sqrt(area_sqmi / pi)
  
}
#################################################################### #


#' helper - converts units
#' @details
#'   area in the data.table blockwts after initial cleaning was 
#'   called area and was in square meters
#' @param area_sqmeters vector of areas in square meters
#' @return vector of areas in square miles
#' 
#'
area_sqmi_from_area_sqmeters <- function(area_sqmeters) {
  
  # EJAM:::convert_units(
  #   EJAM:::convert_units(1, from = 'm2', towhat = 'mi2'), 
  #   from = 'mi2', towhat = 'm2')
  
  # EJAM:::convert_units(1, "square miles", "square meters")
  # 2589988
  
  area_sqmeters / 2589988
}
#################################################################### #
