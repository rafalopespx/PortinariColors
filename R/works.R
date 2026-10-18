# Reference works --------------------------------------------------------------

.portinari_works <- data.frame(
  palette = c("cafe", "cafe",
              "retirantes", "retirantes", "retirantes", "retirantes",
              "inah", "sofia", "guerra", "paz"),
  title = c("Coffee Agricultural Worker",
            "Saint Francis",
            "Northeastern Migrants, from the Migrant Series",
            "Dead Child, from the Migrant Series",
            "Bust of the Poet Felippe Daudt d'Oliveira, from the Portraits Series",
            "Mr. Queiroz Lima, from the Portraits Series",
            "Portrait of In\u00e1h Prudente de Moraes, from the Portraits Series",
            "Portrait of Sofia Cantalupo",
            "Guerra (War)",
            "Paz (Peace)"),
  year = c("1934", "1941", "1944", "1944", "1933", "1934", "1936", "1936",
           "1952\u20131956", "1952\u20131956"),
  collection = c(rep("MASP, S\u00e3o Paulo", 8),
                 rep("United Nations Headquarters, New York", 2)),
  inventory = c("MASP.00519", "MASP.00321", "MASP.00324", "MASP.00326",
                "MASP.00568", "MASP.00323", "MASP.01295", "MASP.01643",
                NA, NA),
  url = c("https://masp.org.br/en/collections/works/coffee-agricultural-worker",
          "https://masp.org.br/en/collections/works/saint-francis",
          "https://masp.org.br/en/collections/works/northeastern-migrants-from-the-migrant-series-1944-1945",
          "https://masp.org.br/en/collections/works/dead-child-from-the-migrant-series-1944-1945",
          "https://masp.org.br/en/collections/works/bust-of-the-poet-felippe-daudt-doliveira-from-the-portraits-series",
          "https://masp.org.br/en/collections/works/mr-queiroz-lima-from-the-portraits-series",
          "https://masp.org.br/en/collections/works/portrait-of-inah-prudente-de-moraes-from-the-portraits-series",
          "https://masp.org.br/en/collections/works/portrait-of-sofia-cantalupo",
          "https://artsandculture.google.com/story/war-1952-1956/IQLSaZmD0m7gIQ",
          "https://artsandculture.google.com/story/peace-1952-1956/PAKykLKUPJ4aKw"),
  image_url = c("https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00519_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00321_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_IFUSP_MASP_00324_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_IFUSP_MASP_00326_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00568_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_00323_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_JM_MASP_01295_01.jpg",
                "https://assets.masp.org.br/uploads/temp/WEB_JB_MASP_01643_01.jpg",
                NA, NA),
  stringsAsFactors = FALSE
)

#' Paintings behind the Portinari palettes
#'
#' The works each palette was drawn from, with links to the collection pages.
#' The sequential palettes `guerra_azul` and `paz_ouro` are derived from
#' `guerra` and `paz` and share their works.
#'
#' @param palette Optional character vector of palette names to filter by.
#' @return A data frame with columns `palette`, `title`, `year`, `collection`,
#'   `inventory`, `url` (collection or story page) and `image_url` (the
#'   museum's image, where one is published; `NA` otherwise).
#' @export
#' @examples
#' portinari.works()
#' portinari.works("retirantes")
portinari.works <- function(palette = NULL) {
  works <- .portinari_works
  if (is.null(palette)) return(works)
  for (p in palette) get_portinari_palette(p)
  source <- vapply(palette, function(p) sub("_(azul|ouro)$", "", p), character(1))
  works[works$palette %in% source, , drop = FALSE]
}
