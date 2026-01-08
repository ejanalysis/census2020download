
#' Download and clean up VI,GU,MP,AS Island Areas block data Census 2020 (for EJAM)
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#'
#' @param mystates Default is c('VI','GU','MP','AS')
#'   data were at https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/
#'   Also see page a-22 in https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/supplemental-demographic-and-housing-characteristics-file/2020census-supplemental-dhc-techdoc.pdf
#' @param folder For downloaded files. Default is a tempdir. Folder is created if it does not exist.
#' @param folderout path for assembled results files, default is what folder was set to.
#' @param do_download whether to do [census2020_download_islandareas()]
#' @param do_unzip    whether to do [census2020_unzip_islandareas()]
#' @param do_read     whether to do [census2020_read_islandareas()]
#' @param do_clean    whether to do [census2020_clean_islandareas()]
#' @param overwrite passed to [census2020_download_islandareas()]
#' @param sumlev set to 150, meaning blockgroup not block.
#'
#'  However, note this from Census Bureau:
#'  "With this release of the 2020 IAC Demographic and Housing Characteristics Summary File,
#'  the Census Bureau provides additional demographic
#'  and housing characteristics for the Island Areas
#'  down to the block, block group, and census tract levels."
#'
#' @details
#' Table 1 with pop seems unavailable from this source for island areas
#'  if trying to use the same approach to reading files as done for the US States.
#'
#'   For Island areas, see https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf
#'   or e.g., (https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/american-samoa/demographic-and-housing-characteristics-file/2020-iac-dhc-readme.pdf)
#'
#'  For technical details on the files downloaded and tables and variables,
#'  see the detailed references in the help for [census2020_read()].
#'
#'
#' @examples
#'  \dontrun{
#'  x = [census2020_get_data()] # States/DC/PR at block resolution
#'  y = [census2020_get_data_islandareas()] # VI,GU,MP,AS (at blockgroup scale)
#'  }
#' @return invisibly returns a data.table of US Census units with columns like
#'   the id, lat lon pop area (area in square meters), or intermediate info
#'   depending on do_read, do_clean, etc.
#'
#' @export
#' @keywords internal
#'
census2020_get_data_islandareas <- function(mystates = c('VI', 'GU', 'MP', 'AS'),
                                            folder = NULL,# file.path(getwd(), "census2020_islandareas"),
                                            folderout = NULL,
                                            do_download = TRUE, do_unzip = TRUE, do_read = TRUE, do_clean = TRUE,
                                            overwrite = TRUE,
                                            sumlev = 150  # block group not block, since no block data for island areas in these files
                                            ) {
if (!overwrite) {stop("overwrite FALSE not working yet")}

  # census2020_get_data() to some extent can handle a mix of States/DC/PR
  # and/or island areas (VI,GU,MP,AS) via helper function census2020_get_data_islandareas(),
  # returning either type of data, or a combined data.table if both are requested.
# but not really, since sumlev is block for states and block group for island areas!










  ############################################### #

  # FOLDER ####

  if (is.null(folder) || missing(folder)) {
    folder = tempdir()
    folder = file.path(folder, "census2020_islandareas")
  }
  if (!dir.exists(folder)) {dir.create(folder)}
  if (!dir.exists(folder)) {stop("failed to find or create folder at", folder)}
  if (is.null(folderout)) {
    folderout <- folder
  }
  ############################################### #

  # DOWNLOAD ####

  # "PR" data is with States folder
  # VI GU MP AS  are at other URLs

  if (do_download) {
    cat("\n -------------------------  DOWNLOADING -------------------------  \n\n")
    zpathsinfo <- census2020_download_islandareas(folder = folder, mystates = mystates, overwrite = overwrite)
    if (!is.null(zpathsinfo)) {
    paths <- zpathsinfo$destfile
    zurls <- zpathsinfo$url
    zpathslocal <- file.path(folder, basename(paths)) # census2020_unzip_islandareas() unlike census2020_unzip() needs path to file, not just the folder name
}else{ zpathslocal <- folder}    } else {
    zpathslocal <- folder
  }
  ############################################### #

  # UNZIP ####

  if (do_unzip) {
    cat("\n -------------------------  UNZIPPING -------------------------  \n\n")
    allfiles <- census2020_unzip_islandareas(zpathslocal = zpathslocal, folderout = folderout) # for US States defaults
  }
  ############################################### #

  # READ ####

  if (do_read) {
    cat("\n -------------------------  READING -------------------------  \n\n")
    blocks <- census2020_read_islandareas(folder = folderout, mystates = mystates, sumlev = sumlev) # not yet a data.table
  }
  ############################################### #

  # CLEAN ####

  if (do_clean) {
    cat("\n -------------------------  CLEANING -------------------------  \n\n")
    blocks <- census2020_clean_islandareas(blocks) # returns a data.table
    if (sumlev == 150) {
    names(blocks) <- gsub("blockfips", "bgfips", names(blocks)) # since no block data for island areas, only block group
    }
  }
  ############################################### #
  cat("\n -------------------------  DONE -------------------------  \n\n")
  cat("
      See also  ?census2020_get_data and ?census2020_save_datasets

      ")
















  ############################################### #
  # depending on do_download, do_unzip,  do_read and do_clean, return what is available
  if (exists("blocks")) {invisible(blocks)} else {
    if (exists("allfiles")) {invisible(allfiles)} else {
      if (exists("paths")) {invisible(paths)} else {
        return(NULL)}
    } }
}
