# Sanity checks on the bundled lookup tables that the package code relies on.

test_that("census_col_names_map has the expected structure", {
  expect_s3_class(census_col_names_map, "data.frame")
  expect_true(all(c("ftpname", "rname", "longname") %in% names(census_col_names_map)))
  # the columns the cleaner depends on must be mapped
  expect_true(all(c("GEOCODE", "AREALAND", "AREAWATR", "INTPTLAT", "INTPTLON", "P0020001")
                  %in% census_col_names_map$ftpname))
  expect_identical(
    census_col_names_map$rname[census_col_names_map$ftpname == "GEOCODE"], "blockfips")
})

test_that("per-island column maps share the friendly-name schema", {
  for (m in list(census_col_names_map_vi, census_col_names_map_as,
                 census_col_names_map_gu, census_col_names_map_mp)) {
    expect_true(all(c("ftpname", "rname") %in% names(m)))
    expect_true("blockfips" %in% m$rname)
  }
})

test_that("lookup_states covers the states/DC/PR and the four Island Areas", {
  expect_true(all(c(datasets::state.abb, "DC", "PR", "VI", "GU", "MP", "AS")
                  %in% lookup_states$ST))
  # Island Areas are flagged as such
  islands <- lookup_states$ST[lookup_states$is.island.areas %in% TRUE]
  expect_true(all(c("VI", "GU", "MP", "AS") %in% islands))
})
