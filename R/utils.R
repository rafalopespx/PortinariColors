# Internal helpers -------------------------------------------------------------

get_portinari_palette <- function(palette) {
  if (!is.character(palette) || length(palette) != 1L || is.na(palette)) {
    stop("`palette` must be a single palette name. See portinari.palettes().",
         call. = FALSE)
  }
  pal <- .portinari_palettes[[palette]]
  if (is.null(pal)) {
    stop(sprintf("Unknown palette '%s'. Available palettes: %s.",
                 palette, paste(names(.portinari_palettes), collapse = ", ")),
         call. = FALSE)
  }
  pal
}

# Number of colors available for discrete use.
n_available <- function(pal, colorblind = FALSE) {
  if (isTRUE(colorblind)) pal$cvd_n else length(pal$colors)
}

# The discrete subset of n colors, in display order.
discrete_colors <- function(pal, n) {
  pal$colors[pal$order <= n]
}

check_direction <- function(direction) {
  if (!(length(direction) == 1L && !is.na(direction) && direction %in% c(1, -1))) {
    stop("`direction` must be 1 (standard) or -1 (reversed).", call. = FALSE)
  }
  invisible(direction)
}

check_count <- function(n) {
  if (!is.numeric(n) || length(n) != 1L || is.na(n) || n < 1 || n != round(n)) {
    stop("`n` must be a single positive whole number.", call. = FALSE)
  }
  as.integer(n)
}

check_flag <- function(x, arg) {
  if (!is.logical(x) || length(x) != 1L || is.na(x)) {
    stop(sprintf("`%s` must be TRUE or FALSE.", arg), call. = FALSE)
  }
  invisible(x)
}

check_category <- function(category) {
  if (is.null(category)) return(invisible(NULL))
  bad <- setdiff(category, .portinari_categories)
  if (!is.character(category) || length(bad) > 0L) {
    stop(sprintf("`category` must be one or more of: %s.",
                 paste(.portinari_categories, collapse = ", ")), call. = FALSE)
  }
  invisible(category)
}

# Interpolate a palette to n colors, blending in CIELAB space so that the
# intermediate colors stay perceptually even.
interpolate_lab <- function(cols, n) {
  if (n == 1L) return(cols[1L])
  ramp <- grDevices::colorRamp(cols, space = "Lab")
  m <- ramp(seq(0, 1, length.out = n))
  grDevices::rgb(round(m[, 1]), round(m[, 2]), round(m[, 3]), maxColorValue = 255)
}
