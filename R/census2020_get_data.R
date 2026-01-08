
#' Download and clean up US States,DC,PR, or Island Areas block data Census 2020 (for EJAM)
#'
#' @details
#'       To create certain data tables used by EJAM,
#'       EJAM uses scripts like EJAM/data-raw/datacreate_....R
#'       to do something like this:
#'
#'       blocks <- census2020_get_data() # default excludes Island Areas
#'       mylist <- census2020_save_datasets(blocks)
#'
#'       bgid2fips    = mylist$bgid2fips
#'       blockid2fips = mylist$blockid2fips
#'       blockpoints  = mylist$blockpoints
#'       blockwts     = mylist$blockwts
#'       quaddata     = mylist$quaddata
#'
#' @param folder For downloaded files. Default is a tempdir. Folder is created if it does not exist.
#' @param folderout path for assembled results files, default is what folder was set to.
#'
#' @param mystates default is DC, PR, and the 50 states -- lacks
#'   the island areas c('VI','GU','MP','AS') --
#'   but census2020_get_data() can in some cases handle a mix of States/DC/PR
#'   and/or island areas via helper function [census2020_get_data_islandareas()],
#'   returning either type of data, or a combined data.table if both are requested.
#'   But block resolution is not available from these files for island areas,
#'   so default for those is to get block groups,
#'    which would not make sense to mix with blocks for states.
#'    And Table 1 with pop seems unavailable from this source for island areas.
#'
#' @param do_download whether to do [census2020_download()]
#' @param do_unzip    whether to do [census2020_unzip()]
#' @param do_read     whether to do [census2020_read()]
#' @param do_clean    whether to do [census2020_clean()]
#' @param overwrite passed to [census2020_download()]
#' @param ... passed to [census2020_read()]
#'
#' @seealso [census2020_save_datasets()] creates individual data.tables,
#'  after [census2020_get_data()] has done these:
#'  - [census2020_download()]
#'  - [census2020_unzip()]
#'  - [census2020_read()]
#'  - [census2020_clean()]
#'. and see [census2020_get_data_islandareas()]
#'
#' @examples
#'  \dontrun{
#'  x = census2020_get_data()
#'  y = census2020_get_data()
#'  }
#' @return invisibly returns a data.table of US Census blocks with columns like
#'   blockid lat lon pop area (area in square meters), or just intermediate info
#'   depending on do_read, do_clean, etc.
#'
#' @export
#'
census2020_get_data <- function(folder = NULL,   # "~/../Downloads/census2020zip",
                                folderout = NULL, # "~/../Downloads/census2020out",
                                mystates = c(state.abb, "DC", "PR"),
                                do_download = TRUE, do_unzip = TRUE, do_read = TRUE, do_clean = TRUE,
                                overwrite = TRUE,
                                ...) {
  if (!overwrite) {stop("overwrite FALSE not working yet")}

  if (any(mystates %in% c('VI', 'GU', 'MP', 'AS'))) {
    mystates_islandareas = mystates[mystates %in% c('VI', 'GU', 'MP', 'AS')]
    islandareas_data =  census2020_get_data_islandareas(mystates_islandareas,
                                                        folder=folder,
                                                        folderout=folderout,
                                                        do_download=do_download, do_unzip = do_unzip, do_read = do_read, do_clean = do_clean,
                                                        overwrite=overwrite, ... = ...)
    mystates = mystates[!(mystates %in% c('VI', 'GU', 'MP', 'AS'))]
  } else {
    mystates_islandareas <- NULL
  }
  if (!any(!(mystates %in% c('VI', 'GU', 'MP', 'AS')))) {
    nonisland_data <- NULL
  } else {

    ############################################### #

    # FOLDER ####

    if (is.null(folder)) {
      folder = tempdir()
      folder = file.path(folder, "census2020")
    }
    if (!dir.exists(folder)) {dir.create(folder)}
    if (!dir.exists(folder)) {stop("failed to find or create folder at", folder)}
    if (is.null(folderout)) {
      folderout <- folder
    }
    ##################################### #  ##################################### #

    # DOWNLOAD ####

    # "PR" data is with States folder
    # VI GU MP AS  are at other URLs

    if (do_download) {
      cat("\n -------------------------  DOWNLOADING -------------------------  \n\n")
      zpathsinfo <- census2020_download( folder = folder,    mystates = mystates, overwrite = overwrite) #
      paths <- zpathsinfo$destfile
      zipfolder <- dirname(zpathsinfo$destfile)[1]
      zurls <- zpathsinfo$url
      zpathslocal <- file.path(folder, basename(zurls))
    } else {
      zpathslocal <- folder # ?
    }
    ############################################### #

    # UNZIP ####

    if (do_unzip) {
      cat("\n -------------------------  UNZIPPING -------------------------  \n\n")
      allfiles <- census2020_unzip(zipfolder = zipfolder, mystates = mystates, folderout = folderout)
    }
    ############################################### #

    # READ ####

    if (do_read) {
      cat("\n -------------------------  READING -------------------------  \n\n")
      blocks <- census2020_read(folder = folderout, mystates = mystates, ...) # not yet a data.table
    }
    ############################################### #

    # CLEAN ####

    if (do_clean && do_read) {
      cat("\n -------------------------  CLEANING -------------------------  \n\n")
      blocks <- census2020_clean(blocks) # returns a data.table with all the info
    }
    ############################################### #
    cat("\n -------------------------  DONE -------------------------  \n\n")
    cat("
      To create the individual data tables like blockwts, blockpoints, etc.,
      try something like

        blocks <- census2020_get_data()
        # but also see census2020_get_data_islandareas() for those blocks!

        mylistoftables <- census2020_save_datasets(blocks)

      where mylistoftables will be

      list(bgid2fips = bgid2fips,
            blockid2fips = blockid2fips,
            blockpoints = blockpoints,
            blockwts = blockwts,
            quaddata = quaddata )

      See ?census2020_save_datasets

      \n")
    ############################################### #
    # depending on do_download, do_unzip,  do_read and do_clean, return what is available
    if (exists("blocks")) {nonisland_data <- blocks} else {
      if (exists("allfiles")) {nonisland_data <- allfiles} else {
        if (exists("paths")) {nonisland_data <- paths} else {
          nonisland_data <- NULL}
      } }
  }
  ############################################### #
  if (is.data.frame(islandareas_data) || is.data.frame(nonisland_data)) {
    # looks  like do_read = T
    cat("\n Combining island areas data with non-island areas data \n\n")
    return(rbind(
      islandareas_data,
      nonisland_data
    ))
  } else {
      return(c(
        islandareas_data,
        nonisland_data
      ))
    }

}
