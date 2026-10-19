# Theme ------------------------------------------------------------------------

# Colors of each mood. `ink` is the main text color, `muted` the secondary text,
# `line` the drawn axis lines and frame, `grid` the guide lines, `wash` the
# facet strips and legend keys.
.portinari_moods <- list(
  canvas = list(
    paper = "#F4ECDC", ink = "#3B2A20", muted = "#6A5444", line = "#8B5A3C",
    grid = "#DDCCAE", wash = "#E7D4AE"
  ),
  guerra = list(
    paper = "#2A1E4A", ink = "#DCE3AE", muted = "#B9D8C8", line = "#9CC3D9",
    grid = "#3D3468", wash = "#24408E"
  ),
  paz = list(
    paper = "#F4E6C2", ink = "#4E3119", muted = "#6B4425", line = "#A86E1C",
    grid = "#E3CC93", wash = "#E8C866"
  )
)

#' A ggplot2 theme in the spirit of Candido Portinari
#'
#' A complete `ggplot2` theme that dresses a plot like one of Portinari's
#' canvases: a warm ground of raw linen, firm drawn contours instead of a boxed
#' panel, earth-colored lettering and an optional painted frame. Two further
#' moods follow his United Nations panels: the deep indigo of *Guerra* and the
#' golden light of *Paz*. Pair it with [scale_color_portinari()] and
#' [scale_fill_portinari()].
#'
#' @param mood The overall look. `"canvas"` (default) is a raw-linen ground with
#'   umber ink and sienna contours; `"guerra"` is a dark indigo ground with pale
#'   citrine ink and light blue contours; `"paz"` is a golden cream ground with
#'   brown ink and deep ochre contours.
#' @param base_size Base font size, in points.
#' @param base_family Base font family.
#' @param grid Which major grid lines to draw: `"y"` (default), `"x"`, `"xy"` or
#'   `"none"`.
#' @param frame If `TRUE` (default), draws a thin painted frame around the
#'   whole plot, like the edge of a stretched canvas.
#' @section Pairing palettes with a mood:
#' The light moods share their ground with the lightest colors of several
#' palettes (the creams of `cafe` and `paz`, the light centers of the diverging
#' palettes, the pale ends of the sequential ones). That is natural for filled
#' areas such as heatmaps, where the center then reads as neutral, but those
#' colors fade when used for points or lines. The `guerra` mood uses the indigo
#' that starts `guerra` and `guerra_azul`, so pair it with other palettes, for
#' example `paz` or `sofia`: the ground of War with the colors of Peace.
#'
#' @return A `ggplot2` theme object.
#' @seealso [scale_color_portinari()], [scale_fill_portinari()]
#' @export
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_color_portinari("paz", name = "Cylinders") +
#'   labs(title = "Fuel economy", subtitle = "Heavier cars travel less per gallon") +
#'   theme_portinari()
#'
#' ggplot(mpg, aes(class, fill = drv)) +
#'   geom_bar() +
#'   scale_fill_portinari("sofia") +
#'   theme_portinari("guerra")
#'
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_portinari("roxa_terra", type = "continuous", direction = -1) +
#'   theme_portinari("paz", grid = "none", frame = FALSE)
theme_portinari <- function(mood = c("canvas", "guerra", "paz"),
                            base_size = 11,
                            base_family = "",
                            grid = c("y", "x", "xy", "none"),
                            frame = TRUE) {
  mood <- match.arg(mood)
  grid <- match.arg(grid)
  check_flag(frame, "frame")
  m <- .portinari_moods[[mood]]
  half <- base_size / 2

  grid_line <- ggplot2::element_line(colour = m$grid, linewidth = 0.35)
  blank <- ggplot2::element_blank()

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) %+replace%
    ggplot2::theme(
      line = ggplot2::element_line(colour = m$line, linewidth = 0.5, linetype = 1, lineend = "round"),
      rect = ggplot2::element_rect(fill = m$paper, colour = NA, linewidth = 0.5, linetype = 1),
      text = ggplot2::element_text(family = base_family, face = "plain", colour = m$ink,
                                   size = base_size, lineheight = 0.95, hjust = 0.5,
                                   vjust = 0.5, angle = 0, margin = ggplot2::margin(),
                                   debug = FALSE),

      plot.background = ggplot2::element_rect(
        fill = m$paper,
        colour = if (frame) m$line else NA,
        linewidth = if (frame) 1.4 else 0
      ),
      plot.margin = ggplot2::margin(base_size, base_size * 1.2, half, base_size),
      plot.title = ggplot2::element_text(face = "bold", size = ggplot2::rel(1.45), hjust = 0,
                                         vjust = 1, margin = ggplot2::margin(b = half * 0.8)),
      plot.subtitle = ggplot2::element_text(colour = m$muted, size = ggplot2::rel(1.0), hjust = 0,
                                            vjust = 1, margin = ggplot2::margin(b = base_size)),
      plot.caption = ggplot2::element_text(colour = m$muted, face = "italic", size = ggplot2::rel(0.8),
                                           hjust = 1, vjust = 1, margin = ggplot2::margin(t = half)),
      plot.title.position = "plot",
      plot.caption.position = "plot",

      panel.background = ggplot2::element_rect(fill = m$paper, colour = NA),
      panel.border = blank,
      panel.grid = blank,
      panel.grid.major.x = if (grid %in% c("x", "xy")) grid_line else blank,
      panel.grid.major.y = if (grid %in% c("y", "xy")) grid_line else blank,
      panel.grid.minor = blank,
      panel.spacing = ggplot2::unit(base_size, "pt"),

      axis.line = ggplot2::element_line(colour = m$line, linewidth = 0.7),
      axis.ticks = ggplot2::element_line(colour = m$line, linewidth = 0.5),
      axis.ticks.length = ggplot2::unit(half * 0.7, "pt"),
      axis.text = ggplot2::element_text(colour = m$muted, size = ggplot2::rel(0.85)),
      axis.text.x = ggplot2::element_text(margin = ggplot2::margin(t = half * 0.6), vjust = 1),
      axis.text.y = ggplot2::element_text(margin = ggplot2::margin(r = half * 0.6), hjust = 1),
      axis.title = ggplot2::element_text(colour = m$ink, size = ggplot2::rel(0.95)),
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = half), vjust = 1),
      axis.title.y = ggplot2::element_text(angle = 90, margin = ggplot2::margin(r = half), vjust = 1),

      legend.background = ggplot2::element_rect(fill = m$paper, colour = NA),
      legend.key = ggplot2::element_rect(fill = m$paper, colour = NA),
      legend.title = ggplot2::element_text(face = "bold", size = ggplot2::rel(0.9), hjust = 0),
      legend.text = ggplot2::element_text(colour = m$muted, size = ggplot2::rel(0.85)),
      legend.position = "right",

      strip.background = ggplot2::element_rect(fill = m$wash, colour = NA),
      strip.text = ggplot2::element_text(colour = m$ink, face = "bold", size = ggplot2::rel(0.9),
                                         margin = ggplot2::margin(half * 0.6, half, half * 0.6, half)),

      complete = TRUE
    )
}
