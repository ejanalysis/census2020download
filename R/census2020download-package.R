#' @docType package
#' @title 2020 Census Blocks and Tools to Download from FTP
#' @name census2020download
#' @aliases census2020download-package
#' @description Basic functions for downloading from FTP, 
#'   unzipping, reading the 2020 Census data for some or all US States 
#'   into a single data.table, and splitting into a few tables 
#'   for use in the EJAM package.
#' @details This package provides a way to prepare datasets of all US blocks
#'   with a few key variables like population count, lat/lon of internal point, 
#'   FIPS. This package downloads and also could retain some other columns like 
#'    some basic race ethnicity counts,
#'   with small changes to some source code. 
#'   
#'   The proxistat package had a similar data.table but also with area and population count.
#'   
#' @details
#' Key functions and data.tables created include
#' 
#' - [census2020_get_data()] Download/ Unzip/ Read/ Clean basic data on all US Census blocks
#' - [census2020_save_datasets()]  Use the data to create the separate data.tables,
#'   and save for use in the EJAM package.
#' 
#' Key data.table objects created:
#' 
#' - [blockid2fips] - data.table with FIPS code to blockid lookup
#' - [blockpoints]  - data.table with latitude and longitude of internal points
#' - [quaddata] - data.table with xyz format locations of blocks, 
#'   used to create spatial index of blocks in the EJAM package.
#' - [blockwts] - data.table with Census 2020 population-based weight
#'   as fraction of parent block group population, and size of block
#'
NULL
