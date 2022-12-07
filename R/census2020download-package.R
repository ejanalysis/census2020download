#' @docType package
#' @title 2020 Census Blocks and Tools to Download from FTP
#' @name census2020download
#' @aliases census2020download-package
#' @description Basic functions for downloading from FTP, 
#'   unzipping, reading the 2020 Census data for some or all US States 
#'   into a single data.table.
#' @details This package provides a dataset of all US blocks
#'   with a few key variables like population count, lat/lon of internal point, 
#'   FIPS. This package downloads and also could retain some other columns like 
#'   area, and some basic race ethnicity counts,
#'   with small changes to some source code. 
#'   The proxistat package has a similar data.table but also with area and population count.
#'   EPA may at some point provide the same data in a package such as EJAMblockdata.
#'   
#'   To use quaddata and blockquadtree for fast search of blocks:
#'        localtree <- SearchTrees::createTree(
#'        EJAMblockdata::quaddata, treeType = "quad", dataType = "point")
#'        
#' @details
#' Key functions and data.tables include
#' \itemize{
#' \item \code{\link{census2020_get_data()}} Download/ Unzip/ Read/ Clean
#'    basic data on all US Census blocks.
#' \item \code{\link{census2020_save_datasets()}} Use the data to create the separate data.tables,
#'   and save for use in the package.
#' \item \code{\link{census2020_download()}} Download all the state files from FTP site
#' \item \code{\link{census2020_unzip()}} Unzip the downloads
#' \item \code{\link{census2020_read()}} Read the unzipped files
#' \item \code{\link{census2020_clean()}} Clean up what was read
#' \item \code{\link{blockpoints}}  - data.table with latitude and longitude
#' \item \code{\link{blockid2fips}} - data.table with FIPS code to blockid lookup
#' \item \code{\link{bgid2fips}}    - data.table with FIPS codes to block group id lookup
#' \item \code{\link{blockwts}} - data.table with Census 2020 population-based weight 
#'   as fraction of parent block group population
#' \item \code{\link{quaddata}} - data.table with xyz format locations of blocks
#' \item \code{\link{blockquadtree}} A quadtree index, for fast search to find nearby blocks
#' }
#'
NULL