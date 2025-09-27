test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowmiss(letters[1:3], values = letters[1:3]))
})

test_that("rowwise count of missing values is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowmiss(a), c(1L, 2L, 1L))
  expect_equal(gen_rowmiss(a, all_of(letters[25:26])), c(1L, 1L, 1L))
  b <- a %>% mutate(q = gen_rowmiss(.))
  expect_equal(b[["q"]], c(1L, 2L, 1L))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowmiss(a), c(1L, 2L, 1L))
})
