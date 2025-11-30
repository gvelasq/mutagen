# Generate list or list-column with NULLs replaced with NAs

This function takes a list and replaces all `NULL` values with `NA`. It
is useful for working with list-columns in a data frame.

## Usage

``` r
gen_listcol_na(x)
```

## Arguments

- x:

  A list or list-column to modify.

## Value

A list with all `NULL` values replaced with `NA`.

## Details

Parallelization is supported via
[[`purrr::in_parallel()`](https://purrr.tidyverse.org/reference/in_parallel.html)](https://purrr.tidyverse.org/reference/in_parallel.html).

## Examples

``` r
library(dplyr, warn.conflicts = FALSE)
a <-
  mtcars %>%
  select(cyl, vs, am) %>%
  slice(1:6) %>%
  as_tibble() %>%
  mutate(listcol = list(NULL, "b", "c", "d", "e", "f"))
glimpse(a)
#> Rows: 6
#> Columns: 4
#> $ cyl     <dbl> 6, 6, 4, 6, 8, 6
#> $ vs      <dbl> 0, 0, 1, 1, 0, 1
#> $ am      <dbl> 1, 1, 1, 0, 0, 0
#> $ listcol <list> <NULL>, "b", "c", "d", "e", "f"
b <-
  a %>%
  mutate(across(starts_with("listcol"), gen_listcol_na))
glimpse(b)
#> Rows: 6
#> Columns: 4
#> $ cyl     <dbl> 6, 6, 4, 6, 8, 6
#> $ vs      <dbl> 0, 0, 1, 1, 0, 1
#> $ am      <dbl> 1, 1, 1, 0, 0, 0
#> $ listcol <list> NA, "b", "c", "d", "e", "f"
```
