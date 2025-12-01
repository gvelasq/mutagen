#' Generate column difference indicator
#'
#' This function returns a binary indicator of whether any selected columns are different.
#'
#' @param data A data frame.
#' @param cols <[`tidy-select`][dplyr::dplyr_tidy_select]> Columns to search across.
#' @param engine A character vector indicating the function used to test for equality. One of either "identical" for [`base::identical()`](https://rdrr.io/r/base/identical.html) or "all.equal" for [`base::all.equal()`](https://rdrr.io/r/base/all.equal.html).
#' @param ... Arguments passed onto the function defined in `engine`. For example, the `tolerance` argument can be passed onto `base::all.equal()` to ignore numeric differences smaller than `tolerance`.
#'
#' @returns An integer vector of value integer 1 (`1L`) for different columns or an integer 0 (`0L`) for identical (or near-equal) columns.
#'
#' @examples
#' library(dplyr, warn.conflicts = FALSE)
#' a <- tibble(
#'   x = 1:3,
#'   y = as.double(1:3),
#'   z = 1.0001:3.0001
#' )
#' gen_coldiff(a, c(x, y))
#' b <- a %>%
#'   mutate(
#'     q = gen_coldiff(., c(x, y)),
#'     r = gen_coldiff(., c(x, y), engine = "all.equal"),
#'     s = gen_coldiff(., c(x, z), engine = "all.equal", tolerance = 1e-4),
#'     t = gen_coldiff(., c(x, z), engine = "all.equal", tolerance = 1e-5)
#'   )
#' b
#' @export
gen_coldiff <- function(data, cols, engine = "identical", ...) {
  stopifnot("`data` argument must be a data frame" = is.data.frame(data))
  if (!missing(cols)) {
    data <- dplyr::select(data, {{ cols }})
  }
  stopifnot("at least two columns must be selected" = ncol(data) >= 2)
  engine <- match.arg(engine, c("identical", "all.equal"))
  if (identical(engine, "all.equal")) {
    engine <- "is_true_all_equal"
  }
  out <- integer(nrow(data))
  for (i in seq_along(data)[-1]) {
    if (!get(engine)(data[[1]], data[[i]], ...)) {
      out <- out + 1L
      return(out)
    }
  }
  out
}

is_true_all_equal <- function(x, y, ...) {
  isTRUE(all.equal(x, y, ...))
}
