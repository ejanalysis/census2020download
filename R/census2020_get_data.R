#' Download and clean up block data census 2020
#'
#' @param folder path for downloaded files
#' @param folderout path for assembled results files
#' @param mystates default is DC and the 50 states, not PR not VI/GU/MU/AS
#' @param ... passed to census2020_read()
#'
#' @return a data.table of US Census blocks with columns like
#'   blockid lat lon pop area (area in square meters I think)
#' @export
#'
census2020_get_data <- function(folder = '~/../Downloads/census2020zip', 
                                       folderout = '~/../Downloads/census2020out', 
                                       mystates = c(state.abb, 'DC'),
                                       ...) {
   # 'PR' data not in that same place!! VI GU MU AS too.
  
  census2020_download(      folder = folder,    mystates = mystates) #  
  census2020_unzip(         folder = folder,    mystates = mystates, folderout = folderout)
  blocks <- census2020_read(folder = folderout, mystates = mystates, ...) # not yet a data.table
  blocks <- census2020_clean(blocks) # returns a data.table
  
  cat('To create the datasets, try census2020_save_datasets(blocks, usethis=TRUE, overwrite=TRUE) \n')
  
  # x <- census2020_save_datasets(x = blocks, 
  #                         usethis=usethis, overwrite=overwrite, 
  #                         metadata=metadata) # not tested.  
  invisible(blocks)
}
