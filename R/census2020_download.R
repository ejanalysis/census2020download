
#' @title Download Census 2020 data files from FTP by State/DC/PR
#' @details
#'   Attempts to download some basic data files for specified states/etc.
#'   from the US Census Bureau's FTP site for Decennial Census file data.
#'
#'   see (https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf)
#'
#'   see (https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/american-samoa/demographic-and-housing-characteristics-file/2020-iac-dhc-readme.pdf)
#'
#' @param folder Default is a tempdir. Folder and subfolder for data are created if they do not exist.
#'
#' @param mystates Default is 50 states + DC + PR here. Island Areas are VI GU MP AS.
#'   Character vector of 2 letter abbreviations.
#' @param allstates Default is same as mystates default.
#'
#' @param baseurl Default is the FTP folder with the data
#' @param urlmiddle Default is empty for States info, but
#'   for Island Areas, urlmiddle = "demographic-and-housing-characteristics-file/"
#' @param overwrite set to FALSE to skip download if filename already in folder,
#'   but note it does not check if any existing file is corrupt/size zero/obsolete/etc.
#' @param zipnames_suffix last part of the filenames Census provides - default should work
#' @seealso [census2020_get_data()] [census2020_download_islandareas()]
#' @return Effect is to download and save locally a number of data files.
#' @examples \dontrun{
#'  # library(census2020download)
#'  census2020_download('./census2020zip', mystates = c('RI', 'DE'))
#'  census2020_unzip('./census2020zip','./census2020out')
#'  c2 <- census2020_read(folder = './census2020out', mystates = c('RI', 'DE'))
#'  save(c2,file = 'census2020blocks.rdata')
#'  dim(c2)
#'  str(c2)
#'  head(c2)
#'  sum(c2$POP100)
#'  plot(
#'    c2$INTPTLON[substr(c2$GEOCODE,1,2)=='10'],
#'    c2$INTPTLAT[substr(c2$GEOCODE,1,2)=='10'], pch='.')
#'  }
#'
#' @export
#'
census2020_download <- function(folder = NULL,
                                mystates = c(state.abb, 'DC', 'PR'),
                                allstates = c(state.abb, 'DC', 'PR'),
                                baseurl = "https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/",
                                urlmiddle = "",
                                zipnames_suffix = '2020.pl.zip',
                                overwrite = TRUE) {

  ##################################### #   ##################################### #

  # FOLDER ####

  if (is.null(folder) || missing(folder) || length(folder) == 0) {
    folder = tempdir()
    folder = file.path(folder, "census2020")
  }
  if (!dir.exists(folder)) {dir.create(folder)}
  if (!dir.exists(folder)) {stop("failed to find or create folder at", folder)}
  ##################################### #  ##################################### #

  # VALIDATE STATES ###################

  allstates <- toupper(allstates)
  statelookup <- data.frame(ST = allstates,
                            statename = c(state.name, 'District_of_Columbia', 'Puerto_Rico'))
  if (is.null(mystates) || length(mystates) == 0) {
    mystates <- allstates
  } else {
    mystates <- toupper(mystates)
    if (!all(mystates %in% allstates)) {
      warning("Some of mystates were not found in list of valid abbreviations: ", paste0(setdiff(mystates, allstates), collapse = ", "))
    }
    mystates <- mystates[mystates %in% allstates]
  }
  mystatenames <- statelookup[match(mystates, statelookup$ST), 'statename']
  mystatenames <- gsub(' ', '_', mystatenames)
  ##################################### #  ##################################### #

  #	URL AND ZIPFILE NAME ######

  zipnames <- paste(tolower(mystates), zipnames_suffix, sep = '')
  zipfile.fullpaths <- paste(
    baseurl,
    mystatenames, "/", urlmiddle,
    zipnames, sep = "")

  files.found <- file.exists(file.path(folder, zipnames))
  cat("\n", length(zipnames), "files were requested.\n")
  if (overwrite == FALSE) {
    cat(sum(files.found), "of", length(zipnames), "files requested were already in folder, and overwrite = FALSE, so not downloading again:\n", paste0(file.path(folder, zipnames)[files.found], collapse = "\n "), '\n\n')
    stillneed = length(zipnames) - sum(files.found)
    zipnames <- zipnames[!files.found]
    zipfile.fullpaths <- zipfile.fullpaths[!files.found]
    if (stillneed == 0) {
      cat("Done - none need to be replaced.\n")
      return(NULL)
      }
  } else {
    cat(sum(files.found), "of", length(zipnames), "files requested were already in folder, but overwrite = TRUE, so will try to download again and overwrite:\n", paste0(file.path(folder, zipnames)[files.found], collapse = "\n "), '\n\n')

  }
  ##################################### #  ##################################### #

  # DOWNLOAD ###################

  zpathsinfo <- curl::multi_download(zipfile.fullpaths,
                                     destfiles = file.path(folder, zipnames))
  problems <- !zpathsinfo$success | is.na(zpathsinfo$success) | !(zpathsinfo$status_code %in% c(200, 206))
  if (!all(problems)) {
    cat("\nSuccessfully downloaded from: \n",  paste0(zpathsinfo$url[!problems], collapse = "\n "), '\n')
  }
  if (any(problems)) {

    cat("\nProblems with downloading these: \n\n", paste0(zpathsinfo$url[problems], collapse = "\n "), '\n\n')
    cat("Destination folder: ", dirname(zpathsinfo$destfile)[1], '\n\n')
    zpathsinfo$url <- NULL
    zpathsinfo$destfilename <- basename(zpathsinfo$destfile)
    zpathsinfo$destfile <- NULL
    print(zpathsinfo)
    cat("
* status_code (of response): \nA successful HTTP status code is usually 200 for full requests (or 206 for resumed requests). Anything else could indicate that the downloaded file contains an error page instead of the requested content. It is important to inspect the status_code column to see if any of the requests were successful but had a non-success HTTP code, and hence the downloaded file probably contains an error page instead of the requested content.

* success (of just the request not response): \nIf the HTTP request was successfully performed, regardless of the response status code. A value of NA means the download was interrupted while in progress or it reached the elapsed timeout (and perhaps can be resumed if the server supports that). This is FALSE in case of a network error, or in case you tried to resume from a server that did not support this.

* error: \nIf success == FALSE this column contains an error message.
        \n")
    stop("Problems with download")
  }

  zurls <- zpathsinfo$url
  zpathslocal <- file.path(folder, basename(zurls))
  cat("\n    ", length(zpathslocal),"files reportedly downloaded to ", normalizePath(folder), "\n\n")
  print(basename(zurls))

  znames_found =  dir(path = folder, pattern = paste0(zipnames_suffix, "$") , full.names = FALSE)
  cat("\n    ", length(znames_found), "", zipnames_suffix, "files found in ", normalizePath(folder), "\n\n")
  print(znames_found)
  cat(paste0("\nTo explore folder with downloaded files from RStudio: \n      browseURL(   ", "  ) \n        "))
  print( normalizePath(folder) ); cat('  \n')
  ##################################### #   ##################################### #

  invisible(zpathsinfo)
}
