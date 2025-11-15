test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowsum(letters[1:3]))
})

test_that("non-length one logical vectors passed to na.rm argument fail", {
  expect_error(gen_rowsum(mtcars, na.rm = c(TRUE, TRUE)))
  expect_error(gen_rowsum(mtcars, na.rm = 1L))
  expect_error(gen_rowsum(mtcars, na.rm = NA))
})

test_that("rowwise sum is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(
    x = c(1, NA, 2),
    y = c(NA, 3, NA),
    z = c(4, NA, 5),
    aa = c("a", "b", "c"),
    bb = rep(NA, 3),
    cc = rep(NaN, 3)
  )
  expect_equal(gen_rowsum(a), c(5L, 3L, 7L))
  expect_equal(gen_rowsum(a, all_of(letters[25:26])), c(4L, 3L, 5L))
  b <- a %>% mutate(q = gen_rowsum(.), r = gen_rowsum(., na.rm = FALSE))
  expect_equal(b[["q"]], c(5L, 3L, 7L))
  expect_equal(b[["r"]], c(NA_real_, NA_real_, NA_real_))
  b <- a %>% mutate(q = gen_rowsum(., all_of(c("x", "cc")), na.rm = FALSE))
  expect_equal(b[["q"]], c(NaN, NA, NaN))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(
    x = c(1, NA, 2),
    y = c(NA, 3, NA),
    z = c(4, NA, 5),
    aa = c("a", "b", "c"),
    bb = rep(NA, 3),
    cc = rep(NaN, 3)
  )
  expect_equal(gen_rowsum(a), c(5L, 3L, 7L))
})
