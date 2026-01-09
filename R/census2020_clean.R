#' Start to clean up download block data
#' Renames columns, drops most, calculates total area.
#' @details
#'   Renames and drops columns based on names in census_col_names_defined
#'   such as in [census_col_names_map] for the US/DC/PR (or island area specific versions)
#'   and the parameter cols_to_keep,
#'   but see census_col_names_map for what could be retained.
#'
#'   Returns table in data.table format.
#'
#'   area is in square meters and is sum of land and water areas.
#'
#' @param x data from [census2020_read()]
#' @param cols_to_keep optional, which (renamed or not) columns to retain and return.
#'   "all' means keep them all. They will be renamed via census_col_names_map
#'   even if listed in cols_to_keep in the un-renamed form, like P0020002 vs hisp.
#' @param sumlev just used by [census2020_get_data()] to correctly name the fips column.
#' @param mystates just used by [census2020_get_data()] to correctly rename the data columns.
#' @return data.table with these columns by default:  blockfips lat lon pop area
#' @import data.table
#'
#' @aliases census2020_clean_islandareas
#'
census2020_clean <- function(x, cols_to_keep = c("blockfips", "lat", "lon", "pop", "area"), sumlev = 750, mystates, census_col_names_defined = census_col_names_map) {

 # Note variables are named differently in each source -  US PL (default) vs US DHC vs IslandAreas DHC & maybe even among island areas

  # PL94_171Redistricting_National  p. 6-29
  ## see https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_NationalTechDoc.pdf
  #
  # > census_col_names_map
  #     ftpname        Rname                                                                               longname
  # 1  LOGRECNO     logrecno                                                                  logical record number
  # 2   GEOCODE    blockfips                                                                   15 digit Census FIPS
  # 3  AREALAND     arealand                                                    size of area that is land not water
  # 4  AREAWATR    areawater                                                             size of area that is water

  # 5    POP100       pop100                                                                 Total Population Count

  # 6     HU100 housingunits                                                                    Housing Units count
  # 7  INTPTLAT          lat                                                             latitude of internal point
  # 8  INTPTLON          lon                                                            longitude of internal point

  # 9  P0020001          pop                                                                 Total Population Count

  # 10 P0020002         hisp        <-----                                                      Hispanic or Latino
  # 11 P0020003      nonhisp                                                                 Not Hispanic or Latino
  # 12 P0020004      nhalone                                          Not Hispanic or Latino Population of one race
  # 13 P0020005         nhwa                                      White alone (of one race), Not Hispanic or Latino
  # 14 P0020006         nhba                  Black or African American alone (of one race), Not Hispanic or Latino
  # 15 P0020007      nhaiana          American Indian and Alaska Native alone (of one race), Not Hispanic or Latino
  # 16 P0020008         nhaa                                      Asian alone (of one race), Not Hispanic or Latino
  # 17 P0020009      nhnhpia Native Hawaiian and Other Pacific Islander alone (of one race), Not Hispanic or Latino
  # 18 P0020010 nhotheralone                            Some Other Race alone (of one race), Not Hispanic or Latino
  # 19 P0020011      nhmulti                  Population of two or more races (of one race), Not Hispanic or Latino


  ## US  DHC version of table P5 in segment 5
  # P0050001	5	9	Total:
  # P0050002	5	9	Not Hispanic or Latino:
  # P0050003	5	9	White alone
  # P0050004	5	9	Black or African American alone
  # P0050005	5	9	American Indian and Alaska Native alone
  # P0050006	5	9	Asian alone
  # P0050007	5	9	Native Hawaiian and Other Pacific Islander alone
  # P0050008	5	9	Some Other Race alone
  # P0050009	5	9	Two or More Races
  # P0050010	5	9	Hispanic or Latino:   <-----


  #    VI DHC version of variable names in P5 in segment 9
  # P0050002	Hispanic or Latino (of any race)	P0050002   <-----
  # P0050003	Not Hispanic or Latino:	P0050003
  # P0050021	White	P0050021
  # P0050022	Asian	P0050022
  # P0050023	American Indian and Alaska Native	P0050023
  # P0050024	Native Hawaiian and Other Pacific Islander	P0050024
  # P0050025	Some Other Race	P0050025
  # P0050026	Two or More Races:	P0050026


  # interpret cols_to_keep as possibly renamed and/or original names.
  # in case cols_to_keep was specified as the downloaded names rather than the renamed/r/friendly names:
  if (any(cols_to_keep %in% names(x))) {
    renamed_versions <-  census_col_names_defined$rname[match(cols_to_keep, census_col_names_defined$ftpname)]
    cols_to_keep <- c(cols_to_keep, renamed_versions)
  }

  # change to friendlier variable names using data file that maps old to new names.
  x <- data.table::copy(data.table::setDT(x)) # do not alter the copy that was passed to here, just to be clear

  colnames(x) <- census_col_names_defined$rname[match(colnames(x), census_col_names_defined$ftpname)]

  # could Add (or keep) 2-character abbreviation for State
  # x$ST <- lookup_states$ST[match(substr(x$blockfips,1,2), lookup_states$FIPS.ST)] # or just use STUSAB ?

  # we might remove blocks with zero population since they are more than 1 in 4 blocks.
  # x <- c[x$pop != 0, ]  #
  # wastes space, but might be simpler to
  # keep them to ensure matches always found between sites2blocks$blockfips and blockwts$blockfips

  # keep only needed columns, including now arealand areawater. Also were available:
  #  housingunits
  # hisp nhwa nhba  nhaiana nhaa nhnhpia nhotheralone nhmulti  !!! ??? isnt that suppressed where pop small?
  ## confirmed race ethnic subgroups add up to pop total count exactly in every block:
  # but we will not use any of that here.
  # sum_across_groups = rowSums(x[,c("hisp", "nhwa" , "nhba","nhaiana","nhaa","nhnhpia", "nhotheralone", "nhmulti")])
  # all.equal(sum_across_groups, x$pop)
  # # get rid of these variables - do not really need them
  # x$nonhisp <- NULL
  # x$nhalone <- NULL

  # Keep total area, but not land and water separately:
  x[ , area := .(arealand + areawater)]
  # x[ , arealand := NULL]
  # x[ , areawater := NULL]
  if ('all' %in% cols_to_keep) {cols_to_keep <- colnames(x)}
  if (!all(cols_to_keep %in% colnames(x))) {
    cat("While doing census2020_clean(), missing these column names: ", paste0(setdiff(cols_to_keep, colnames(x)), collapse=", "), "\n")
  warning("Some of column names specified by cols_to_keep are not available. Check census2020download::census_col_names_map and columns added in this source code")
  }
  cols_to_keep_found = cols_to_keep[cols_to_keep %in% colnames(x)]
  x <- x[ , ..cols_to_keep_found]

  x <- data.table::as.data.table(x, key = "blockfips") # note this assumes block not blockgroup or tract etc. is resolution, which cannot be true for island areas

  # rename from blockfips if different sumlev was used
  if (sumlev != 750) {
    names(x) <- gsub("blockfips", "fips", names(x))
  }

  return(x)

  ## You could plot the US using these block points:
  # here <- sample(1:nrow(x),10^5)
  # plot(x$lon[here], x$lat[here], pch=".", xlim = c(-180,-60)) # map looks bad if you include the tiny bit of AK that is around +179 instead of -179 longitude

  # RETURNS:
  #   blockfips      lat       lon pop    area

}


