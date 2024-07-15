

#' Download and clean up VI,GU,MP,AS Island Areas block data Census 2020 (for EJAM)
#'
#' @param folder Default is a tempdir. Folder is created if it does not exist. 
#' @param mystates Default is c('VI','GU','MP','AS')
#' @param do_download whether to do census2020_download()
#' @param do_unzip    whether to do census2020_unzip()
#' @param do_read     whether to do census2020_read()
#' @param do_clean    whether to do census2020_clean()
#'
#' @return invisibly returns list of tables
#'  
#'
census2020_get_data_islandareas <- function(folder = NULL, 
                                            # file.path(getwd(), "census2020_islandareas"), 
                                            mystates = c('VI', 'GU', 'MP', 'AS'), 
                                            do_download = TRUE, do_unzip = TRUE, do_read = TRUE, do_clean = TRUE) {
  
  ############################################### #
  
  # FOLDER ####
  
  if (is.null(folder) || missing(folder)) {
    folder = tempdir()
    folder = file.path(folder, "census2020_islandareas")
  }
  if (!dir.exists(folder)) {dir.create(folder)}
  if (!dir.exists(folder)) {stop("failed to find or create folder at", folder)}
  ############################################### #
  
  # DOWNLOAD ####
  
  # x <- curl::multi_download
  # download zip files for island areas
  zpathsinfo <- census2020_download_islandareas(folder = folder, mystates = mystates)
  # cat("\n    results of zip file downloads\n\n")
  # print(zpathsinfo)
  zurls <- zpathsinfo$url
  zpathslocal <- file.path(folder, basename(zurls))
  # cat("\n    files reportedly downloaded to ", folder, "\n\n")
  # print(basename(zurls))
  # znames_found =  dir(path = folder, pattern = "\\.dhc.zip$", full.names = FALSE)
  # cat("\n    ", length(znames_found), ".dhc.zip files found in ", folder, "\n\n")
  # print(znames_found)
  ############################################### #

  # UNZIP ####
  census2020_unzip2 <- function(zpathslocal, folder, filegeogrep = "geo2020\\.dhc$", filedatagrep = "[^o]2020\\.dhc$") {
  fpaths <- list()
  for (i in seq_along(zpathslocal)) {
    fpaths[[i]] <- unzip(zpathslocal[i], exdir = folder)
  }
  fpaths = unlist(fpaths)
  cat("\n    ", length(fpaths), "files reportedly extracted via unzip\n\n")
  # fnames <- basename(fpaths)
  # print(fnames)
  
  gnames = dir(path = folder, pattern = filegeogrep,     full.names = F)
  cat("\n    ", length(gnames), "geo files found\n\n")
  print(gnames)
  
  dnames = dir(path = folder, pattern = filedatagrep,     full.names = F)
  cat("\n    ", length(dnames), "data files found\n")
  print(addmargins(table(substr(dnames,1,2))))
  cat("\n")
  # print(dnames)
  invisible(c(gnames, dnames))
  }
  ############################################### #
  census2020_unzip2(zpathslocal = zpathslocal) # for US States defaults

  # READ ####
  
  if (do_read) {
    blocks <- census2020_read_islandareas(folder = folderout, mystates = mystates, ...) # not yet a data.table
  }
  ############################################### #
  
  # CLEAN ####
  
  if (do_clean) {
    blocks <- census2020_read_islandareas(blocks) # returns a data.table
  }
  ############################################### #

  
  
  # fpaths
  
  invisible(blocks)
}
