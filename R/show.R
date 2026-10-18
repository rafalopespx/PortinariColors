#' Show Portinari palettes
#'
#' Draws each palette as a row of color swatches using base graphics, labeled
#' with its category.
#'
#' @param palette Character vector of palette names. Defaults to all palettes
#'   (or all palettes in `category`).
#' @param category Optional filter: one or more of `"qualitative"`,
#'   `"diverging"` and `"sequential"`.
#' @return The palette names, invisibly.
#' @export
#' @examples
#' show_portinari()
#' show_portinari(category = "diverging")
#' show_portinari(c("cafe", "inah"))
show_portinari <- function(palette = NULL, category = NULL) {
  info <- portinari.palettes(category)
  if (is.null(palette)) palette <- info$palette
  for (p in palette) get_portinari_palette(p)
  if (length(palette) == 0L) stop("No palettes match.", call. = FALSE)

  old <- graphics::par(mfrow = c(length(palette), 1L), mar = c(0.5, 10, 0.5, 0.5))
  on.exit(graphics::par(old), add = TRUE)
  for (p in palette) {
    cols <- as.character(portinari.pal(p))
    graphics::image(seq_along(cols), 1, matrix(seq_along(cols), ncol = 1L),
                    col = cols, axes = FALSE, xlab = "", ylab = "")
    graphics::mtext(sprintf("%s\n(%s)", p, .portinari_palettes[[p]]$category),
                    side = 2, las = 1, line = 0.5, cex = 0.8)
  }
  invisible(palette)
}
