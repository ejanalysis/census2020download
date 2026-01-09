#' Compile Census 2020 block data for all US states once downloaded and unzipped
#' used by [census2020_get_data()]
#' @details
#'   Not extensively tested.
#'
#'   Attempts to read files already downloaded and unzipped, data files for specified states
#'   from the US Census Bureau's website for Decennial Census file data.
#'
#'  Technical documentation of the files available from Census Bureau
#'  and for list of possible fields etc.:
#'
#'   - [Technical Documentation folder](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/)
#'   - [Technical Documentation PDF for 2020 Census PL94 171 Redistricting States files](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_StatesTechDoc_English.pdf)
#'   - [Technical Documentation PDF for 2020 Census PL94 171 Redistricting National, see pg 6-26](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/summary-file/2020Census_PL94_171Redistricting_NationalTechDoc.pdf)
#'   - [DHC Technical Documentation PDF for 2020 Census details](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/demographic-and-housing-characteristics-file-and-demographic-profile/2020census-demographic-and-housing-characteristics-file-and-demographic-profile-techdoc.pdf)
#'   - [DHC Table Matrix xlsx ](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/complete-tech-docs/demographic-and-housing-characteristics-file-and-demographic-profile/2020-dhc-table-matrix.xlsx)
#'   - [Island Areas PDF Tech. Doc. ](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf)
#'   - [Island Areas PDF Readme for American Samoa](https://www2.census.gov/programs-surveys/decennial/2020/data/island-areas/american-samoa/demographic-and-housing-characteristics-file/2020-iac-dhc-readme.pdf)
#'   - [Island Areas table/file details](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf): "For a layout of the individual tables for each file, refer to Chapter 3, Subject Locator, List of Tables, and Table Matrixes and Chapter 4, Data Dictionary for Fields in the Geographic Header File in the 2020 Island Areas Censuses Demographic and Housing Characteristics Summary File
#'  Technical Documentation." -- Census Bureau e.g., table P1 is in segment 9.
#'     - [American Samoa Table Matrix](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-american-samoa-table-matrix.xlsx)
#'     - [Commonwealth of the Northern Mariana Islands Table Matrix](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-cnmi-table-matrix.xlsx)
#'     - [Guam Table Matrix](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-guam-table-matrix.xlsx)
#'     - [United States Virgin Islands Table Matrix](https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-usvi-table-matrix.xlsx)
#'
#'
#'   \preformatted{
#'     for example:
#'  #  AREALAND      Area (Land)
#'  #  AREAWATR      Area (Water)
#'
#'  #  BASENAME      Area Base Name
#'  #  NAME          Area Name-Legal/Statistical Area Description (LSAD) Term-Part Indicator
#'  #  FUNCSTAT      Functional Status Code
#'  #  GCUNI         Geographic Change User Note Indicator
#'
#'  #  POP100        Population Count (100%)
#'  #  HU100         Housing Unit Count (100%)
#'  #  INTPTLAT      Internal Point (Latitude)
#'  #  INTPTLON      Internal Point (Longitude)
#'
#'  File 1 has Table P1 and
#'   Table P2. HISPANIC OR LATINO, AND NOT HISPANIC OR LATINO BY RACE
#'  Universe: Total population
#'  P0020001 P0020002 P0020003 P0020004 P0020005 P0020006 P0020007 P0020008 P0020009 P0020010 P0020011 P0020012 P0020013 P0020014
#'  Total: P0020001
#'   Hispanic or Latino P0020002
#'  Not Hispanic or Latino: P0020003
#'   Population of one race: P0020004
#'   White alone P0020005
#'  Black or African American alone P0020006
#'  American Indian and Alaska Native alone P0020007
#'  Asian alone P0020008
#'  Native Hawaiian and Other Pacific Islander alone P0020009
#'  Some Other Race alone P0020010
#'  Population of two or more races: Population of two races: P0020011
#'
#'  }
#'
#'  See the package [totalcensus](https://github.com/GL-Li/totalcensus)
#'  for another attempt to facilitate downloads of files of data.
#'
#'  See the [tidycensus package](https://walker-data.com/tidycensus/) for using the API to request tabular data.
#'
#' @param mystates can be vector of 2-letter abbreviations of states
#' @param folder path
#' @param sumlev default is 750, for blocks (but those are not available for Island Areas)
#' @param filenumbers a vector with any or all of 1,2,3 --
#'   default is file 1.
#'   File01 has Tables P1 and P2. Those are the ones with total population count.
#'   File02 has Tables P3, P4, and H1.
#'   File03 has Table P5.
#' @param best_header_cols default is a few key columns like POP100, GEOCODE (fips), etc.
#' @param best_data_cols default is key race ethnicity fields
#' @seealso [census2020_download()] [census2020_unzip()] [census2020_get_data()]
#'
#' @aliases census2020_read_islandareas
#'
#' @return data.frame of 1 row per block, for example
#'
#' @examples \dontrun{
#'  # library(census2020download)
#'  census2020_download('./census2020zip', mystates = c('MD', 'DC'))
#'  census2020_unzip('./census2020zip','./census2020out')
#'  c2 <- census2020_read(folder = './census2020out', mystates = c('MD', 'DC'))
#'  dim(c2)
#'  str(c2)
#'  head(c2)
#'  sum(c2$POP100)
#'  plot(
#'    c2$INTPTLON[substr(c2$GEOCODE,1,2) == '24'],
#'    c2$INTPTLAT[substr(c2$GEOCODE,1,2) == '24'], pch = '.')
#'  c2$LOGRECNO <- NULL
#'  colnames(c2) <- census2020download::census_col_names_map$rname[
#'     match(colnames(blocks2020), census2020download::census_col_names_map$ftpname)
#'     ]
#'  }
#'
#'
census2020_read <- function(mystates = NULL,
                            folder = NULL,
                            sumlev = 750,
                            filenumbers = 1,
                            best_header_cols = c("LOGRECNO", "GEOCODE",
                                               "AREALAND", "AREAWATR",
                                               "POP100", "HU100",
                                               "INTPTLAT", "INTPTLON"),
                            best_data_cols = paste0("P00", (20001:20011))) {
  # Gets census 2020 data
  #  based on code provided by the Census Bureau for reading and merging their raw data files
  if (is.null(folder)) {folder <- getwd()}
  if (is.null(mystates)) {
    pl_files <- list.files(folder, pattern = 'geo2020.') # .pl or .dhc if US/DC/PR or Island Areas
    mystates <- substr(pl_files,1,2)
  } else {
    mystates <- tolower(mystates)
  }
  mystates <- unique(mystates)

  # example of format of unzipped files (for files 1,2,3,geo), for Alabama (al)
  # al000012020.pl
  # al000022020.pl
  # al000032020v
  # algeo2020.pl
  # .pl or .dhc if US/DC/PR or Island Areas #####  ISLAND AREAS
  ext <- rep("pl", length(mystates))
  ext[mystates %in% c("vi", "gu", "mp", "as")] <- "dhc"
  islandfiles <- paste0(mystates, '0000', 9, '2020.', ext) #####  ISLAND AREAS
  t1files <- paste0(mystates, '0000', 1, '2020.', ext)
  t2files <- paste0(mystates, '0000', 2, '2020.', ext)
  t3files <- paste0(mystates, '0000', 3, '2020.', ext)

  geofiles <- paste0(mystates, 'geo2020.', ext)

  ######## ***SEE pl_all_4_2020_dar.R *** ##############

  part1_file_path  <- file.path(folder, t1files)
  part2_file_path  <- file.path(folder, t2files)
  part3_file_path  <- file.path(folder, t3files)
  part9_file_path  <- file.path(folder, islandfiles) #####  ISLAND AREAS:

  header_file_path <- file.path(folder, geofiles) # ;print(header_file_path) #  algeo2020.pl  for alabama  in    al2020.pl.zip

  # *** SHOULD CHANGE THIS TO LIMIT IT TO READING ONLY THE NECESSARY COLUMNS, ******************

  # DATA - island areas
  ## island areas have these in every data file:
  #  FILEID        File Identification
  #  STUSAB        State/US-Abbreviation (USPS)
  #  CHARITER      Characteristic Iteration
  #  CIFSN         Characteristic Iteration File Sequence Number
  #  LOGRECNO      Logical Record Number
## then the data from given table

# GEO - island areas
#   The Geographic Header Record for the 2020 IAC can be found at the following links:
#     • American Samoa, Guam, Commonwealth of the Northern Mariana Islands.
  # https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-geographic-header-record-as-cnmi-guam.xlsx
#   • United States Virgin Islands.
  # https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-geographic-header-record-usvi.xlsx
  # per https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf


  # GEO - STATES/DC/PR
  # ---------------------------- -
  # Assign names to data columns  -from header (geo file) #####
  # ---------------------------- -
  #  FILEID        File Identification

  #  STUSAB        State/US-Abbreviation (USPS)

  #  SUMLEV        Summary Level   750=Census Block pl file, 140 and 150 are tract and blockgroup

  #  GEOVAR        Geographic Variant
  #  GEOCOMP       Geographic Component
  #  CHARITER      Characteristic Iteration
  #  CIFSN         Characteristic Iteration File Sequence Number

  #  LOGRECNO      Logical Record Number

  #  GEOID         Geographic Record Identifier

  #  GEOCODE       Geographic Code Identifier
  #  REGION        Region
  #  DIVISION      Division
  #  STATE         State (FIPS)
  #  STATENS       State (NS)

  #  COUNTY        County (FIPS)

  #  COUNTYCC      FIPS County Class Code
  #  COUNTYNS      County (NS)
  #  COUSUB        County Subdivision (FIPS)
  #  COUSUBCC      FIPS County Subdivision Class Code
  #  COUSUBNS      County Subdivision (NS)
  #  SUBMCD        Subminor Civil Division (FIPS)
  #  SUBMCDCC      FIPS Subminor Civil Division Class Code
  #  SUBMCDNS      Subminor Civil Division (NS)
  #  ESTATE        Estate (FIPS)
  #  ESTATECC      FIPS Estate Class Code
  #  ESTATENS      Estate (NS)
  #  CONCIT        Consolidated City (FIPS)
  #  CONCITCC      FIPS Consolidated City Class Code
  #  CONCITNS      Consolidated City (NS)

  #  PLACE         Place (FIPS)
  #  PLACECC       FIPS Place Class Code
  #  PLACENS       Place (NS)

  #  TRACT         Census Tract
  #  BLKGRP        Block Group
  #  BLOCK         Block

  #  AIANHH        American Indian Area/Alaska Native Area/Hawaiian Home Land (Census)
  #  AIHHTLI       American Indian Trust Land/Hawaiian Home Land Indicator
  #  AIANHHFP      American Indian Area/Alaska Native Area/Hawaiian Home Land (FIPS)
  #  AIANHHCC      FIPS American Indian Area/Alaska Native Area/Hawaiian Home Land Class Code
  #  AIANHHNS      American Indian Area/Alaska Native Area/Hawaiian Home Land (NS)
  #  AITS          American Indian Tribal Subdivision (Census)
  #  AITSFP        American Indian Tribal Subdivision (FIPS)
  #  AITSCC        FIPS American Indian Tribal Subdivision Class Code
  #  AITSNS        American Indian Tribal Subdivision (NS)
  #  TTRACT        Tribal Census Tract
  #  TBLKGRP       Tribal Block Group
  #  ANRC          Alaska Native Regional Corporation (FIPS)
  #  ANRCCC        FIPS Alaska Native Regional Corporation Class Code
  #  ANRCNS        Alaska Native Regional Corporation (NS)
  #  CBSA          Metropolitan Statistical Area/Micropolitan Statistical Area
  #  MEMI          Metropolitan/Micropolitan Indicator
  #  CSA           Combined Statistical Area
  #  METDIV        Metropolitan Division
  #  NECTA         New England City and Town Area
  #  NMEMI         NECTA Metropolitan/Micropolitan Indicator
  #  CNECTA        Combined New England City and Town Area
  #  NECTADIV      New England City and Town Area Division
  #  CBSAPCI       Metropolitan Statistical Area/Micropolitan Statistical Area Principal City Indicator
  #  NECTAPCI      New England City and Town Area Principal City Indicator
  #  UA            Urban Area
  #  UATYPE        Urban Area Type
  #  UR            Urban/Rural
  #  CD116         Congressional District (116th)
  #  CD118         Congressional District (118th)
  #  CD119         Congressional District (119th)
  #  CD120         Congressional District (120th)
  #  CD121         Congressional District (121st)
  #  SLDU18        State Legislative District (Upper Chamber) (2018)
  #  SLDU22        State Legislative District (Upper Chamber) (2022)
  #  SLDU24        State Legislative District (Upper Chamber) (2024)
  #  SLDU26        State Legislative District (Upper Chamber) (2026)
  #  SLDU28        State Legislative District (Upper Chamber) (2028)
  #  SLDL18        State Legislative District (Lower Chamber) (2018)
  #  SLDL22        State Legislative District (Lower Chamber) (2022)
  #  SLDL24        State Legislative District (Lower Chamber) (2024)
  #  SLDL26        State Legislative District (Lower Chamber) (2026)
  #  SLDL28        State Legislative District (Lower Chamber) (2028)
  #  VTD           Voting District
  #  VTDI          Voting District Indicator
  #  ZCTA          ZIP Code Tabulation Area (5-Digit)
  #  SDELM         School District (Elementary)
  #  SDSEC         School District (Secondary)
  #  SDUNI         School District (Unified)
  #  PUMA          Public Use Microdata Area

  #  AREALAND      Area (Land)
  #  AREAWATR      Area (Water)

  #  BASENAME      Area Base Name
  #  NAME          Area Name-Legal/Statistical Area Description (LSAD) Term-Part Indicator
  #  FUNCSTAT      Functional Status Code
  #  GCUNI         Geographic Change User Note Indicator

  #  POP100        Population Count (100%)

  #  HU100         Housing Unit Count (100%)

  #  INTPTLAT      Internal Point (Latitude)
  #  INTPTLON      Internal Point (Longitude)

  #  LSADC         Legal/Statistical Area Description Code
  #  PARTFLAG      Part Flag
  #  UGA           Urban Growth Area
  # -----------------------------


  # new functionality in readr::read_   we could use instead of loop below:
  #
  #
  # Reading multiple files at once
  #
  # Edition two has built-in support for reading sets of files with the same columns into one output table in a single command.
  # Just pass the filenames to be read in the same vector to the reading function.
  #  we can efficiently read files into one tibble by passing the filenames directly to readr.
  #
  # part1  <- readr::read_delim(part1_file_path, col_names = part1_colnames, show_col_types = FALSE, delim = "|")
  # part1 <- part1[ , colnames(part1) %in% cols_needed]
  # readr::read_delim(files)

  header_col_names <- c("FILEID", "STUSAB", "SUMLEV", "GEOVAR", "GEOCOMP", "CHARITER", "CIFSN", "LOGRECNO", "GEOID",
                        "GEOCODE", "REGION", "DIVISION",
                        "STATE", "STATENS",
                        "COUNTY", "COUNTYCC", "COUNTYNS", "COUSUB", "COUSUBCC", "COUSUBNS",
                        "SUBMCD", "SUBMCDCC", "SUBMCDNS",
                        "ESTATE", "ESTATECC", "ESTATENS",
                        "CONCIT", "CONCITCC", "CONCITNS",
                        "PLACE", "PLACECC", "PLACENS",
                        "TRACT", "BLKGRP", "BLOCK",
                        "AIANHH", "AIHHTLI", "AIANHHFP", "AIANHHCC", "AIANHHNS", "AITS", "AITSFP", "AITSCC", "AITSNS",
                        "TTRACT", "TBLKGRP", "ANRC", "ANRCCC", "ANRCNS", "CBSA", "MEMI", "CSA", "METDIV", "NECTA",
                        "NMEMI", "CNECTA", "NECTADIV", "CBSAPCI", "NECTAPCI", "UA", "UATYPE", "UR", "CD116", "CD118",
                        "CD119", "CD120", "CD121", "SLDU18", "SLDU22", "SLDU24", "SLDU26", "SLDU28", "SLDL18", "SLDL22",
                        "SLDL24", "SLDL26", "SLDL28", "VTD", "VTDI", "ZCTA", "SDELM", "SDSEC", "SDUNI", "PUMA",
                        "AREALAND", "AREAWATR",
                        "BASENAME", "NAME", "FUNCSTAT", "GCUNI",
                        "POP100", "HU100",
                        "INTPTLAT", "INTPTLON",
                        "LSADC", "PARTFLAG", "UGA")
  combinedstates <- NULL

  for (i in seq_along(mystates)) {

    cat(paste0('Reading ', toupper(mystates[i])), ' geo file . . . \n')

    header <- try(readr::read_delim(header_file_path[i], col_names = header_col_names,
                                    guess_max = 10000, # GEOCODE is chr not dbl, BLOCK is chr or integer not logical, etc.
                                    show_col_types = FALSE, delim = "|"))
    if ("try-error" %in% class(header)) {print(header_file_path[i]); stop('cannot find or read file')}
    if (NROW(vroom::problems(header)) > 0) {print(cbind(problem_colname = header_col_names[vroom::problems(header)$col], vroom::problems(header)))}

    # KEEP ONLY BLOCKS NOT OTHER GEOGRAPHIES LIKE TRACT
    ## but note island areas do not have summary level 750, blocks, and only have e.g., blockgroup, tract, etc. (150, 140, etc.)
    # table(header$SUMLEV, useNA = 'always')
    # header[header$SUMLEV == '040', c(9, 13:16, 30:35)] # state
    # header[header$SUMLEV == '050', c(9, 13:16, 30:35)] # county?
    # header[header$SUMLEV == '140', c(9, 13:16, 30:35)] # tract
    # header[header$SUMLEV == '150', c(9, 13:16, 30:35)] # blockgroup

    header <- header[header$SUMLEV %in% sumlev, ]
    if (NROW(header) == 0) {warning("sumlev 750 means blocks; no records found for ", toupper(mystates[i])," with sumlev ", paste0(sumlev, collapse = ","))}

    # mergebycolnames <- c("LOGRECNO", "STUSAB", "FILEID", "CHARITER")
    mergebycolnames <- "LOGRECNO"

    # KEEP ONLY THE CRITICAL COLUMNS
    # cols_to_keep <- unique(c(mergebycolnames, bestcols))
    header <- header[, best_header_cols]
    cols_needed <- c(best_header_cols, best_data_cols)
    list_needed <- list(header[,names(header) != 'CIFSN'])#  list(header) # list(header[,-7]) # cifsn - they left it in table 3 only, but maybe I can keep it in the header only instead

    # print(head(header))
    # str(list_needed)
    # stop('that was geo header')

    if (1 %in% filenumbers && file.exists(part1_file_path[i])) { # this file number does not exist for island areas looks like
      cat(paste0('Reading ', toupper(mystates[i])), ' part1 data file . . . \n')
      part1_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                          paste0("P00", c(10001:10071, 20001:20073)))
      part1  <- readr::read_delim(part1_file_path[i], col_names = part1_colnames,
                                  guess_max = 5000,
                                  show_col_types = FALSE, delim = "|")
      if (NROW(vroom::problems(part1)) > 0) {print(vroom::problems(part1))}
      part1 <- part1[ , colnames(part1) %in% cols_needed]
      # cols_needed <- c(cols_needed, colnames(part1)[!(colnames(part1) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO" ))])
      list_needed <- c(list_needed, list(part1)) # try leaving that field in here
    }
    if (2 %in% filenumbers) {
      cat(paste0('Reading ', toupper(mystates[i])), ' part2 data file . . . \n')
      part2_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                          paste0("P00", c(30001:30071, 40001:40073)),
                          paste0("H00", 10001:10003))
      part2  <- readr::read_delim(part2_file_path[i], col_names = part2_colnames,
                                  guess_max = 5000,
                                  show_col_types = FALSE,  delim = "|")
      if (NROW(vroom::problems(part2)) > 0) {print(vroom::problems(part2))}
      cols_needed <- c(cols_needed, colnames(part2)[!(colnames(part2) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO"))])
      list_needed <- c(list_needed, list(part2[,names(part2)[!(names(part2) %in% 'CIFSN')]] ))
    }
    if (3 %in% filenumbers) {
      cat(paste0('Reading ', toupper(mystates[i])), ' part3 data file . . . \n')
      part3_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                          paste0("P00", 50001:50010))
      part3  <- readr::read_delim(part3_file_path[i], col_names = part3_colnames,
                                  guess_max = 5000,
                                  show_col_types = FALSE,  delim = "|")
      if (NROW(vroom::problems(part3)) > 0) {print(vroom::problems(part3))}
      cols_needed <- c(cols_needed, colnames(part3)[!(colnames(part3) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO"))])
      list_needed <- c(list_needed, list(part3))   #[,names(part3)[!(names(part3) %in% 'CIFSN')]] )) # seems like they did not remove that field from part3
    }
    ########################################################################################################################################### #
    #####  ISLAND AREAS:

    if (any(mystates %in% c("vi", "gu", "mp", "as"))) {
      # need file 9 for P1
      cat(paste0('Reading ', toupper(mystates[i])), ' part9 data file with Island Areas info . . . \n')

      ## formats differ among island areas !!

      if (mystates[i] == "mp") {
        part9_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                            # see chapter 3 of https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf
                            paste0("P00", c(10001, 20001:20003, 30001:30032, 40001:40032, 50001:50034, 60001:60034, 70001:70007, 80001:80039, paste0("other", 1:39 ))))
      }
      if (mystates[i] == "gu") {
        part9_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                            # see chapter 3 of https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf
                            paste0("P00", c(10001, 20001:20003, 30001:30034, 40001:40034, 50001:50036, 60001:60036, 70001:70007, 80001:80039, paste0("other", 1:39 ))))
      }
      if (mystates[i] %in% c("vi", "as")) {
        part9_colnames <- c("FILEID", "STUSAB", "CHARITER", "CIFSN", "LOGRECNO",
                            ## field names here are based on 2020-iac-dhc-american-samoa-table-matrix.xlsx at https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-american-samoa-table-matrix.xlsx
                            # as linked from chapter 3 of https://www2.census.gov/programs-surveys/decennial/2020/technical-documentation/island-areas-tech-docs/dhc/2020-iac-dhc-technical-documentation.pdf
                            paste0("P00", c(10001, 20001:20003, 30001:30030, 40001:40030, 50001:50032, 60001:60032, 70001:70007, 80001:80039, paste0("other", 1:39 ))))
      }

      part9  <- readr::read_delim(part9_file_path[i], col_names = part9_colnames,
                                  guess_max = 5000,
                                  show_col_types = FALSE,  delim = "|")
      if (NROW(vroom::problems(part9)) > 0) {print(vroom::problems(part9))}
      cols_needed <- c(cols_needed, colnames(part9)[!(colnames(part9) %in% c('FILEID', 'STUSAB','CHARITER', "CIFSN" ,   "LOGRECNO"))])
      list_needed <- c(list_needed, list(part9[,names(part9)[!(names(part9) %in% 'CIFSN')]] ))
    }
    ########################################################################################################################################### #

    # ---------------------------- -
    # Merge the data #######
    # ---------------------------- -
    combine <- Reduce(function(x, y) {
      merge(x, y, by = mergebycolnames) # LOGRECNO
    },
    list_needed
    )

#  dim(combine) # *224* columns for VI and AS,  but  *240* cols for GU  and *232* for MP.
# GU: LOGRECNO GEOCODE AREALAND AREAWATR POP100 HU100 INTPTLAT INTPTLON FILEID STUSAB CHARITER P0010001 .."X219"  .. "X234"  ???
# VI: LOGRECNO GEOCODE AREALAND AREAWATR POP100 HU100 INTPTLAT INTPTLON FILEID STUSAB CHARITER P0010001. .. "P00other39"
    # ---------------------------- -
    # Order the data #########
    # ---------------------------- -
    combine <- combine[order(combine$LOGRECNO) , ]
    rownames(combine) <- NULL
    combinedstates <- data.table::rbindlist(list(combinedstates, combine), fill = TRUE) # uses NA values if
    data.table::setDF(combinedstates)
    # combinedstates <- rbind(combinedstates, combine) # fails for island areas since they have differing sets of indicators
    # end of 1 state
  }
  return(combinedstates) # a SINGLE data.frame compilation of states and filenumbers
}
