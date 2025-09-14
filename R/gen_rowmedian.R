#' Generate rowwise median
#'
#' This function returns the rowwise median value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns A double vector of the rowwise median value. Missing values are ignored.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(2, 3, 2),
#'   z = c(4, NA, 5)
#' )
#' gen_rowmedian(a)
#' gen_rowmedian(a, everything())
#' gen_rowmedian(a, all_of(letters[25:26]))
#' b <- a %>% mutate(q = gen_rowmedian(.))
#' b
#' @export
gen_rowmedian <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_dbl(data, purrr::in_parallel(\(...) median(c(...), na.rm = TRUE)))
  x
}
