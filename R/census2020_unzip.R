#' unzip Census 2020 zipped files already downloaded, for States and DC, PR
#'
#' @param zipfolder Default is current working directory. Should contain .zip file(s)
#' @param folderout path to where you want to put files, created if does not exist
#' @param filenumbers a vector with any or all of 1,2,3 --
#'   default is file 1.
#'   File01 has Tables P1 and P2, which have population counts by race ethnicity.
#'   File02 has Tables P3, P4, and H1.
#'   File03 has Table P5.
#' @param mystates optional vector of 2letter state abbreviations for which to unzip
#'
#' @seealso [census2020_download()] [census2020_read()]
#' @return Vector of filenames of unzipped contents
#' @examples \dontrun{
#'  # library(census2020download)
#'  census2020_download('./census2020zip', mystates = c('MD', 'DC'))
#'  census2020_unzip('./census2020zip','./census2020out')
#'  c2 <- census2020_read(folder = './census2020out', mystates = c('MD', 'DC'))
#'  save(c2, file = 'census2020blocks.rdata')
#'  dim(c2)
#'  str(c2)
#'  head(c2)
#'  sum(c2$POP100)
#'  plot(c2$INTPTLON[substr(c2$GEOCODE,1,2)=='24'], c2$INTPTLAT[substr(c2$GEOCODE,1,2)=='24'], pch='.')
#'  }
#'
#'
census2020_unzip <- function(zipfolder = NULL, folderout = NULL,
                             filenumbers = 1, mystates = NULL) {
  # not filenumbers=1:3

  if (is.null(zipfolder))    {zipfolder    <- getwd()}
  if (is.null(folderout)) {folderout <- zipfolder}
  if (!dir.exists(zipfolder))    {dir.create(zipfolder)}
  if (!dir.exists(folderout)) {dir.create(folderout)}
  if (!dir.exists(zipfolder))    {stop("failed to find or create folder at", zipfolder)}
  if (!dir.exists(folderout)) {stop("failed to find or create folder at", folderout)}

  if (is.null(mystates)) {
    zipfiles <- list.files(zipfolder, pattern = '2020.pl.zip')
    mystates <- substr(zipfiles,1,2)
  } else {
    mystates <- tolower(mystates)
    zipfiles <- paste(mystates, '2020.pl.zip', sep = '')
  }

  allfiles <- vector()
  for (statenum  in seq_along(mystates)) {
    tablefiles <- paste(mystates[statenum], '0000', filenumbers, '2020.pl', sep = '')
    tablefiles <- c(tablefiles, paste(mystates[statenum], 'geo2020.pl',sep = ''))
    # print(tablefiles)
    # al000012020.pl
    # al000022020.pl
    # al000032020.pl
    # algeo2020.pl

    zipfolderfile <- file.path(zipfolder, zipfiles[statenum])
    if (!file.exists(zipfolderfile)) {stop(paste0('Cannot find file', zipfolderfile))}
    unzip(zipfolderfile, files = tablefiles, exdir = folderout)
    cat(zipfolderfile, ' has ', paste(tablefiles, collapse = ', '), '\n')
    allfiles <- c(allfiles, tablefiles)
  }
return(allfiles)
}
