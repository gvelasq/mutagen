# Generate rowwise match of a set of values

This function performs a rowwise match of a set of supplied values
across columns in a data frame. If any of the row values equal one of
the supplied values, this function returns an integer 1 (`1L`) for that
row, otherwise it returns an integer 0 (`0L`).

## Usage

``` r
gen_rowany(data, cols, values)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

- values:

  A list of values to match.

## Value

A binary integer vector indicating whether any supplied value was
matched with an integer 1 (`1L`), otherwise it returns an integer 0
(`0L`).

## Details

Parallelization is supported via
[[`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html)](https://purrr.tidyverse.org/reference/in_parallel.html).

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <- tibble(
  x = 1:3,
  y = rep(NA, 3),
  z = letters[1:3],
  aa = rep(FALSE, 3)
)
val <- list(1, NA, "a", FALSE)
val2 <- list(5, NaN, "d", Inf)
gen_rowany(a, values = val)
#> [1] 1 1 1
b <- a %>%
  mutate(
    q = gen_rowany(., values = val),
    r = gen_rowany(., values = val2)
  )
b
#> # A tibble: 3 × 6
#>       x y     z     aa        q     r
#>   <int> <lgl> <chr> <lgl> <int> <int>
#> 1     1 NA    a     FALSE     1     0
#> 2     2 NA    b     FALSE     1     0
#> 3     3 NA    c     FALSE     1     0
```
