
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
#' @param mystates Character vector of 2 letter abbreviations, optional,
#'   - Default is 50 states + DC + PR here. Island Areas are VI GU MP AS.
#' @param allstates Default is same as mystates default. 
#' @param baseurl default is the FTP folder with the data
#' @param urlmiddle empty for States info, but
#'   for Island Areas, urlmiddle = "demographic-and-housing-characteristics-file/"
#' @seealso [census2020_get_data()] [census2020_download_islandareas()]
#' @return Effect is to download and save locally a number of data files.
#' @examples \dontrun{
#'  # library(census2020download)
#'  census2020_download('./census2020zip', mystates = c('MD', 'DC'))
#'  census2020_unzip('./census2020zip','./census2020out')
#'  c2 <- census2020_read(folder = './census2020out', mystates = c('MD', 'DC'))
#'  save(c2,file = 'census2020blocks.rdata')
#'  dim(c2)
#'  str(c2)
#'  head(c2)
#'  sum(c2$POP100)
#'  plot(
#'    c2$INTPTLON[substr(c2$GEOCODE,1,2)=='24'],
#'    c2$INTPTLAT[substr(c2$GEOCODE,1,2)=='24'], pch='.')
#'  }
#'  
#' @export
#' 
census2020_download <- function(folder = NULL, 
                                mystates = c(state.abb, 'DC', 'PR'),
                                allstates = c(state.abb, 'DC', 'PR'),
                                baseurl = "https://www2.census.gov/programs-surveys/decennial/2020/data/01-Redistricting_File--PL_94-171/",
                                urlmiddle = "", 
                                zipnames_suffix = '2020.pl.zip') {
  
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
  
  allstates <- tolower(allstates)
  statelookup <- data.frame(ST = allstates, 
                            statename = c(state.name, 'District_of_Columbia', 'Puerto_Rico'))
  if (is.null(mystates) || length(mystates) == 0) {
    mystates <- allstates
  } else {
    mystates <- tolower(mystates)
    mystates <- mystates[mystates %in% allstates]
  }
  mystatenames <- statelookup[match(mystates, statelookup$ST), 'statename']
  mystatenames <- tolower(gsub(' ', '_', mystatenames))  # *** check if should be lowercase or not 
  ##################################### #  ##################################### # 
  
  #	URL AND ZIPFILE NAME ######
  
  zipnames <- paste((mystates), zipnames_suffix, sep = '')
  zipfile.fullpaths <- paste(
    baseurl, 
    mystatenames, "/", urlmiddle,
    zipnames, sep = "")
  # print(zipfile.fullpaths)
  ##################################### #  ##################################### # 
  
  # DOWNLOAD ###################
  
  x <- curl::multi_download(zipfile.fullpaths, 
                            destfiles = file.path(folder, zipnames))
  if (any(!x$success)) {
    stop("Failed to download: \n", paste0(x$url[!x$success], collapse = "\n"))
  }
  
  zpathsinfo <- x
  
  cat("\n    results of zip file downloads\n\n")
  print(zpathsinfo)
  zurls <- zpathsinfo$url
  zpathslocal <- file.path(folder, basename(zurls))
  cat("\n    ", length(zpathslocal),"files reportedly downloaded to ", folder, "\n\n")
  print(basename(zurls))
  
  znames_found =  dir(path = folder, pattern = paste0(zipnames_suffix, "$") , full.names = FALSE)
  cat("\n    ", length(znames_found), " ", zipnames_suffix, " files found in ", folder, "\n\n")
  print(znames_found)
  ##################################### #   ##################################### # 
  
  return(x)
}
