test_that("non-list objects fail", {
  expect_error(gen_listcol_na(letters[1:3]))
  expect_error(gen_listcol_na(1:3))
})

test_that("list-column NULLs are converted to NAs", {
  library(dplyr)
  a <-
    mtcars %>%
    select(cyl, vs, am) %>%
    slice(1:6) %>%
    as_tibble() %>%
    mutate(listcol = list(NULL, "b", "c", "d", "e", "f")) %>%
    mutate(across(starts_with("listcol"), gen_listcol_na))
  expect_equal(a[["listcol"]][[1]], NA)
})

test_that("parallelization works", {
  library(dplyr)
  mirai::daemons(parallel::detectCores() - 1)
  a <-
    mtcars %>%
    select(cyl, vs, am) %>%
    slice(1:6) %>%
    as_tibble() %>%
    mutate(listcol = list(NULL, "b", "c", "d", "e", "f")) %>%
    mutate(across(starts_with("listcol"), gen_listcol_na))
  expect_equal(a[["listcol"]][[1]], NA)
})
