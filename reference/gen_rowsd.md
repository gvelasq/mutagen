# Generate rowwise standard deviation

This function returns the rowwise standard deviation in a data frame.

## Usage

``` r
gen_rowsd(data, cols, na.rm = TRUE)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across. Non-numeric columns are ignored.

- na.rm:

  Logical vector of length one passed onto
  [[`stats::sd()`](https://rdrr.io/r/stats/sd.html)](https://rdrr.io/r/stats/sd.html).

## Value

A double vector of the rowwise standard deviation.

## Details

Parallelization is supported via
[[`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html)](https://purrr.tidyverse.org/reference/in_parallel.html).

If `na.rm` is `TRUE` (the default), missing values are removed. If
`na.rm` is `FALSE`, the presence of an `NA` or `NaN` in any row will
return `NA` for that row. As per the documentation for
[[`stats::sd()`](https://rdrr.io/r/stats/sd.html)](https://rdrr.io/r/stats/sd.html),
the standard deviation of a length one vector is `NA`.

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <- tibble(
  x = c(1, NA, 2),
  y = c(NA, 3, NA),
  z = c(4, NA, 5),
  aa = c("a", "b", "c"),
  bb = rep(NA, 3),
  cc = rep(NaN, 3)
)
gen_rowsd(a)
#> [1] 2.12132      NA 2.12132
gen_rowsd(a, all_of(letters[25:26]))
#> [1] NA NA NA
b <- a %>% mutate(q = gen_rowsd(.), r = gen_rowsd(., na.rm = FALSE))
b
#> # A tibble: 3 × 8
#>       x     y     z aa    bb       cc     q     r
#>   <dbl> <dbl> <dbl> <chr> <lgl> <dbl> <dbl> <dbl>
#> 1     1    NA     4 a     NA      NaN  2.12    NA
#> 2    NA     3    NA b     NA      NaN NA       NA
#> 3     2    NA     5 c     NA      NaN  2.12    NA
```
