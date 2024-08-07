% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/census2020_get_data.R
\name{census2020_get_data}
\alias{census2020_get_data}
\title{Download and clean up US States,DC,PR block data Census 2020 (for EJAM)}
\usage{
census2020_get_data(
  folder = NULL,
  folderout = NULL,
  mystates = c(state.abb, "DC", "PR"),
  do_download = TRUE,
  do_unzip = TRUE,
  do_read = TRUE,
  do_clean = TRUE,
  overwrite = TRUE,
  ...
)
}
\arguments{
\item{folder}{For downloaded files. Default is a tempdir. Folder is created if it does not exist.}

\item{folderout}{path for assembled results files, default is what folder was set to.}

\item{mystates}{default is DC, PR, and the 50 states -- lacks VI/GU/MP/AS}

\item{do_download}{whether to do \code{\link[=census2020_download]{census2020_download()}}}

\item{do_unzip}{whether to do \code{\link[=census2020_unzip]{census2020_unzip()}}}

\item{do_read}{whether to do \code{\link[=census2020_read]{census2020_read()}}}

\item{do_clean}{whether to do \code{\link[=census2020_clean]{census2020_clean()}}}

\item{overwrite}{passed to \code{\link[=census2020_download]{census2020_download()}}}

\item{...}{passed to \code{\link[=census2020_read]{census2020_read()}}}
}
\value{
invisibly returns a data.table of US Census blocks with columns like
blockid lat lon pop area (area in square meters), or intermediate info
depending on do_read, do_clean, etc.
}
\description{
Download and clean up US States,DC,PR block data Census 2020 (for EJAM)
}
\details{
\if{html}{\out{<div class="sourceCode">}}\preformatted{  To create certain data tables used by EJAM,
  EJAM uses scripts like EJAM/data-raw/datacreate_....R
  to do something like this:
  
  blocks <- census2020_get_data()
  mylist <- census2020_save_datasets(blocks)
  
  bgid2fips    = mylist$bgid2fips
  blockid2fips = mylist$blockid2fips
  blockpoints  = mylist$blockpoints
  blockwts     = mylist$blockwts
  quaddata     = mylist$quaddata
}\if{html}{\out{</div>}}
}
\seealso{
\code{\link[=census2020_save_datasets]{census2020_save_datasets()}} creates individual data.tables,
after \code{\link[=census2020_get_data]{census2020_get_data()}} has done these:
\itemize{
\item \code{\link[=census2020_download]{census2020_download()}}
\item \code{\link[=census2020_unzip]{census2020_unzip()}}
\item \code{\link[=census2020_read]{census2020_read()}}
\item \code{\link[=census2020_clean]{census2020_clean()}}
}
}
