
#' @title Download Census 2020 data files from FTP - For Island Areas VI GU MP AS
#' @param folder Default is a tempdir. Folder and subfolder for data are created if they do not exist.
#' @param mystates Character vector of 2 letter abbreviations, optional,
#'   - Default is VI GU MP AS
#' @param allstates Default is VI GU MP AS
#' @param baseurl default is the FTP folder with the data
#' @param urlmiddle Default is empty for States info, but
#'   for Island Areas, urlmiddle = "demographic-and-housing-characteristics-file/"
#' @param zipnames_suffix last part of the filenames Census provides - default should work
#' @seealso [census2020_get_data()] [census2020_download()]
#' @return Effect is to download and save locally a number of data files.
#' @examples \dontrun{
#'  #
#'  }
#'
#' @export
#'
census2020_download_islandareas <- function(folder = NULL,
                                            mystates = c('VI', 'GU', 'MP', 'AS'),
                                            allstates = c('VI', 'GU', 'MP', 'AS'),
                                            baseurl = "https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/",
                                            urlmiddle = "demographic-and-housing-characteristics-file/",
                                            zipnames_suffix = '2020.dhc.zip') {
  census2020_download(folder = folder,
                      mystates = mystates,
                      allstates = allstates,
                      baseurl = baseurl,
                      urlmiddle = urlmiddle,
                      zipnames_suffix = zipnames_suffix)

  #  FOR ISLAND AREAS 2024
  # "https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/"
  #    "/us-virgin-islands/demographic-and-housing-characteristics-file/vi2020.dhc.zip"
  #    "/guam/demographic-and-housing-characteristics-file/gu2020.dhc.zip"
  #    "/commonwealth-of-the-northern-mariana-islands/demographic-and-housing-characteristics-file/mp2020.dhc.zip"
  #    "/american-samoa/demographic-and-housing-characteristics-file/as2020.dhc.zip"
  # file formats explained here:
  # "https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/american-samoa/demographic-and-housing-characteristics-file/2020-iac-dhc-readme.pdf"

}
