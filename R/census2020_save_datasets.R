#' Create each separate data.table, and optionally save for use in a package
#' This was just done once, to create datasets for the EJAM package
#' @param x a single data.table called blocks that is from [census2020_get_data()]
#' @param metadata default is Census 2020 related
#' @param usethis default is FALSE, but if TRUE will install each dataset in package
#' @param overwrite default is TRUE, but only relevant if usethis = TRUE
#' @import data.table
#' @return A named list of these huge data.tables for the EJAM package:
#'
#'   - bgid2fips
#'   - blockid2fips
#'   - blockpoints
#'   - blockwts
#'   - quaddata
#'   
#' @details 
#'       To create the individual data tables used by EJAM, 
#'       
#'       blockwts, blockpoints, quaddata, blockid2fips, and bgid2fips,
#'       
#'       from within the EJAM source package root folder, try something like 
#'       
#'       
#'       blocks <- census2020_get_data()
#'       
#'       mylistoftables <- census2020_save_datasets(blocks, 
#'         save_as_data_for_package=TRUE, overwrite=TRUE)
#'
#'       
#'       See ?census2020_get_datasets
#'       
#'       and see create_quaddata() in EJAM pkg. 
#'       
#' @export
#'
census2020_save_datasets <- function(x, 
                                     metadata=NULL,
                                     save_as_data_for_package=FALSE, overwrite=TRUE) {
  cat('
      To create and save the datasets from within the EJAM source package root folder,
      
      
      blocks <- census2020_get_data()
      
      mylistoftables <- census2020_save_datasets(blocks, save_as_data_for_package=TRUE, overwrite=TRUE)
      
      \n')
  
  if (is.null(metadata)) {
    # used only if EJAM package not available
    metadata <- list(
      ejscreen_version =  '2.2',
      acs_version =          '2017-2021',
      census_version = 2020,
      ejscreen_releasedate = '2023-08-21',
      acs_releasedate =      '2022-12-08',
      ejscreen_pkg_data = NA,
      savedate = Sys.Date()
    )
  }
  
  #  see EJAM 
  
  # this should now obtain PR,
  # but then still need AS VI GU MU 
  
  
  blocks <- data.table::copy(x) # make a copy just in case, to preclude inadvertently altering by reference the original data.table that was passed to this function  .
  ############################################################################### #
  
  data.table::setorder(blocks, blockfips)   #    sort by increasing blockfips 
  blocks[, bgfips := substr(blockfips, 1, 12)] # for merging blockgroup indicators to buffered blocks later on
  
  data.table::setnames(x = blocks, old = 'pop', new = 'blockpop') #  RENAME for now POPULATION FIELD   ----
  
  #  *CREATE blockwts column *  #  the blockwt is the blocks share of parent blockgroup census pop count
  
  blocks[ , bgpop := sum(blockpop), by = bgfips] # Census count population total of parent blockgroup gets saved with each block temporarily
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
  
  
  
  
  ############################################################################### #
  # BREAK UP BLOCK DATA INTO A FEW SPECIFIC FILES ####
  # break into smaller data.tables, for lat/lon (blockpoints) and weights (blockwts) and bgid2fips and blockid2fips
  ############################################################################### #
  
  blocks[, blockid := .I] # numbers 1 through 8174955, 1 per row, and already sorted by increasing blockfips
  
  blockid2fips <- data.table::copy(blocks[ , .(blockid, blockfips)])
  blockpoints  <- data.table::copy(blocks[ , .(blockid, lat, lon)])
  
  blockwts     <- data.table::copy(blocks[ , .(blockid, bgfips, blockwt, area) ])
  blockwts[ , bgid := .GRP, by = bgfips] # sorted so bgid starts at 1 with first bgfips in sort by bgfips
  bgid2fips <- data.table::copy(blockwts)
  bgid2fips <-  unique(bgid2fips[ , .(bgid, bgfips)])
  blockwts[ , bgfips := NULL] # drop that column from this table 
  
  ############################ #
  # calculate block_radius_miles based on area ####
  # This is the effective radius of a block, i.e., the radius it would have based on its area if it were circular in shape
  
  area_sqmi <- area_sqmi_from_area_sqmeters(blockwts$area) # census2020download  :::  (not an exported function)
  # blockwts$area / (EJAMejscreenapi::meters_per_mile^2)   #  = convert_units(area, from = "sqm", towhat = "sqmi")
  add_block_radius_miles_to_dt(blockwts, area_sqmi)
  # blockwts[ , block_radius_miles :=  sqrt(area_sqmi / pi)]  ## because  area=pi*radius^2 
  blockwts[ , area := NULL] # do not need to keep if have effective radius
  data.table::setcolorder(blockwts, neworder = c('blockid', 'bgid', 'blockwt', 'block_radius_miles'))
  ############################ #
  
  # do not need to retain bgfips column since it has bgid, and bgfips is kept in bgid2fips
  # and blockwts is 170MB if bgfips kept as character, 125MB if bgid used instead of bgfips. 
  #    save space to convert bgfips to an integer bgid instead of the huge bgfips character string, as done for blockid vs blockfips
  # all.equal(unique(blockwts$bgfips), sort(unique(blockwts$bgfips))) # confirms they are already sorted after unique()
  
  ## area: previously did not bother saving columns that had block land area, water area, and plfips , BUT
  #    total area is useful for doing proximity scores for each block (and then parent block group) 
  #  - area is needed to calculate score when distance is smaller than effective radius of block, per formula in EJScreen tech doc,
  #  and as drafted in the proxistat package function proxistat()
  
  ############################################################################### #
  #  CREATE quaddata  for fast search for nearby block points ####
  #
  ########### convert block lat lon to XYZ units ########## #
  # Note quaddata is used to create localtree here but also is used in buffering code I think,
  #  to index the site points around which one is buffering, using the same quadtree structure,
  #  so quaddata will be saved here - it still gets used later. 
  if (exists("create_quaddata")) {
    # function from the EJAM package
    quaddata <- create_quaddata(
      pts = blockpoints, 
      idcolname = "blockid", 
      xyzcolnames = c("BLOCK_X", "BLOCK_Z", "BLOCK_Y")
    )
  } else {  
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
  }
  
  ############################################################################### #
  # set key for some of these
  
  # (can you set more than one key in a table? some documentation said yes, but some 
  #  data.table examples seemed to say no and thus need to setindex not setkey for other columns)
  
  data.table::setkey(  blockwts, blockid)
  data.table::setindex(blockwts, bgid) # not sure the best/right approach is 1 key and 1 index. I think you can have only 1 key col?   
  
  data.table::setkey(blockpoints,  blockid)
  
  data.table::setkey(  blockid2fips, blockid)
  data.table::setindex(blockid2fips, blockfips)
  
  data.table::setkey(  bgid2fips,       bgid)
  data.table::setindex(bgid2fips,       bgfips)
  
  ############################################################################### #
  # set attributes to store metadata on vintage
  
  if (save_as_data_for_package) {
    if (require(EJAM)) {
      bgid2fips     <- EJAM::metadata_add( bgid2fips ) # use defaults for metadata
      blockid2fips  <- EJAM::metadata_add( blockid2fips )
      blockpoints   <- EJAM::metadata_add( blockpoints )
      blockwts      <- EJAM::metadata_add( blockwts )
      quaddata      <- EJAM::metadata_add( quaddata )
      
      attr( bgid2fips,   "download_date") <- Sys.Date()
      attr(blockid2fips, "download_date") <- Sys.Date()
      attr(blockpoints,  "download_date") <- Sys.Date()
      attr(blockwts,     "download_date") <- Sys.Date()
      attr(quaddata,     "download_date") <- Sys.Date()
      
      
    } else {
      attributes(   bgid2fips)  <- c(attributes(   bgid2fips),  metadata)
      attributes(blockid2fips)  <- c(attributes(blockid2fips),  metadata)
      attributes(blockpoints)   <- c(attributes(blockpoints),   metadata)
      attributes(blockwts)      <- c(attributes(blockwts),      metadata)
      attributes(quaddata)      <- c(attributes(     quaddata), metadata) 
    }
    usethis::use_data(   bgid2fips,  overwrite = TRUE)
    usethis::use_data(blockid2fips,  overwrite = TRUE)
    usethis::use_data(blockpoints,   overwrite = TRUE)  
    usethis::use_data(blockwts,      overwrite = TRUE)
    usethis::use_data(quaddata,      overwrite = TRUE) 
  }
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


