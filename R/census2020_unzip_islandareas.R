


























#' like census2020_unzip() but for Island Areas
#'
#' @param zpathslocal zip file paths with filename, unlike in [census2020_unzip()]
#' @param folderout  see [census2020_unzip()]
#' @param filegeogrep  see [census2020_unzip()]
#' @param filedatagrep  see [census2020_unzip()]
#'
#' @returns see [census2020_unzip()]
#'
census2020_unzip_islandareas <- function(zpathslocal, folderout,
                                         filegeogrep = "geo2020\\.dhc$", filedatagrep = "[^o]2020\\.dhc$") {

  fpaths <- list()
  for (i in seq_along(zpathslocal)) {
    fpaths[[i]] <- unzip(zpathslocal[i], exdir = folderout)
  }
  fpaths = unlist(fpaths)
  cat("\n    ", length(fpaths), "files reportedly extracted via unzip\n\n")
  # fnames <- basename(fpaths)
  # print(fnames)

  gnames = dir(path = folderout, pattern = filegeogrep,     full.names = F)
  cat("\n    ", length(gnames), "geo files found\n\n")
  print(gnames)

  dnames = dir(path = folderout, pattern = filedatagrep,     full.names = F)
  cat("\n    ", length(dnames), "data files found\n")
  print(addmargins(table(substr(dnames,1,2))))
  cat("\n")
  # print(dnames)
  invisible(c(gnames, dnames))
}
############################################### #
