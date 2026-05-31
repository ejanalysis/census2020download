# census2020_clean() renames Census FTP columns to friendly names, computes
# total area, and subsets to cols_to_keep. It is internal, hence the ::: calls.

# A minimal stand-in for the output of census2020_read(): a couple of blocks
# with the raw Census (FTP) column names that the cleaner knows how to map.
fake_read_output <- function() {
  data.frame(
    LOGRECNO = c(1L, 2L),
    GEOCODE  = c("100010401001000", "100010401001001"),
    AREALAND = c(1000, 2000),
    AREAWATR = c(10, 0),
    POP100   = c(50L, 0L),
    HU100    = c(20L, 0L),
    INTPTLAT = c(39.1, 39.2),
    INTPTLON = c(-75.5, -75.6),
    P0020001 = c(50L, 0L),   # pop
    stringsAsFactors = FALSE
  )
}

test_that("default clean returns blockfips/lat/lon/pop/area as a keyed data.table", {
  out <- census2020download:::census2020_clean(fake_read_output())
  expect_s3_class(out, "data.table")
  expect_setequal(names(out), c("blockfips", "lat", "lon", "pop", "area"))
  # area is land + water in square meters
  expect_equal(out$area, c(1010, 2000))
  expect_equal(out$pop, c(50L, 0L))
  expect_equal(data.table::key(out), "blockfips")
})

test_that("clean does not modify the data.frame passed in (copy semantics)", {
  input <- fake_read_output()
  before <- names(input)
  census2020download:::census2020_clean(input)
  expect_identical(names(input), before)
})

test_that("cols_to_keep = 'all' keeps every mapped column", {
  out <- census2020download:::census2020_clean(fake_read_output(), cols_to_keep = "all")
  expect_true(all(c("blockfips", "lat", "lon", "pop", "area",
                    "arealand", "areawater", "pop100", "housingunits") %in% names(out)))
})

test_that("non-block sumlev renames blockfips to fips", {
  out <- census2020download:::census2020_clean(fake_read_output(), sumlev = 150)
  expect_true("fips" %in% names(out))
  expect_false("blockfips" %in% names(out))
})

test_that("cols_to_keep accepts original FTP names too", {
  out <- census2020download:::census2020_clean(fake_read_output(),
                                               cols_to_keep = c("GEOCODE", "POP100"))
  expect_true("blockfips" %in% names(out))
  expect_true("pop100" %in% names(out))
})
