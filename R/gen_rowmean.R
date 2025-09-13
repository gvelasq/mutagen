#' Generate rowwise mean
#'
#' This function returns the rowwise arithmetic mean value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns A double vector of the rowwise arithmetic mean value. Missing values are ignored.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rowmean(a)
#' gen_rowmean(a, everything())
#' gen_rowmean(a, all_of(letters[25:26]))
#' b <- a %>% mutate(q = gen_rowmean(.))
#' b
#' @export
gen_rowmean <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_dbl(data, purrr::in_parallel(\(...) mean(c(...), na.rm = TRUE)))
  x
}
