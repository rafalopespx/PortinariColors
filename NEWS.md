# PortinariColors 0.4.0

## Breaking changes

* `retirantes` changes one color. Its light center is now `#D9CBB2`, the palest
  tone of *Northeastern Migrants*, instead of `#EFE9E0` (previously drawn from
  *Mr. Queiroz Lima*, which is no longer a reference work). Plots that use the
  center of `retirantes` will look slightly warmer and darker. The other seven
  colors, their order and colorblind safety are unchanged.

## New features

* New `theme_portinari()`, a complete `ggplot2` theme in the spirit of
  Portinari's canvases, with three moods: `"canvas"` (raw linen, umber ink,
  sienna contours), `"guerra"` (indigo ground, pale citrine ink) and `"paz"`
  (golden cream ground, brown ink). Options for grid lines and a painted
  frame; all text meets WCAG AA contrast.
* New diverging palette `terra_roxa`: the plum and mauve tones of the worker's
  shirt in *Coffee Agricultural Worker* against the pale greens of the coffee
  rows, through a sage off-white center. Its colors were sampled from the MASP
  image, and all nine are colorblind-safe.
* New sequential palette `roxa_terra`, the companion to `terra_roxa`: from the
  near-black soil at the bottom of *Coffee Agricultural Worker*, through the
  plums of `terra_roxa`, to the pale citrine of *Guerra*. All eight colors are
  colorblind-safe.

## Documentation

* The "Choosing a palette style" article shows `theme_portinari()`, a
  correlation heatmap with `terra_roxa` and an elevation map with
  `roxa_terra`; "The paintings" covers both new palettes.

# PortinariColors 0.3.0

* First CRAN release (2026-10-28).
* Discrete scales now work with ggplot2 < 3.5.0, which requires `scale_name`.

* Palettes now have a style, as in RColorBrewer and MetBrewer: qualitative
  (`cafe`, `paz`), diverging (`retirantes`, `inah`, `sofia`, `guerra`) and
  sequential (`guerra_azul`, `paz_ouro`). `portinari.palettes()` and
  `show_portinari()` gain a `category` filter.
* New sequential palettes `guerra_azul` and `paz_ouro`, derived from the UN
  panels.
* Palettes are stored MetBrewer-style: colors in display order plus an `order`
  ranking for discrete picks. Discrete subsets now suit the style: sequential
  and diverging palettes keep both ends (and the light center), qualitative
  palettes keep the most distinct colors. The colors returned for a given `n`
  have changed for every palette.
* `sofia` is now colorblind-safe for its first 3 colors (was 2).
* New `portinari.works()` lists the paintings behind each palette with links.
* Hex logo: a portrait of Portinari in the light shades of `guerra`.
* pkgdown site with two articles: "The paintings" (images and links for every
  reference work) and "Choosing a palette style".

# PortinariColors 0.2.0

* New palettes `guerra` (9 colors, all colorblind-safe) and `paz` (8 colors,
  first 4 colorblind-safe), from Portinari's *Guerra* and *Paz* panels at the
  United Nations Headquarters.
* Continuous palettes and scales now interpolate along a smooth `ramp` order
  stored with each palette, instead of the discrete priority order. Gradients
  for every palette are smoother as a result.

# PortinariColors 0.1.0

* First release: `portinari.pal()`, `scale_color_portinari()`,
  `scale_colour_portinari()`, `scale_fill_portinari()`, `portinari.palettes()`,
  `portinari.cvd.check()` and `show_portinari()`.
* Four palettes: `cafe`, `retirantes`, `inah`, `sofia`. Two are colorblind-safe
  for all colors, two for a subset.
