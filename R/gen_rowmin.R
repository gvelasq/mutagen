#' Generate rowwise minimum value
#'
#' This function returns the rowwise minimum value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns A vector of the rowwise minimum value.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rowmin(a)
#' gen_rowmin(a, everything())
#' gen_rowmin(a, starts_with(letters[25:26]))
#' b <- a %>% mutate(q = gen_rowmin(.))
#' b
#' @export
gen_rowmin <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- rlang::inject(pmin(!!!data, na.rm = TRUE))
  x
}
