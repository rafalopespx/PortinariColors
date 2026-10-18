# Palette registry -------------------------------------------------------------
#
# The layout follows MetBrewer:
#
# `colors`   the palette in display order. This is also the order used for
#            continuous palettes and scales, so it is always a smooth path:
#            sorted by lightness for sequential palettes, dark-light-dark for
#            diverging palettes (cool arm first), and the shortest path
#            through CIELAB for qualitative palettes.
# `order`    rank of each color for discrete use. portinari.pal(name, n)
#            returns the colors with rank <= n, in display order. Qualitative
#            palettes rank the most distinct colors first. Sequential palettes
#            take both ends, then fill evenly. Diverging palettes take both
#            ends, then the light center, then fill the two arms evenly.
# `category` "qualitative", "diverging" or "sequential".
# `cvd_n`    the largest n for which every discrete subset of 2..n colors
#            keeps a CIE76 dE of at least 10 under protanopia, deuteranopia
#            and tritanopia simulation (see portinari.cvd.check()).
#
# IMPORTANT: the hex values are hand-estimated from the dominant tones of each
# work and were NOT sampled from images. guerra and paz follow published
# descriptions of the UN panels' colors (Google Arts & Culture, Projeto
# Portinari). data-raw/palette_selection.py reproduces every value here.
.portinari_palettes <- list(
  cafe = list(
    colors = c("#2B4C7E", "#5B3B2A", "#6E7F4A", "#F3E2C0", "#E8B04B", "#B33A2A"),
    order = c(2L, 4L, 6L, 3L, 5L, 1L),
    category = "qualitative",
    cvd_n = 6L,
    description = "Warm coffee-plantation tones: brick, ochre and cream, with a blue counterpoint."
  ),
  paz = list(
    colors = c("#6B4425", "#7E9A4E", "#E8B931", "#C98A2B", "#E2763A", "#E59A8F", "#F4E6C2", "#8FB8CF"),
    order = c(3L, 4L, 1L, 8L, 5L, 7L, 6L, 2L),
    category = "qualitative",
    cvd_n = 4L,
    description = "Golden yellows of a 'golden age', with ochre, orange, rose, olive and sky blue."
  ),
  retirantes = list(
    colors = c("#3F5670", "#6F7C86", "#A69F94", "#EFE9E0", "#C9A36A", "#8B5A3C", "#5E5751", "#1F1B18"),
    order = c(1L, 5L, 6L, 3L, 7L, 4L, 8L, 2L),
    category = "diverging",
    cvd_n = 8L,
    description = "Cool slate to warm earth through cream: the dusty tones of the Migrant series and portraits."
  ),
  inah = list(
    colors = c("#2D3E56", "#A9B8A4", "#F1E6D6", "#E8B9A0", "#C98F3D"),
    order = c(1L, 4L, 3L, 5L, 2L),
    category = "diverging",
    cvd_n = 4L,
    description = "Dusk blue and sage to blush and ochre, through cream."
  ),
  sofia = list(
    colors = c("#2F5E46", "#2E8B8B", "#F2E8DC", "#E0B04A", "#D96B7A"),
    order = c(1L, 4L, 3L, 5L, 2L),
    category = "diverging",
    cvd_n = 3L,
    description = "Deep green and teal to gold and rose, through cream."
  ),
  guerra = list(
    colors = c("#2A1E4A", "#24408E", "#3F6FB5", "#9CC3D9", "#B9D8C8", "#DCE3AE", "#E07A3A", "#D9748A", "#A8352E"),
    order = c(1L, 7L, 4L, 8L, 9L, 3L, 5L, 6L, 2L),
    category = "diverging",
    cvd_n = 9L,
    description = "A symphony in blue, from deep violet-indigo to pale citrine, against an orange, rose and red counterpoint."
  ),
  guerra_azul = list(
    colors = c("#2A1E4A", "#24408E", "#3F6FB5", "#9CC3D9", "#B9D8C8", "#DCE3AE"),
    order = c(1L, 5L, 3L, 4L, 6L, 2L),
    category = "sequential",
    cvd_n = 6L,
    description = "The blue scale of Guerra, from violet-indigo to pale citrine."
  ),
  paz_ouro = list(
    colors = c("#6B4425", "#C98A2B", "#E8B931", "#F4E6C2"),
    order = c(1L, 3L, 4L, 2L),
    category = "sequential",
    cvd_n = 4L,
    description = "The golden run of Paz, from earth brown through ochre and gold to cream."
  )
)

.portinari_categories <- c("qualitative", "diverging", "sequential")
