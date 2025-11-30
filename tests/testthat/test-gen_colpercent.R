test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_colpercent(letters[1:3]))
})

test_that("tidy selection of >1 column passed to col argument fails", {
  expect_error(gen_colpercent(mtcars, c(cyl, gear)))
})

test_that("non-character objects passed to by argument fail", {
  expect_error(gen_colpercent(mtcars, gear, by = 1))
})

test_that("non-logical objects passed to prop argument fail", {
  expect_error(gen_colpercent(mtcars, by = "cyl", prop = 1))
})

test_that("column percent is correct", {
  library(dplyr, warn.conflicts = FALSE)
  b <-
    mtcars %>%
    mutate(
      pct1 = gen_colpercent(., gear),
      pct2 = gen_colpercent(., gear, by = "cyl"),
      pct3 = gen_colpercent(., gear, by = c("cyl", "carb")),
      prop1 = gen_colpercent(., gear, prop = TRUE)
    )
  pct1_vec <- c(3.389831, 3.389831, 3.389831, 2.542373, 2.542373, 2.542373, 2.542373, 3.389831, 3.389831, 3.389831, 3.389831, 2.542373, 2.542373, 2.542373, 2.542373, 2.542373, 2.542373, 3.389831, 3.389831, 3.389831, 2.542373, 2.542373, 2.542373, 2.542373, 2.542373, 3.389831, 4.237288, 4.237288, 4.237288, 4.237288, 4.237288, 3.389831)
  pct2_vec <- c(14.814815, 14.814815, 8.888889, 11.111111, 6.521739, 11.111111, 6.521739, 8.888889, 8.888889, 14.814815, 14.814815, 6.521739, 6.521739, 6.521739, 6.521739, 6.521739, 6.521739, 8.888889, 8.888889, 8.888889, 6.666667, 6.521739, 6.521739, 6.521739, 6.521739, 8.888889, 11.11111, 11.11111, 10.869565, 18.518519, 10.869565, 8.888889)
  pct3_vec <- c(25, 25, 21.05263, 50, 25, 50, 15, 15.38462, 15.38462, 25, 25, 33.33333, 33.33333, 33.33333, 15, 15, 15, 21.05263, 15.38462, 21.05263, 15.78947, 25, 25, 15, 25, 21.05263, 19.23077, 19.23077, 25, 100, 100, 15.38462)
  prop1_vec <- pct1_vec / 100
  expect_equal(b[["pct1"]], pct1_vec, tolerance = 1e-6)
  expect_equal(b[["pct2"]], pct2_vec, tolerance = 1e-6)
  expect_equal(b[["pct3"]], pct3_vec, tolerance = 1e-6)
  expect_equal(b[["prop1"]], prop1_vec, tolerance = 1e-6)
})
