# Portinari color palette

Returns a vector of hex colors from a Portinari palette.

## Usage

``` r
portinari.pal(
  palette = "cafe",
  n,
  type = c("discrete", "continuous"),
  direction = 1,
  colorblind = FALSE
)
```

## Arguments

- palette:

  Name of the palette. See
  [`portinari.palettes()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.palettes.md)
  for choices.

- n:

  Number of colors. Defaults to the length of the palette (or of its
  colorblind-safe subset when `colorblind = TRUE`).

- type:

  `"discrete"` returns distinct colors and errors when `n` is larger
  than the palette. `"continuous"` interpolates. When omitted, the type
  is chosen from `n`.

- direction:

  `1` (default) for the standard order, `-1` to reverse it.

- colorblind:

  If `TRUE`, only colors that remain distinguishable under protanopia,
  deuteranopia and tritanopia simulation are used. See
  [`portinari.cvd.check()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.cvd.check.md).

## Value

A character vector of hex colors with class `"portinari_palette"`.

## Details

Palettes come in three categories (see
[`portinari.palettes()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.palettes.md)):
*qualitative* palettes for unordered groups, *sequential* palettes for
ordered values, and *diverging* palettes for values around a meaningful
midpoint. Discrete palettes pick `n` colors that suit the category: the
most distinct colors for qualitative palettes, evenly spaced steps for
sequential palettes, and balanced steps either side of the light center
for diverging palettes. Continuous palettes interpolate the full palette
in CIELAB space.

## See also

[`scale_color_portinari()`](https://rafalopespx.github.io/PortinariColors/reference/portinari_scales.md),
[`scale_fill_portinari()`](https://rafalopespx.github.io/PortinariColors/reference/portinari_scales.md),
[`portinari.palettes()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.palettes.md)

## Examples

``` r
portinari.pal("cafe")
#> <Portinari palette 'cafe'> 6 colors
#> [1] "#2B4C7E" "#5B3B2A" "#6E7F4A" "#F3E2C0" "#E8B04B" "#B33A2A"
portinari.pal("retirantes", n = 3)
#> <Portinari palette 'retirantes'> 3 colors
#> [1] "#3F5670" "#EFE9E0" "#1F1B18"
portinari.pal("guerra_azul", n = 20, type = "continuous")
#> <Portinari palette 'guerra_azul'> 20 colors
#>  [1] "#2A1E4A" "#2B275B" "#2B306D" "#28397F" "#264290" "#2D4E9A" "#345BA4"
#>  [8] "#3B67AF" "#4B77B9" "#658DC2" "#7DA3CC" "#93BAD5" "#A1C6D6" "#A9CCD2"
#> [15] "#B0D1CD" "#B8D7C9" "#C1DAC3" "#CADDBC" "#D3E0B5" "#DCE3AE"
portinari.pal("inah", colorblind = TRUE)
#> <Portinari palette 'inah'> 4 colors
#> [1] "#2D3E56" "#A9B8A4" "#F1E6D6" "#C98F3D"
```
