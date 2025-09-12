test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rowlast(letters[1:3]))
})

test_that("first rowwise nonmissing value is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowlast(a), c(4, 3, 5))
  expect_equal(gen_rowlast(a, all_of(letters[24:25])), c(1, 3, 2))
  b <- a %>% mutate(q = gen_rowlast(.))
  expect_equal(b[["q"]], c(4, 3, 5))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rowlast(a), c(4, 3, 5))
})
