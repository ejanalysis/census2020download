#' create each separate data.table, and optionally save for use in package
#' This was just done once, to create the datasets in this package
#' @param x results of census2020_get_data()
#' @param metadata default is Census 2020 related
#' @param usethis default is FALSE, but if TRUE will install each dataset in package
#' @param overwrite default is TRUE, but only relevant if usethis = TRUE
#' @import data.table
#' @return a list of huge data.tables, bgid2fips, blockid2fips, 
#'   blockpoints, blockwts, quaddata,  
#' @export
#'
census2020_save_datasets <- function(x, 
                               metadata=NULL,
                               usethis=FALSE, overwrite=TRUE) {
  cat('To create the datasets, census2020_get_data(); census2020_save_datasets(blocks, usethis=TRUE, overwrite=TRUE) \n')
  
  if (is.null(metadata)) {
    metadata <- list(
      census_version = 2020,
      acs_version = '2016-2020',
      acs_releasedate = '3/17/2022',
      ejscreen_version = '2.1',
      ejscreen_releasedate = 'October 2022',
      ejscreen_pkg_data = 'bg22'
    )
  }
  
  #  compare to   /EJAM/inst/datasets/NOTES_read_blockweights2020.R
  # #   instead of this, once it is on a public repo.   
  # vs  /census2020download/R/census2020_save_datasets.R
  
    # also still need PR, and then AS VI GU MU
  
 #see  census2020_create_datasets() 
   #    clean up downloaded Census block data to use in EJAM 
  #  e.g. after census2020_download, _unzip, _read, _clean 
 
  blocks <- data.table::copy(x) # make a copy just in case, to preclude inadvertently altering by reference the original data.table that was passed to this function  .
  ############################################################################### #
  
  
  data.table::setnames(x = blocks, old = 'pop', new = 'blockpop') #  RENAME POPULATION FIELD   ----
  data.table::setorder(blocks, blockfips) #    sort by increasing blockfips 
   blocks[, bgfips := substr(blockfips, 1, 12)] # for merging blockgroup indicators to buffered blocks later on
   #  *CREATE blockwts column *  #  the blockwt is the blocks share of parent blockgroup census pop count
   blocks[ , bgpop := sum(blockpop), by=bgfips] # Census count population total of parent blockgroup gets saved with each block temporarily
   blocks[ , bgpop := as.integer(bgpop)] # had to be in a separate line for some reason
   blocks[ , blockwt := blockpop / bgpop] # ok if the ones with zero population were already removed
   blocks[is.na(blockwt), blockwt := 0] 
   # In Census 2020:  1,393 blockgroups had 0 pop in every block, due to 12,922 of the 2,368,443 blocks with 0 pop.
   # put columns in same order as were in blockweights csv from EJScreen (for those cols they have in common)
   data.table::setcolorder(blocks, neworder = c('blockfips', 'bgfips', 'blockwt', 'area', 'lat', 'lon', 'blockpop', 'bgpop'))
   
   # Census Bureau explanation of FIPS:
  # blockid: 15-character code that is the concatenation of fields consisting of the 
  # 2-character state FIPS code, the 
  # 3-character county FIPS code, [5 total define a county] the 
  # 6-character census tract code, [11 total define a tract] and the  
  #    [and 12 total define a blockgroup, which uses 1 digit more than a tract]
  # 4-character tabulation block code. [15 total define a block]
   ############################################################################### #  ############################################################################### #
   # 
   
  
  
  

  
  ############################################################################### ################################################################################ #
  
  ############################################################################### #
  # BREAK UP BLOCK DATA INTO A FEW SPECIFIC FILES ####
  # break into smaller data.tables, for lat/lon (blockpoints) and weights (blockwts) and bgid2fips and blockid2fips
  ############################################################################### #
  
  blocks[, blockid := .I] # numbers 1 through 8174955, 1 per row, and already sorted by increasing blockfips
  
  blockid2fips <- data.table::copy(blocks[ , .(blockid, blockfips)])
  blockpoints  <- data.table::copy(blocks[ , .(blockid, lat, lon)])
  
  blockwts     <- data.table::copy(blocks[ , .(blockid, bgfips, blockwt) ])
  blockwts[ , bgid := .GRP, by=bgfips] # sorted so bgid starts at 1 with first bgfips in sort by bgfips
  bgid2fips <- data.table::copy(blockwts)
  bgid2fips <- data.table::unique(bgid2fips[ , .(bgid, bgfips)])
  blockwts[ , bgfips := NULL] # drop that column from this table
  
  data.table::setcolorder(blockwts, neworder = c('blockid', 'bgid', 'blockwt'))
  
  # do not need to retain bgfips column since it has bgid, and bgfips is kept in bgid2fips
  # and blockwts is 170MB if bgfips kept as character, 125MB if bgid used instead of bgfips. 
  #    save space to convert bgfips to an integer bgid instead of the huge bgfips character string, as done for blockid vs blockfips
  # all.equal(unique(blockwts$bgfips), sort(unique(blockwts$bgfips))) # confirms they are already sorted after unique()
  
  ## area: previously did not bother saving columns that had block land area, water area, and plfips , BUT
  #    total area is useful for doing proximity scores for each block (and then parent block group) 
  #  - area is needed to calculate score when distance is smaller than effective radius of block, per formula in EJScreen tech doc,
  #  and as done in proxistat::proxistat()

  ############################################################################### #
  #  CREATE quaddata  for fast search for nearby block points ####
  #
  ########### convert block lat lon to XYZ units ########## #
  # Note quaddata is used to create localtree here but also is used in buffering code I think,
  #  to index the site points around which one is buffering, using the same quadtree structure,
  #  so quaddata will be saved here - it still gets used later. 
  earthRadius_miles <- 3959 # in case it is not already in global envt
  radians_per_degree <- pi / 180
  quaddata <- data.table::copy(blockpoints)
  quaddata[ , BLOCK_LAT_RAD  := lat * radians_per_degree]
  quaddata[ , BLOCK_LONG_RAD := lon * radians_per_degree]
  coslat <- cos(quaddata$BLOCK_LAT_RAD)
  quaddata[ , BLOCK_X := earthRadius_miles * coslat * cos(BLOCK_LONG_RAD)] 
  quaddata[ , BLOCK_Y := earthRadius_miles * coslat * sin(BLOCK_LONG_RAD)] 
  quaddata[ , BLOCK_Z := earthRadius_miles *          sin( BLOCK_LAT_RAD   )]
  quaddata <- quaddata[ , .(BLOCK_X, BLOCK_Z, BLOCK_Y, blockid)]
  
  # must be done again in each session, such as when package is loaded:
  # localtree <- SearchTrees::createTree(quaddata, treeType = "quad", dataType = "point") 
  
  ############################################################################### #
  # set key for some of these
  
  # (can you set more than one key in a table? some documentation said yes, but some 
  #  data.table examples seemed to say no and thus need to setindex not setkey for other columns)
  data.table::setkey(blockwts,     blockid); data.table::setindex(blockwts, bgid) # not sure the best/right approach is 1 key and 1 index. I think you can have only 1 key col? and 
  data.table::setkey(blockpoints,  blockid)
  data.table::setkey(blockid2fips, blockid); data.table::setindex(blockid2fips, blockfips)
  data.table::setkey(bgid2fips,       bgid); data.table::setindex(bgid2fips,       bgfips)
  
  ############################################################################### #
  # set attributes to store metadata on vintage
  

  
  # bgid2fips     <- EJAM::metadata_add( bgid2fips,    metadata = metadata)
  # blockid2fips  <- EJAM::metadata_add( blockid2fips, metadata = metadata)
  # blockpoints   <- EJAM::metadata_add( blockpoints,  metadata = metadata)
  # blockwts      <- EJAM::metadata_add( blockwts,     metadata = metadata)
  # quaddata      <- EJAM::metadata_add( quaddata,     metadata = metadata) 
  
  attributes(   bgid2fips)  <- c(attributes(   bgid2fips),  metadata)
  attributes(blockid2fips)  <- c(attributes(blockid2fips),  metadata)
  attributes(blockpoints)   <- c(attributes(blockpoints),   metadata)
  attributes(blockwts)      <- c(attributes(blockwts),      metadata)
  attributes(quaddata)      <- c(attributes(     quaddata), metadata) 
  
  usethis::use_data(   bgid2fips,  overwrite = TRUE)
  usethis::use_data(blockid2fips,  overwrite = TRUE)
  usethis::use_data(blockpoints,   overwrite = TRUE)  
  usethis::use_data(blockwts,      overwrite = TRUE)
  usethis::use_data(quaddata,      overwrite = TRUE) 
  
  ############################################################################### #  ############################################################################### #
  
  # Return all  tables invisibly? ####
  x <- list(bgid2fips = bgid2fips, 
            blockid2fips = blockid2fips,
            blockpoints = blockpoints,
            blockwts = blockwts,
            quaddata = quaddata )
  invisible(x)
  ############################################################################### #
  
}


