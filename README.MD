Package: census2020download
Title: 2020 Census Blocks and Tools to Download from FTP
Version: 0.1.0.0000
Authors@R: 
    person(given = "Mark",
           family = "Corrales",
           role = c("aut", "cre"),
           email = "corrales.mark@epa.gov"
           )
Description: Note this same data will be available in the EJAMblockdata package.
  This package has basic functions for downloading from FTP, 
  unzipping, reading the 2020 Census data for some or all US States 
  into a single data.frame. It provides a dataset of all US blocks
  with a few key variables like population count, lat/lon of internal point, 
  FIPS, area, and a way to get the basic race ethnicity counts.
Depends: R (>= 3.5.0)
License: MIT + file LICENSE
Encoding: UTF-8
LazyData: true
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.1.2
NeedsCompilation: no
Author: Mark Corrales [aut, cre] 
Maintainer: Mark Corrales <corrales.mark@epa.gov>
