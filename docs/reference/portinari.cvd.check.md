# Check colorblind safety of a Portinari palette

Simulates protanopia, deuteranopia and tritanopia (Machado et al., 2009)
and measures the smallest CIELAB color difference (CIE76 dE) within the
discrete palette of `n` colors returned by
[`portinari.pal()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.pal.md),
for every `n`. A discrete palette of `n` colors is colorblind-safe when
all three simulations keep that minimum at or above `threshold`.

## Usage

``` r
portinari.cvd.check(palette = "cafe", threshold = 10)
```

## Arguments

- palette:

  Name of the palette. See
  [`portinari.palettes()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.palettes.md).

- threshold:

  Minimum acceptable dE. Default `10`.

## Value

A data frame with one row per palette size `n` (from 2 up to the palette
length) and columns `normal`, `protanopia`, `deuteranopia` and
`tritanopia` (minimum pairwise dE in each condition) and
`colorblind_safe`.

## Examples

``` r
portinari.cvd.check("inah")
#>   n   normal protanopia deuteranopia tritanopia colorblind_safe
#> 1 2 78.44455  74.497104     79.83796   63.96138            TRUE
#> 2 3 51.90594  51.943710     49.56295   42.11120            TRUE
#> 3 4 21.14068  17.750296     19.24980   22.25938            TRUE
#> 4 5 20.58140   7.710626     14.77495   19.39388           FALSE
```
