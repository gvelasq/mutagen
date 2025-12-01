test_that("non-data frame objects passed to data argument fail", {
  expect_error(gen_coldiff(letters[1:3]))
})

test_that("tidy selection of <2 columns passed to cols argument fails", {
  expect_error(gen_coldiff(mtcars, c(cyl)))
  expect_error(gen_coldiff(mtcars, c()))
})

test_that("non-matching objects passed to engine argument fail", {
  expect_error(gen_coldiff(mtcars, engine = "any"))
})

test_that("column difference indicator is correct", {
  library(dplyr, warn.conflicts = FALSE)
  a <- tibble(x = 1:3, y = as.double(1:3), z = 1.0001:3.0001)
  b <- a %>%
    mutate(
      q = gen_coldiff(., c(x, y)),
      r = gen_coldiff(., c(x, y), engine = "all.equal"),
      s = gen_coldiff(., c(x, z), engine = "all.equal", tolerance = 1e-4),
      t = gen_coldiff(., c(x, z), engine = "all.equal", tolerance = 1e-5)
    )
  b
  expect_equal(b[["q"]], rep(1L, 3))
  expect_equal(b[["r"]], rep(0L, 3))
  expect_equal(b[["s"]], rep(0L, 3))
  expect_equal(b[["t"]], rep(1L, 3))
})
