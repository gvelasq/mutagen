#' Generate rowwise maximum value
#'
#' This function returns the rowwise maximum value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns A vector of the rowwise maximum value.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rowmax(a)
#' gen_rowmax(a, everything())
#' gen_rowmax(a, starts_with(letters[24:25]))
#' b <- a %>% mutate(q = gen_rowmax(.))
#' b
#' @export
gen_rowmax <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- rlang::inject(pmax(!!!data, na.rm = TRUE))
  x
}
