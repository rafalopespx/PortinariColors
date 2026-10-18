# Colour-vision simulation ------------------------------------------------------

# Machado, Oliveira & Fernandes (2009), severity 1.0, applied to linear sRGB.
machado_matrices <- list(
  protanopia = matrix(c(0.152286, 1.052583, -0.204868,
                        0.114503, 0.786281, 0.099216,
                        -0.003882, -0.048116, 1.051998), nrow = 3, byrow = TRUE),
  deuteranopia = matrix(c(0.367322, 0.860646, -0.227968,
                          0.280085, 0.672501, 0.047413,
                          -0.011820, 0.042940, 0.968881), nrow = 3, byrow = TRUE),
  tritanopia = matrix(c(1.255528, -0.076749, -0.178779,
                        -0.078411, 0.930809, 0.147602,
                        0.004733, 0.691367, 0.303900), nrow = 3, byrow = TRUE)
)

# sRGB (D65) -> XYZ, and the D65 reference white.
srgb_to_xyz_matrix <- matrix(c(0.4124, 0.3576, 0.1805,
                               0.2126, 0.7152, 0.0722,
                               0.0193, 0.1192, 0.9505), nrow = 3, byrow = TRUE)
d65_white <- c(0.95047, 1, 1.08883)

hex_to_srgb <- function(x) t(grDevices::col2rgb(x)) / 255

srgb_to_linear <- function(v) {
  ifelse(v <= 0.04045, v / 12.92, ((v + 0.055) / 1.055)^2.4)
}

linear_to_srgb <- function(v) {
  v <- pmin(pmax(v, 0), 1)
  ifelse(v <= 0.0031308, 12.92 * v, 1.055 * v^(1 / 2.4) - 0.055)
}

# Input: matrix with one row per color and columns R, G, B in [0, 1].
srgb_to_lab <- function(srgb) {
  srgb <- matrix(srgb, ncol = 3L)
  xyz <- srgb_to_linear(srgb) %*% t(srgb_to_xyz_matrix)
  xyz <- sweep(xyz, 2L, d65_white, "/")
  f <- ifelse(xyz > 0.008856, xyz^(1 / 3), 7.787 * xyz + 16 / 116)
  cbind(L = 116 * f[, 2] - 16, a = 500 * (f[, 1] - f[, 2]), b = 200 * (f[, 2] - f[, 3]))
}

simulate_cvd <- function(cols, kind) {
  lin <- srgb_to_linear(matrix(hex_to_srgb(cols), ncol = 3L))
  sim <- lin %*% t(machado_matrices[[kind]])
  srgb_to_lab(matrix(linear_to_srgb(sim), ncol = 3L))
}

min_pairwise_de <- function(lab) {
  min(stats::dist(lab))
}

#' Check colorblind safety of a Portinari palette
#'
#' Simulates protanopia, deuteranopia and tritanopia (Machado et al., 2009) and
#' measures the smallest CIELAB color difference (CIE76 dE) within the discrete
#' palette of `n` colors returned by [portinari.pal()], for every `n`. A
#' discrete palette of `n` colors is colorblind-safe when all three
#' simulations keep that minimum at or above `threshold`.
#'
#' @param palette Name of the palette. See [portinari.palettes()].
#' @param threshold Minimum acceptable dE. Default `10`.
#' @return A data frame with one row per palette size `n` (from 2 up to the
#'   palette length) and columns `normal`, `protanopia`, `deuteranopia` and
#'   `tritanopia` (minimum pairwise dE in each condition) and
#'   `colorblind_safe`.
#' @export
#' @examples
#' portinari.cvd.check("inah")
portinari.cvd.check <- function(palette = "cafe", threshold = 10) {
  pal <- get_portinari_palette(palette)
  n_seq <- seq.int(2L, length(pal$colors))
  subsets <- lapply(n_seq, function(k) discrete_colors(pal, k))
  out <- data.frame(n = n_seq)
  out$normal <- vapply(subsets, function(cols) {
    min_pairwise_de(srgb_to_lab(hex_to_srgb(cols)))
  }, numeric(1))
  for (kind in names(machado_matrices)) {
    out[[kind]] <- vapply(subsets, function(cols) {
      min_pairwise_de(simulate_cvd(cols, kind))
    }, numeric(1))
  }
  worst <- do.call(pmin, unname(as.list(out[names(machado_matrices)])))
  out$colorblind_safe <- worst >= threshold
  out
}
