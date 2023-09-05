#' Download and clean up block data census 2020
#' 
#' @param folder path for downloaded files, or you could try setting it to tempdir()
#' @param folderout path for assembled results files, or you could try setting it to tempdir()
#' @param mystates default is DC and the 50 states -- lacks PR and VI/GU/MU/AS
#'   and probably would need those from a different source 
#' @param do_download whether to do census2020_download()
#' @param do_unzip whether to do census2020_unzip()
#' @param do_read whether to do census2020_read()
#' @param do_clean whether to do census2020_clean()
#' @param ... passed to census2020_read()
#'
#' @return invisibly returns a data.table of US Census blocks with columns like
#'   blockid lat lon pop area (area in square meters)
#' @export
#'
census2020_get_data <- function(folder = '~/../Downloads/census2020zip', 
                                       folderout = '~/../Downloads/census2020out', 
                                       mystates = c(state.abb, 'PR', 'DC'),
                                do_download=TRUE, do_unzip=TRUE, do_read=TRUE, do_clean=TRUE,
                                       ...) {
   # 'PR' data not in that same place!! VI GU MU AS too.
  
  if (do_download) {
    census2020_download(      folder = folder,    mystates = mystates) #  
  }
  if (do_unzip) {
  census2020_unzip(         folder = folder,    mystates = mystates, folderout = folderout)
  }
  if (do_read) {
  blocks <- census2020_read(folder = folderout, mystates = mystates, ...) # not yet a data.table
  }
  if (do_clean) {
  blocks <- census2020_clean(blocks) # returns a data.table
  }
  cat('
      To create the datasets, try something like 
      census2020_save_datasets(blocks, etc etc) \n')
  
  # x <- census2020_save_datasets(x = blocks, etc etc) # not tested.  
  invisible(blocks)
}
