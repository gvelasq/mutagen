test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowmedian(letters[1:3], n = 1))
})

test_that("rowwise median value is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = c(1, NA, 2), y = c(2, 3, 2), z = c(4, NA, 5))
  expect_equal(gen_rowmedian(a), c(2, 3, 2))
  expect_equal(gen_rowmedian(a, all_of(letters[25:26])), c(3, 3, 3.5))
  b <- a %>% mutate(q = gen_rowmedian(.))
  expect_equal(b[["q"]], c(2, 3, 2))
  c <- a %>% mutate(w = "a", .before = "x") %>% mutate(q = gen_rowmedian(.))
  expect_equal(c[["q"]], rep(NA_real_, 3))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = c(1, NA, 2), y = c(2, 3, 2), z = c(4, NA, 5))
  expect_equal(gen_rowmedian(a), c(2, 3, 2))
})
