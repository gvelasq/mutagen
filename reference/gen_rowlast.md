# Generate rowwise last nonmissing value

This function returns the rowwise last nonmissing value in a data frame.

## Usage

``` r
gen_rowlast(data, cols)
```

## Arguments

- data:

  A data frame.

- cols:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Columns to search across.

## Value

A vector of the rowwise last nonmissing value. The vector's type will be
of common type to all rowwise nonmissing values.

## Details

Parallelization is supported via
[[`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html)](https://purrr.tidyverse.org/reference/in_parallel.html).

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <- tibble(
  x = c(1, NA, 2),
  y = c(NA, 3, NA),
  z = c(4, NA, 5)
)
gen_rowlast(a)
#> [1] 4 3 5
gen_rowlast(a, all_of(letters[24:25]))
#> [1] 1 3 2
b <- a %>% mutate(q = gen_rowlast(.))
b
#> # A tibble: 3 × 4
#>       x     y     z     q
#>   <dbl> <dbl> <dbl> <dbl>
#> 1     1    NA     4     4
#> 2    NA     3    NA     3
#> 3     2    NA     5     5
c <-
  a %>%
  mutate(aa = c("a", TRUE, NA), .after = "z") %>%
  mutate(q = gen_rowlast(.))
c # note that q is of type <chr>
#> # A tibble: 3 × 5
#>       x     y     z aa    q    
#>   <dbl> <dbl> <dbl> <chr> <chr>
#> 1     1    NA     4 a     a    
#> 2    NA     3    NA TRUE  TRUE 
#> 3     2    NA     5 NA    5    
```
