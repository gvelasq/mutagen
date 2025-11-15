#' Generate rowwise sum
#'
#' This function returns the rowwise sum in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' If `na.rm` is `TRUE` (the default), missing values are removed. If `na.rm` is `FALSE`, the presence of an `NA` or `NaN` in any row will return `NA` or `NaN` for that row.
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to sum. Non-numeric columns are ignored.
#' @param na.rm Logical vector of length one passed onto [`base::sum()`](https://rdrr.io/r/base/sum.html).
#'
#' @returns A vector of the rowwise sum. The vector's type will be of common type to all rowwise numeric values.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5),
#'   aa = c("a", "b", "c"),
#'   bb = rep(NA, 3),
#'   cc = rep(NaN, 3)
#' )
#' gen_rowsum(a)
#' gen_rowsum(a, all_of(letters[25:26]))
#' b <- a %>% mutate(q = gen_rowsum(.), r = gen_rowsum(., na.rm = FALSE))
#' b
#' @export
gen_rowsum <- function(data, cols, na.rm = TRUE) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  stopifnot("na.rm must be a length one logical vector (TRUE or FALSE)" = isTRUE(na.rm) || isFALSE(na.rm))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  data <- dplyr::select(data, where(is.numeric))
  x <- purrr::pmap_vec(data, purrr::in_parallel(\(...) sum(..., na.rm = na.rm), na.rm = na.rm))
  x
}
