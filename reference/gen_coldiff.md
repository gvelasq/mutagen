# Generate column difference indicator

This function returns a binary indicator of whether any selected columns
are different.

## Usage

``` r
gen_coldiff(data, cols, engine = "identical", ...)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

- engine:

  A character vector indicating the function used to test for equality.
  One of either "identical" for
  [[`base::identical()`](https://rdrr.io/r/base/identical.html)](https://rdrr.io/r/base/identical.html)
  or "all.equal" for
  [[`base::all.equal()`](https://rdrr.io/r/base/all.equal.html)](https://rdrr.io/r/base/all.equal.html).

- ...:

  Arguments passed onto the function defined in `engine`. For example,
  the `tolerance` argument can be passed onto
  [`base::all.equal()`](https://rdrr.io/r/base/all.equal.html) to ignore
  numeric differences smaller than `tolerance`.

## Value

An integer vector of value integer 1 (`1L`) for different columns or an
integer 0 (`0L`) for identical (or near-equal) columns.

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <- tibble(
  x = 1:3,
  y = as.double(1:3),
  z = 1.0001:3.0001
)
gen_coldiff(a, c(x, y))
#> [1] 1 1 1
b <- a %>%
  mutate(
    q = gen_coldiff(., c(x, y)),
    r = gen_coldiff(., c(x, y), engine = "all.equal"),
    s = gen_coldiff(., c(x, z), engine = "all.equal", tolerance = 1e-4),
    t = gen_coldiff(., c(x, z), engine = "all.equal", tolerance = 1e-5)
  )
b
#> # A tibble: 3 × 7
#>       x     y     z     q     r     s     t
#>   <int> <dbl> <dbl> <int> <int> <int> <int>
#> 1     1     1  1.00     1     0     0     1
#> 2     2     2  2.00     1     0     0     1
#> 3     3     3  3.00     1     0     0     1
```
