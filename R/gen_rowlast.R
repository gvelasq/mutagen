#' Generate rowwise last nonmissing value
#'
#' This function returns the rowwise last nonmissing value in a data frame.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#'
#' @returns A vector of the rowwise last nonmissing value. The vector's type will be of common type to all rowwise nonmissing values.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = c(1, NA, 2),
#'   y = c(NA, 3, NA),
#'   z = c(4, NA, 5)
#' )
#' gen_rowlast(a)
#' gen_rowlast(a, all_of(letters[24:25]))
#' b <- a %>% mutate(q = gen_rowlast(.))
#' b
#' c <-
#'   a %>%
#'   mutate(aa = c("a", TRUE, NA), .after = "z") %>%
#'   mutate(q = gen_rowlast(.))
#' c # note that q is of type <chr>
#' @export
gen_rowlast <- function(data, cols) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- purrr::pmap_vec(data, purrr::in_parallel(\(...) dplyr::last(c(...), na_rm = TRUE)))
  x
}
