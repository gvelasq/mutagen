test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_rownth(letters[1:3], n = 1))
})

test_that("non-numeric objects, non-length 1 objects, and numeric objects not \\
          coercible to an integer passed to n argument fail", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_error(gen_rownth(a, n = TRUE))
  expect_error(gen_rownth(a, n = c(1, 1)))
  expect_error(gen_rownth(a, n = 1.5))
})

test_that("rowwise nth nonmissing value is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rownth(a, n = 1), c(1, 3, 2))
  expect_equal(gen_rownth(a, n = 2), c(4, NA, 5))
  expect_equal(gen_rownth(a, all_of(letters[25:26]), n = 1), c(4, 3, 5))
  b <- a %>% mutate(q = gen_rownth(., n = 1), r = gen_rownth(., n = 2))
  expect_equal(b[["q"]], c(1, 3, 2))
  expect_equal(b[["r"]], c(4, NA, 5))
  c <-
    a %>%
    mutate(w = c("a", TRUE, NA), .before = "x") %>%
    mutate(q = gen_rownth(., n = 1), r = gen_rownth(., n = 2))
  expect_equal(c[["q"]], c("a", "TRUE", "2"))
  expect_equal(c[["r"]], c("1", "3", "5"))
})

test_that("parallelization works", {
  library(dplyr, warn.conflicts = FALSE)
  mirai::daemons(0)
  mirai::daemons(parallel::detectCores() - 1)
  a <- tibble(x = c(1, NA, 2), y = c(NA, 3, NA), z = c(4, NA, 5))
  expect_equal(gen_rownth(a, n = 1), c(1, 3, 2))
})
