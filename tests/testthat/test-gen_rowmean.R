test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowmean(letters[1:3], n = 1))
})

test_that("rowwise arithmetic mean value is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowmean(a), c(2.5, 3.0, 3.5))
  expect_equal(gen_rowmean(a, all_of(letters[25:26])), c(4, 3, 5))
  b <- a %>% mutate(q = gen_rowmean(.))
  expect_equal(b[["q"]], c(2.5, 3.0, 3.5))
  c <- a %>% mutate(w = "a", .before = "x") %>% mutate(q = gen_rowmean(.))
  expect_equal(c[["q"]], rep(NA_real_, 3))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowmean(a), c(2.5, 3.0, 3.5))
})
