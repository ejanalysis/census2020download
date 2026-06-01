# census2020_save_datasets() splits a cleaned blocks table into the five
# data.tables used by EJAM and computes population weights.

# Three blocks: two in block group ...001 (pop 30 and 10) and one in block
# group ...002 with zero population.
fake_blocks <- function() {
  data.table::data.table(
    blockfips = c("100010401001000", "100010401001001", "100010401002000"),
    pop       = c(30L, 10L, 0L),
    area      = c(2589988, 2589988, 2589988),  # 1 sq mile each
    lat       = c(39.1, 39.2, 39.3),
    lon       = c(-75.5, -75.6, -75.7)
  )
}

test_that("save_datasets returns the five expected tables", {
  out <- census2020_save_datasets(fake_blocks(), add_metadata = FALSE)
  expect_named(out, c("bgid2fips", "blockid2fips", "blockpoints", "blockwts", "quaddata"))
  expect_true(all(vapply(out, data.table::is.data.table, logical(1))))
})

test_that("blockwt is the block's share of its block group population", {
  out <- census2020_save_datasets(fake_blocks(), add_metadata = FALSE)
  bw <- out$blockwts
  expect_equal(nrow(bw), 3)
  # block group ...001: 30/40 and 10/40; block group ...002: 0 pop -> weight 0
  expect_equal(sort(bw$blockwt), c(0, 0.25, 0.75))
})

test_that("block_radius_miles is sqrt(area_sqmi / pi); 1 sq mile -> 1/sqrt(pi)", {
  out <- census2020_save_datasets(fake_blocks(), add_metadata = FALSE)
  expect_equal(unique(out$blockwts$block_radius_miles), sqrt(1 / pi))
})

test_that("blockid is a 1..N row index shared across the tables", {
  out <- census2020_save_datasets(fake_blocks(), add_metadata = FALSE)
  expect_equal(out$blockid2fips$blockid, 1:3)
  expect_equal(out$blockpoints$blockid, 1:3)
  expect_setequal(out$blockwts$blockid, 1:3)
})

test_that("keep_pop = TRUE retains population columns in blockwts", {
  out <- census2020_save_datasets(fake_blocks(), add_metadata = FALSE, keep_pop = TRUE)
  expect_true("blockpop" %in% names(out$blockwts))
  expect_true("bgpop" %in% names(out$blockwts))
})

test_that("save_datasets does not mutate the caller's data.table", {
  blocks <- fake_blocks()
  before <- data.table::copy(blocks)
  census2020_save_datasets(blocks, add_metadata = FALSE)
  expect_identical(blocks, before)
})
