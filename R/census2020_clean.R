#' Start to clean up download block data
#'
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
#'   "all" means keep them all. They will be renamed via census_col_names_map
#'   even if listed in cols_to_keep in the un-renamed form, like P0020002 vs hisp.
#' @param sumlev just used by [census2020_get_data()] to correctly name the fips column.
#' @param mystates just used by [census2020_get_data()] to correctly rename the data columns.
#' @param census_col_names_defined data.frame mapping Census FTP column names to
#'   short friendly names, with columns `ftpname` and `rname`. Default is
#'   [census_col_names_map]; the Island Area helpers pass area-specific maps
#'   such as [census_col_names_map_vi].
#' @return data.table with these columns by default:  blockfips lat lon pop area
#' @import data.table
#' @keywords internal
#'
#' @aliases census2020_clean_islandareas
#'
census2020_clean <- function(x, cols_to_keep = c("blockfips", "lat", "lon", "pop", "area"), sumlev = 750, mystates, census_col_names_defined = census_col_names_map) {

  ## Note variables are named differently in each source -  US PL (default) vs US DHC vs IslandAreas DHC & maybe even among island areas
  ##
  ## PL94_171Redistricting_National  p. 6-29
  ## see https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_NationalTechDoc.pdf
  ##
  ## Caution: the same indicator such as "nhba" may have been assigned a different P00* number depending on which island area the data came from
  #
  # for (cn in c("rname", "longname", "ftpname")) {
  #   x = data.frame(
  #     #map = census_col_names_map[,cn],
  #     island = census_col_names_map_island[,cn],
  #     as = census_col_names_map_as[,cn], gu = census_col_names_map_gu[,cn], mp = census_col_names_map_mp[,cn], vi = census_col_names_map_vi[,cn])
  #   x$unique_values = apply(x,1,function(r) length(unique(r)))
  #   print(cn)
  #   if (cn == 'longname') {print(x$unique_values)} else {print(x)}
  # }
  #

  # "all" is resolved later (after derived columns like area exist) so that it
  # is a superset of the default selection. Track it with a flag for now.
  keep_all <- "all" %in% cols_to_keep

  # interpret cols_to_keep as possibly renamed and/or original names.
  # in case cols_to_keep was specified as the downloaded names rather than the renamed/r/friendly names:
  if (!keep_all && any(cols_to_keep %in% names(x))) {
    renamed_versions <-  census_col_names_defined$rname[match(cols_to_keep, census_col_names_defined$ftpname)]
    # match() returns NA for names that have no FTP equivalent (e.g. already
    # friendly names); drop them so they do not leak into the unavailable check.
    renamed_versions <- renamed_versions[!is.na(renamed_versions)]
    cols_to_keep <- unique(c(cols_to_keep, renamed_versions))
  }

  # change all columns to friendlier variable names using data file that maps old to new names.
  colnames(x) <- census_col_names_defined$rname[match(colnames(x), census_col_names_defined$ftpname)]

  # use data.table syntax from here on
  # but use copy so we do not alter by reference, in the calling environment, the copy that was passed to here, just to be clear
  x <- data.table::copy(data.table::setDT(x))

  # Calculate total area, from land and water area:
  if (all(c("arealand", "areawater") %in% colnames(x))) {
    x[ , area := .(arealand + areawater)]
  }

  # Now that derived columns (e.g. area) exist, resolve cols_to_keep = "all".
  if (keep_all) {cols_to_keep <- colnames(x)}

  # could Add (or keep) 2-character abbreviation for State
  # x$ST <- lookup_states$ST[match(substr(x$blockfips,1,2), lookup_states$FIPS.ST)] # or just use STUSAB ?

  # we might remove blocks with zero population since they are more than 1 in 4 blocks.
  # x <- c[x$pop != 0, ]  #
  # wastes space, but might be simpler to
  # keep them to ensure matches always found between sites2blocks$blockfips and blockwts$blockfips

  # keep only needed columns, including now arealand areawater. Also were available:
  #  housingunits
  # hisp nhwa nhba  nhaiana nhaa nhnhpia nhotheralone nhmulti  (but suppressed where pop small?)
  ## confirmed race ethnic subgroups add up to pop total count exactly in every block:
  # but we will not use any of that here.
  #
  # sum_across_groups = rowSums(x[,c("hisp", "nhwa" , "nhba","nhaiana","nhaa","nhnhpia", "nhotheralone", "nhmulti")])
  # all.equal(sum_across_groups, x$pop)
  # # get rid of these variables - do not really need them
  # x$nonhisp <- NULL
  # x$nhalone <- NULL


  # Names supplied in the original FTP form (e.g. "GEOCODE") were translated to
  # their friendly form above, so they are not "missing" - exclude them before
  # warning about genuinely unavailable columns.
  unavailable <- setdiff(cols_to_keep, colnames(x))
  unavailable <- setdiff(unavailable, census_col_names_defined$ftpname)
  if (length(unavailable) > 0) {
    cat("While doing census2020_clean(), missing these column names: ", paste0(unavailable, collapse = ", "), "\n")
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
