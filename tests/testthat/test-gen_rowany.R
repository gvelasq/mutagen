test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowany(letters[1:3], values = letters[1:3]))
})

test_that("non-list objects passed to values argument fail", {
  expect_error(gen_rowany(mtcars, values = letters[1:3]))
})

test_that("row count is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = 1:3, y = rep(NA, 3), z = letters[1:3], aa = rep(FALSE, 3))
  val <- list(1, NA, "a", FALSE)
  val2 <- list(5, NaN, "d", Inf)
  expect_equal(gen_rowany(a, values = val), c(1L, 1L, 1L))
  expect_equal(gen_rowany(a, everything(), values = val), c(1L, 1L, 1L))
  expect_equal(gen_rowany(a, starts_with(letters[25:26]), values = val), c(1L, 1L, 1L))
  b <- a %>% mutate(q = gen_rowany(., values = val), r = gen_rowany(., values = val2))
  expect_equal(b[["q"]], c(1L, 1L, 1L))
  expect_equal(b[["r"]], c(0L, 0L, 0L))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = 1:3, y = rep(NA, 3), z = letters[1:3], aa = rep(FALSE, 3))
  val <- list(1, NA, "a", FALSE)
  expect_equal(gen_rowany(a, values = val), c(1L, 1L, 1L))
})
