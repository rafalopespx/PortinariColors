# Optional: sample dominant colors from the MASP originals.
#
# The palettes shipped in R/palettes.R are hand-estimated. Run this script on a
# machine with internet access to masp.org.br and assets.masp.org.br to get
# k-means cluster centres for each work, then curate them by hand and update
# the registry in R/palettes.R.
#
# Requires: install.packages("jpeg")

library(jpeg)

works <- c(
  "northeastern-migrants"      = "https://masp.org.br/en/collections/works/northeastern-migrants-from-the-migrant-series-1944-1945",
  "dead-child"                 = "https://masp.org.br/en/collections/works/dead-child-from-the-migrant-series-1944-1945",
  "saint-francis"              = "https://masp.org.br/en/collections/works/saint-francis",
  "portrait-of-inah-prudente-de-moraes" = "https://masp.org.br/en/collections/works/portrait-of-inah-prudente-de-moraes-from-the-portraits-series",
  "coffee-agricultural-worker" = "https://masp.org.br/en/collections/works/coffee-agricultural-worker",
  "mr-queiroz-lima"            = "https://masp.org.br/en/collections/works/mr-queiroz-lima-from-the-portraits-series",
  "bust-of-the-poet-felippe-daudt-doliveira" = "https://masp.org.br/en/collections/works/bust-of-the-poet-felippe-daudt-doliveira-from-the-portraits-series",
  "portrait-of-sofia-cantalupo" = "https://masp.org.br/en/collections/works/portrait-of-sofia-cantalupo"
)

# The first MASP asset image on each work page is taken as the main artwork.
find_image_url <- function(page_url) {
  tmp <- tempfile(fileext = ".html")
  download.file(page_url, tmp, quiet = TRUE, mode = "wb")
  html <- paste(readLines(tmp, warn = FALSE), collapse = "\n")
  pattern <- "https://assets\\.masp\\.org\\.br/uploads/temp/[^\"' ]+\\.jpg"
  regmatches(html, regexpr(pattern, html))[1]
}

sample_palette <- function(img_path, k = 8, n_pixels = 20000) {
  img <- readJPEG(img_path)
  px <- matrix(img[, , 1:3], ncol = 3)
  px <- px[sample(nrow(px), min(n_pixels, nrow(px))), , drop = FALSE]
  km <- kmeans(px, centers = k, nstart = 5, iter.max = 50)
  centres <- km$centers[order(-km$size), , drop = FALSE]
  rgb(centres[, 1], centres[, 2], centres[, 3])
}

results <- lapply(names(works), function(nm) {
  img_url <- find_image_url(works[[nm]])
  if (is.na(img_url) || !nzchar(img_url)) {
    warning("No image found for ", nm)
    return(NULL)
  }
  dest <- tempfile(fileext = ".jpg")
  download.file(img_url, dest, quiet = TRUE, mode = "wb")
  sample_palette(dest)
})
names(results) <- names(works)
print(results)
