#' Portinari color and fill scales for ggplot2
#'
#' Discrete or continuous color and fill scales built from a Portinari palette.
#' They are ordinary `ggplot2` scales and accept the usual arguments (`name`,
#' `labels`, `breaks`, `guide`, ...). Match the palette category to the data:
#' qualitative palettes for unordered groups, sequential palettes for ordered
#' values, and diverging palettes for values around a midpoint (see
#' [portinari.palettes()]).
#'
#' @param palette Name of the palette. See [portinari.palettes()].
#' @param type `"discrete"` (default) for categorical variables, or
#'   `"continuous"` for numeric variables.
#' @param direction `1` (default) or `-1` to reverse the palette.
#' @param colorblind If `TRUE`, only colorblind-safe colors are used.
#' @param ... Further arguments passed to [ggplot2::discrete_scale()] (discrete)
#'   or [ggplot2::scale_colour_gradientn()] / [ggplot2::scale_fill_gradientn()]
#'   (continuous).
#' @return A `ggplot2` scale object.
#' @seealso [portinari.pal()]
#' @name portinari_scales
#' @examples
#' library(ggplot2)
#' # Qualitative: unordered groups
#' ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_color_portinari("cafe", name = "Cylinders")
#'
#' # Sequential: ordered values
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_portinari("guerra_azul", type = "continuous", direction = -1)
#'
#' # Diverging: values around a midpoint
#' ggplot(mtcars, aes(wt, mpg, colour = mpg - mean(mpg))) +
#'   geom_point(size = 3) +
#'   scale_color_portinari("guerra", type = "continuous", name = "mpg vs mean")
#'
#' # Diverging, discrete: an ordered scale with a neutral middle
#' ggplot(mtcars, aes(factor(gear), fill = factor(carb))) +
#'   geom_bar() +
#'   scale_fill_portinari("retirantes")
NULL

#' @rdname portinari_scales
#' @export
scale_color_portinari <- function(palette = "cafe",
                                  type = c("discrete", "continuous"),
                                  direction = 1,
                                  colorblind = FALSE,
                                  ...) {
  type <- match.arg(type)
  portinari_scale("colour", palette, type, direction, colorblind, ...)
}

#' @rdname portinari_scales
#' @export
scale_colour_portinari <- scale_color_portinari

#' @rdname portinari_scales
#' @export
scale_fill_portinari <- function(palette = "cafe",
                                 type = c("discrete", "continuous"),
                                 direction = 1,
                                 colorblind = FALSE,
                                 ...) {
  type <- match.arg(type)
  portinari_scale("fill", palette, type, direction, colorblind, ...)
}

# Shared builder for the colour and fill scales.
portinari_scale <- function(aesthetic, palette, type, direction, colorblind, ...) {
  check_direction(direction)
  check_flag(colorblind, "colorblind")
  pal <- get_portinari_palette(palette)

  if (type == "continuous") {
    cols <- as.character(portinari.pal(palette, type = "discrete",
                                       direction = direction, colorblind = colorblind))
    if (aesthetic == "colour") {
      return(ggplot2::scale_colour_gradientn(colours = cols, ...))
    }
    return(ggplot2::scale_fill_gradientn(colours = cols, ...))
  }

  args <- list(
    aesthetics = aesthetic,
    palette = function(n) {
      available <- n_available(pal, colorblind)
      if (n > available) {
        warning(sprintf("Palette '%s' has %d colors; interpolating to %d.",
                        palette, available, n), call. = FALSE)
        return(as.character(portinari.pal(palette, n = n, type = "continuous",
                                          direction = direction, colorblind = colorblind)))
      }
      as.character(portinari.pal(palette, n = n, type = "discrete",
                                 direction = direction, colorblind = colorblind))
    },
    ...
  )
  # ggplot2 < 3.5.0 requires `scale_name`; later versions deprecate it.
  if (utils::packageVersion("ggplot2") < "3.5.0" && is.null(args$scale_name)) {
    args$scale_name <- "portinari"
  }
  do.call(ggplot2::discrete_scale, args)
}
