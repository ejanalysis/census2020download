% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/census2020download-package.R
\docType{package}
\name{census2020download}
\alias{census2020download}
\alias{census2020download-package}
\title{2020 Census Blocks and Tools to Download from FTP}
\description{
Basic functions for downloading from FTP,
unzipping, reading the 2020 Census data for some or all US States
into a single data.table, and splitting into a few tables
for use in the EJAM package.
}
\details{
This package provides a way to prepare datasets of all US blocks
with a few key variables like population count, lat/lon of internal point,
FIPS. This package downloads and also could retain some other columns like
some basic race ethnicity counts,
with small changes to some source code.

See Census vs ACS geos info here:
\url{https://www.census.gov/programs-surveys/acs/geography-acs/geography-boundaries-by-year.html}

The proxistat package had a similar data.table
but also with area and population count.

Key functions and data.tables created include
\itemize{
\item \code{\link[=census2020_get_data]{census2020_get_data()}} Download/ Unzip/ Read/ Clean data on
all US Census blocks
\item \code{\link[=census2020_save_datasets]{census2020_save_datasets()}} Use the data to create separate data.tables,
and save for use in the EJAM package.
}

Key data.table objects created:
\itemize{
\item \link{blockid2fips} - data.table with FIPS code to blockid lookup
\item \link{blockpoints}  - data.table with latitude and longitude of internal points
\item \link{quaddata} - data.table with xyz format locations of blocks,
used to create spatial index of blocks in the EJAM package.
\item \link{blockwts} - data.table with Census 2020 population-based weight
as fraction of parent block group population, and size of block
}
}
\seealso{
Useful links:
\itemize{
  \item \url{https://ejanalysis.github.io/census2020download/}
  \item \url{https://ejanalysis.github.io/census2020download/index.html}
}

}
\author{
\strong{Maintainer}: Mark Corrales \email{corrales.mark@epa.gov}

}
