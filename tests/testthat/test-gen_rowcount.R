test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowcount(letters[1:3], values = letters[1:3]))
})

test_that("non-list objects passed to values argument fail", {
  expect_error(gen_rowcount(mtcars, values = letters[1:3]))
})

test_that("row count is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = 1:3, y = rep(NA, 3), z = letters[1:3], aa = rep(FALSE, 3))
  val <- list(1, NA, "a", FALSE)
  expect_equal(gen_rowcount(a, values = val), c(4L, 2L, 2L))
  expect_equal(gen_rowcount(a, everything(), values = val), c(4L, 2L, 2L))
  expect_equal(gen_rowcount(a, starts_with(letters[25:26]), values = val), c(2L, 1L, 1L))
  b <- a %>% mutate(q = gen_rowcount(., values = val))
  expect_equal(b[["q"]], c(4L, 2L, 2L))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = 1:3, y = rep(NA, 3), z = letters[1:3], aa = rep(FALSE, 3))
  val <- list(1, NA, "a", FALSE)
  expect_equal(gen_rowcount(a, values = val), c(4L, 2L, 2L))
})
