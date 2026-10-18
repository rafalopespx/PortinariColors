#' Portinari color palette
#'
#' Returns a vector of hex colors from a Portinari palette.
#'
#' Palettes come in three categories (see [portinari.palettes()]):
#' *qualitative* palettes for unordered groups, *sequential* palettes for
#' ordered values, and *diverging* palettes for values around a meaningful
#' midpoint. Discrete palettes pick `n` colors that suit the category: the most
#' distinct colors for qualitative palettes, evenly spaced steps for sequential
#' palettes, and balanced steps either side of the light center for diverging
#' palettes. Continuous palettes interpolate the full palette in CIELAB space.
#'
#' @param palette Name of the palette. See [portinari.palettes()] for choices.
#' @param n Number of colors. Defaults to the length of the palette (or of its
#'   colorblind-safe subset when `colorblind = TRUE`).
#' @param type `"discrete"` returns distinct colors and errors when `n` is
#'   larger than the palette. `"continuous"` interpolates. When omitted, the
#'   type is chosen from `n`.
#' @param direction `1` (default) for the standard order, `-1` to reverse it.
#' @param colorblind If `TRUE`, only colors that remain distinguishable under
#'   protanopia, deuteranopia and tritanopia simulation are used. See
#'   [portinari.cvd.check()].
#' @return A character vector of hex colors with class `"portinari_palette"`.
#' @seealso [scale_color_portinari()], [scale_fill_portinari()],
#'   [portinari.palettes()]
#' @export
#' @examples
#' portinari.pal("cafe")
#' portinari.pal("retirantes", n = 3)
#' portinari.pal("guerra_azul", n = 20, type = "continuous")
#' portinari.pal("inah", colorblind = TRUE)
portinari.pal <- function(palette = "cafe",
                          n,
                          type = c("discrete", "continuous"),
                          direction = 1,
                          colorblind = FALSE) {
  auto_type <- missing(type)
  type <- match.arg(type)
  check_direction(direction)
  check_flag(colorblind, "colorblind")

  pal <- get_portinari_palette(palette)
  available <- n_available(pal, colorblind)
  if (missing(n)) n <- available
  n <- check_count(n)
  if (auto_type) type <- if (n <= available) "discrete" else "continuous"

  if (type == "discrete") {
    if (n > available) {
      stop(sprintf(
        "Palette '%s' has %d%s colors. Use type = \"continuous\" to interpolate to %d.",
        palette, available, if (colorblind) " colorblind-safe" else "", n
      ), call. = FALSE)
    }
    cols <- discrete_colors(pal, n)
  } else {
    cols <- interpolate_lab(discrete_colors(pal, available), n)
  }

  if (direction == -1) cols <- rev(cols)
  structure(cols, class = "portinari_palette", palette = palette)
}

#' @export
print.portinari_palette <- function(x, ...) {
  cat("<Portinari palette '", attr(x, "palette"), "'> ", length(x), " colors\n", sep = "")
  print(as.character(x))
  invisible(x)
}

#' List the available Portinari palettes
#'
#' @param category Optional filter: one or more of `"qualitative"`,
#'   `"diverging"` and `"sequential"`.
#' @return A data frame with one row per palette: its category, the number of
#'   colors, how many colors are colorblind-safe (`cvd_n`), whether the whole
#'   palette is colorblind-friendly, and a short description. See
#'   [portinari.works()] for the paintings behind each palette.
#' @export
#' @examples
#' portinari.palettes()
#' portinari.palettes("diverging")
portinari.palettes <- function(category = NULL) {
  check_category(category)
  pals <- .portinari_palettes
  out <- data.frame(
    palette = names(pals),
    category = unname(vapply(pals, function(p) p$category, character(1))),
    n_colors = unname(vapply(pals, function(p) length(p$colors), integer(1))),
    cvd_n = unname(vapply(pals, function(p) p$cvd_n, integer(1))),
    colorblind_friendly = unname(vapply(pals, function(p) p$cvd_n == length(p$colors), logical(1))),
    description = unname(vapply(pals, function(p) p$description, character(1))),
    stringsAsFactors = FALSE
  )
  if (!is.null(category)) out <- out[out$category %in% category, , drop = FALSE]
  rownames(out) <- NULL
  out
}
