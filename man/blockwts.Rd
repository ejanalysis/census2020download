% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_blockwts.R
\docType{data}
\name{blockwts}
\alias{blockwts}
\title{2020 Census block weights (population as share of overall block group)}
\description{
data.table for use in EJAM
}
\details{
See EJAM package for more info.

Created by \code{\link[=census2020_get_data]{census2020_get_data()}} and \code{\link[=census2020_save_datasets]{census2020_save_datasets()}}

This package can create this data table but does not store it.

Rows: 8,174,955

Columns:
\itemize{
\item blockid (for joins among tables \link{blockwts}, \link{blockpoints}, \link{quaddata}, \link{blockid2fips})
unique integer 1 through number of rows (blocks),
used as a more efficient ID than a 15-character FIPS code.
\item bgid The unique ID of the block group that contains this block
\item blockwt is used by EJAM package function doaggregate()
to summarize the block group score of the
average person in some location such as within 1 mile of a point,
as the population weighted mean
of blockgroup scores of all the blocks in the area.
blockwt is the block's population weight,
calculated as the block population as a fraction of the parent blockgroup pop.
Based on the latest decennial Census table of population count for each block.
This table of weights can be used for calculating the
weighted mean or sum of each blockgroup score for a buffer
where only some blocks of any given blockgroup are in the buffer.
The sum of weights from some blocks tells you
what fraction of its whole parent blockgroup's population count
is in those blocks (the ones found inside a buffer, for example).
\item block_radius_miles is the effective radius of a block,
where pi times that radius squared is the block area in square miles.
This gets used to adjust distances of sites at very short distances to the internal point.
}
}
