# List the available Portinari palettes

List the available Portinari palettes

## Usage

``` r
portinari.palettes(category = NULL)
```

## Arguments

- category:

  Optional filter: one or more of `"qualitative"`, `"diverging"` and
  `"sequential"`.

## Value

A data frame with one row per palette: its category, the number of
colors, how many colors are colorblind-safe (`cvd_n`), whether the whole
palette is colorblind-friendly, and a short description. See
[`portinari.works()`](https://rafalopespx.github.io/PortinariColors/reference/portinari.works.md)
for the paintings behind each palette.

## Examples

``` r
portinari.palettes()
#>       palette    category n_colors cvd_n colorblind_friendly
#> 1        cafe qualitative        6     6                TRUE
#> 2         paz qualitative        8     4               FALSE
#> 3  retirantes   diverging        8     8                TRUE
#> 4        inah   diverging        5     4               FALSE
#> 5       sofia   diverging        5     3               FALSE
#> 6      guerra   diverging        9     9                TRUE
#> 7 guerra_azul  sequential        6     6                TRUE
#> 8    paz_ouro  sequential        4     4                TRUE
#>                                                                                                  description
#> 1                            Warm coffee-plantation tones: brick, ochre and cream, with a blue counterpoint.
#> 2                            Golden yellows of a 'golden age', with ochre, orange, rose, olive and sky blue.
#> 3               Cool slate to warm earth through cream: the dusty tones of the Migrant series and portraits.
#> 4                                                      Dusk blue and sage to blush and ochre, through cream.
#> 5                                                       Deep green and teal to gold and rose, through cream.
#> 6 A symphony in blue, from deep violet-indigo to pale citrine, against an orange, rose and red counterpoint.
#> 7                                              The blue scale of Guerra, from violet-indigo to pale citrine.
#> 8                                   The golden run of Paz, from earth brown through ochre and gold to cream.
portinari.palettes("diverging")
#>      palette  category n_colors cvd_n colorblind_friendly
#> 1 retirantes diverging        8     8                TRUE
#> 2       inah diverging        5     4               FALSE
#> 3      sofia diverging        5     3               FALSE
#> 4     guerra diverging        9     9                TRUE
#>                                                                                                  description
#> 1               Cool slate to warm earth through cream: the dusty tones of the Migrant series and portraits.
#> 2                                                      Dusk blue and sage to blush and ochre, through cream.
#> 3                                                       Deep green and teal to gold and rose, through cream.
#> 4 A symphony in blue, from deep violet-indigo to pale citrine, against an orange, rose and red counterpoint.
```
