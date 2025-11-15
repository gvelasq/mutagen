# Generate rowwise sum

This function returns the rowwise sum in a data frame.

## Usage

``` r
gen_rowsum(data, cols, na.rm = TRUE)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to sum. Non-numeric columns are ignored.

- na.rm:

  Logical vector of length one passed onto
  [[`base::sum()`](https://rdrr.io/r/base/sum.html)](https://rdrr.io/r/base/sum.html).

## Value

A vector of the rowwise sum. The vector's type will be of common type to
all rowwise numeric values.

## Details

Parallelization is supported via
[[`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html)](https://purrr.tidyverse.org/reference/in_parallel.html).

If `na.rm` is `TRUE` (the default), missing values are removed. If
`na.rm` is `FALSE`, the presence of an `NA` or `NaN` in any row will
return `NA` or `NaN` for that row.

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
gen_rowsum(a)
#> [1] 5 3 7
gen_rowsum(a, all_of(letters[25:26]))
#> [1] 4 3 5
b <- a %>% mutate(q = gen_rowsum(.), r = gen_rowsum(., na.rm = FALSE))
b
#> # A tibble: 3 × 8
#>       x     y     z aa    bb       cc     q     r
#>   <dbl> <dbl> <dbl> <chr> <lgl> <dbl> <dbl> <dbl>
#> 1     1    NA     4 a     NA      NaN     5    NA
#> 2    NA     3    NA b     NA      NaN     3    NA
#> 3     2    NA     5 c     NA      NaN     7    NA
```
