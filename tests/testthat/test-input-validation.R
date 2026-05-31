# census2020_get_data() validates its inputs before touching the network,
# so these checks need no internet.

test_that("census2020_get_data rejects an empty or non-character mystates", {
  expect_error(census2020_get_data(mystates = character(0)), "mystates")
  expect_error(census2020_get_data(mystates = NULL), "mystates")
  expect_error(census2020_get_data(mystates = 1:3), "mystates")
})

test_that("census2020_get_data rejects an unsupported sumlev", {
  expect_error(census2020_get_data(mystates = "DE", sumlev = 999), "sumlev")
  expect_error(census2020_get_data(mystates = "DE", sumlev = c(750, 150)), "sumlev")
})

test_that("a supported sumlev passes validation with all steps disabled", {
  # 750/150/140/50/40 are allowed. With every do_* step off the call should
  # return without raising (in particular without a sumlev validation error).
  expect_no_error(
    census2020_get_data(mystates = "DE", sumlev = 140,
                        do_download = FALSE, do_unzip = FALSE,
                        do_read = FALSE, do_clean = FALSE)
  )
})
