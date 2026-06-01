# Pure geometry/unit-conversion helpers (internal, hence the ::: calls).

test_that("area_sqmi_from_area_sqmeters converts using the documented constant", {
  conv <- census2020download:::area_sqmi_from_area_sqmeters
  # one square mile is 2,589,988 square meters
  expect_equal(conv(2589988), 1)
  expect_equal(conv(0), 0)
  expect_equal(conv(c(2589988, 5179976)), c(1, 2))
})

test_that("radius_miles_from_area_sqmi inverts area = pi * r^2", {
  rad <- census2020download:::radius_miles_from_area_sqmi
  expect_equal(rad(pi), 1)              # area pi -> radius 1
  expect_equal(rad(0), 0)
  expect_equal(rad(4 * pi), 2)
  # vectorised, same shape as input
  expect_length(rad(c(pi, 4 * pi, 9 * pi)), 3)
})

test_that("add_block_radius_miles_to_dt adds the column by reference and returns NULL", {
  add <- census2020download:::add_block_radius_miles_to_dt
  dt <- data.table::data.table(area_sqmi = c(pi, 4 * pi))
  res <- add(dt, dt$area_sqmi)
  expect_null(res)
  expect_true("block_radius_miles" %in% names(dt))
  expect_equal(dt$block_radius_miles, c(1, 2))
})
