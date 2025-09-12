test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowmin(letters[1:3]))
})

test_that("rowwise minimum value is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowmin(a), c(1, 3, 2))
  expect_equal(gen_rowmin(a, everything()), c(1, 3, 2))
  expect_equal(gen_rowmin(a, starts_with(letters[25:26])), c(4, 3, 5))
  b <- a %>% mutate(q = gen_rowmin(.))
  expect_equal(b[["q"]], c(1, 3, 2))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowmin(a), c(1, 3, 2))
})
