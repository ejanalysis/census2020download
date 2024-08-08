#' Download and clean up US States,DC,PR block data Census 2020 (for EJAM)
#' @details
#'       To create certain data tables used by EJAM,
#'       EJAM uses scripts like EJAM/data-raw/datacreate_....R
#'       to do something like this:
#'       
#'       blocks <- census2020_get_data()
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
#' @param mystates default is DC, PR, and the 50 states -- lacks VI/GU/MP/AS
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
#'   
#' @return invisibly returns a data.table of US Census blocks with columns like
#'   blockid lat lon pop area (area in square meters), or intermediate info
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
  ############################################### #
  
  # FOLDER ####
  
  if (is.null(folder)) {
    folder = tempdir()
    # folder = file.path(folder, "census2020_islandareas")
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
  # VI GU MP AS  are in other places. see 
  # census2020_get_data_islandareas() 
  
  if (do_download) {
    cat("\n -------------------------  DOWNLOADING -------------------------  \n\n")
    x <- census2020_download( folder = folder,    mystates = mystates, overwrite = overwrite) #
    paths <- x$destfile
  }
  ############################################### #
  
  # UNZIP ####
  
  if (do_unzip) {
    cat("\n -------------------------  UNZIPPING -------------------------  \n\n")
    allfiles <- census2020_unzip(folder = folder, mystates = mystates, folderout = folderout)
  }
  ############################################### #
  
  # READ ####
  
  if (do_read) {
    cat("\n -------------------------  READING -------------------------  \n\n")
    blocks <- census2020_read(folder = folderout, mystates = mystates, ...) # not yet a data.table
  }
  ############################################### #
  
  # CLEAN ####
  
  if (do_clean) {
    cat("\n -------------------------  CLEANING -------------------------  \n\n")
    blocks <- census2020_clean(blocks) # returns a data.table with all the info
  }
  ############################################### #
  cat("\n -------------------------  DONE -------------------------  \n\n")
  cat("
      To create the individual data tables like blockwts, blockpoints, etc., 
      try something like 
      
        blocks <- census2020_get_data()
      
        mylistoftables <- census2020_save_datasets(blocks)
      
      where mylistoftables will be 
      
      list(bgid2fips = bgid2fips, 
            blockid2fips = blockid2fips,
            blockpoints = blockpoints,
            blockwts = blockwts,
            quaddata = quaddata )
      
      See ?census2020_save_datasets
      
      \n")
  if (exists("blocks")) {invisible(blocks)} else {
    if (exists("allfiles")) {invisible(allfiles)} else {
      if (exists("paths")) {invisible(paths)} else {
        return(NULL)}
    } }
}
