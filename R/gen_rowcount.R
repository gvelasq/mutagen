#' Rowwise count of the number of columns matching a set of values
#'
#' This function performs a rowwise count of columns in a data frame that match a set of supplied values.
#'
#' Parallelization is supported via [`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html).
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#' @param values A list of values to match.
#'
#' @returns An integer vector with the number of matched values.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = 1:3,
#'   y = rep(NA, 3),
#'   z = letters[1:3],
#'   aa = rep(FALSE, 3)
#' )
#' val <- list(1, NA, "a", FALSE)
#' gen_rowcount(a, values = val)
#' gen_rowcount(a, everything(), values = val)
#' gen_rowcount(a, starts_with(letters[25:26]), values = val)
#' b <- a %>% mutate(q = gen_rowcount(., values = val))
#' b
#' @export
gen_rowcount <- function(data, cols, values) {
  stopifnot("data must be a data frame" = is.data.frame(data))
  stopifnot("values must be a list" = is.list(values))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  x <- unlist(purrr::pmap(data, purrr::in_parallel(\(...) sum(list(...) %in% values), values = values)))
  x
}
