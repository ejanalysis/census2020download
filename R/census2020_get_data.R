#' Download and clean up US States,DC,PR block data Census 2020 (for EJAM)
#' @details
#'       To create the individual data tables used by EJAM,
#'       
#'       blockwts, blockpoints, quaddata, blockid2fips, and bgid2fips,
#'
#'       try something like
#'       
#'       
#'       blocks <- census2020_get_data()
#'       
#'       mylistoftables <- census2020_save_datasets(blocks)
#'       
#'       
#'       where mylistoftables will be
#'       
#'       
#'       list(bgid2fips = bgid2fips,
#'       
#'       blockid2fips = blockid2fips,
#'       
#'       blockpoints = blockpoints,
#'       
#'       blockwts = blockwts,
#'       
#'       quaddata = quaddata )
#'       
#'       
#'       See ?census2020_save_datasets
#'       
#' @param folder For downloaded files. Default is a tempdir. Folder is created if it does not exist.
#' @param folderout path for assembled results files, default is what folder was set to.
#' @param mystates default is DC, PR, and the 50 states -- lacks VI/GU/MP/AS
#' @param do_download whether to do census2020_download()
#' @param do_unzip    whether to do census2020_unzip()
#' @param do_read     whether to do census2020_read()
#' @param do_clean    whether to do census2020_clean()
#' @param ... passed to census2020_read()
#'
#' @seealso [census2020_get_islandareas()], [census2020_save_datasets()] which creates individual data.tables
#'  census2020_get_data() just does [census2020_download()] then [census2020_unzip()]
#'  then [census2020_read()] then [census2020_clean()]
#'   
#' @return invisibly returns a data.table of US Census blocks with columns like
#'   blockid lat lon pop area (area in square meters)
#'   
#' @export
#'
census2020_get_data <- function(folder = NULL,      # "~/../Downloads/census2020zip", 
                                folderout = folder, # "~/../Downloads/census2020out", 
                                mystates = c(state.abb, "DC", "PR"),
                                do_download = TRUE, do_unzip = TRUE, do_read = TRUE, do_clean = TRUE,
                                ...) {
  ############################################### #
  
  # FOLDER ####
  
  if (is.null(folder) || missing(folder)) {
    folder = tempdir()
    # folder = file.path(folder, "census2020_islandareas")
    folder = file.path(folder, "census2020")
  }
  if (!dir.exists(folder)) {dir.create(folder)}
  if (!dir.exists(folder)) {stop("failed to find or create folder at", folder)}
  ##################################### #  ##################################### # 
  
  # DOWNLOAD ####
  
  # "PR" data is with States folder
  # VI GU MP AS  are in other places. see 
  # census2020_get_data_islandareas() 
  
  if (do_download) {
    x <- census2020_download( folder = folder,    mystates = mystates) #
    paths <- x$destfile
  }
  ############################################### #
  
  # UNZIP ####
  
  if (do_unzip) {
    census2020_unzip(         folder = folder,    mystates = mystates, folderout = folderout)
  }
  ############################################### #
  
  # READ ####
  
  if (do_read) {
    blocks <- census2020_read(folder = folderout, mystates = mystates, ...) # not yet a data.table
  }
  ############################################### #
  
  # CLEAN ####
  
  if (do_clean) {
    blocks <- census2020_clean(blocks) # returns a data.table with all the info
  }
  ############################################### #
  
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
  
  invisible(blocks)
}
