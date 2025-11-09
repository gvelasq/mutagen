#' Generate rowwise count of nonmissing values
#'
#' This function returns the rowwise count of nonmissing values in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns An integer vector of the rowwise count of nonmissing values.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rownonmiss(a)
#' gen_rownonmiss(a, all_of(letters[25:26]))
#' b <- a %>% mutate(q = gen_rownonmiss(.))
#' b
#' @export
gen_rownonmiss <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_int(data, purrr::in_parallel(\(...) sum(complete.cases(c(...)))))
  x
}
