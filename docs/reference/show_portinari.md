# Show Portinari palettes

Draws each palette as a row of color swatches using base graphics,
labelled with its category.

## Usage

``` r
show_portinari(palette = NULL, category = NULL)
```

## Arguments

- palette:

  Character vector of palette names. Defaults to all palettes (or all
  palettes in `category`).

- category:

  Optional filter: one or more of `"qualitative"`, `"diverging"` and
  `"sequential"`.

## Value

The palette names, invisibly.

## Examples

``` r
show_portinari()

show_portinari(category = "diverging")

show_portinari(c("cafe", "inah"))
```
