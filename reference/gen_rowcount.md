# Generate rowwise count of columns matching a set of values

This function performs a rowwise count of columns in a data frame that
match a set of supplied values.

## Usage

``` r
gen_rowcount(data, cols, values)
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

An integer vector with the number of matched values.

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
gen_rowcount(a, values = val)
#> [1] 4 2 2
gen_rowcount(a, everything(), values = val)
#> [1] 4 2 2
gen_rowcount(a, starts_with(letters[25:26]), values = val)
#> [1] 2 1 1
b <- a %>% mutate(q = gen_rowcount(., values = val))
b
#> # A tibble: 3 × 5
#>       x y     z     aa        q
#>   <int> <lgl> <chr> <lgl> <int>
#> 1     1 NA    a     FALSE     4
#> 2     2 NA    b     FALSE     2
#> 3     3 NA    c     FALSE     2
```
