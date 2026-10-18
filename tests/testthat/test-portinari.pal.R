hex_pattern <- "^#[0-9A-Fa-f]{6}$"
pal_names <- names(.portinari_palettes)

test_that("every palette is well-formed", {
  for (p in pal_names) {
    pal <- .portinari_palettes[[p]]
    expect_true(all(grepl(hex_pattern, pal$colors)), info = p)
    expect_setequal(pal$order, seq_along(pal$colors))
    expect_true(pal$category %in% .portinari_categories, info = p)
    expect_true(pal$cvd_n >= 1L && pal$cvd_n <= length(pal$colors), info = p)
  }
})

test_that("the full discrete palette is the palette in display order", {
  for (p in pal_names) {
    cols <- portinari.pal(p)
    expect_s3_class(cols, "portinari_palette")
    expect_equal(as.character(cols), .portinari_palettes[[p]]$colors, info = p)
  }
})

test_that("discrete subsets are nested and keep display order", {
  for (p in pal_names) {
    full <- .portinari_palettes[[p]]$colors
    for (n in seq_along(full)) {
      sub <- as.character(portinari.pal(p, n = n))
      expect_length(sub, n)
      expect_true(all(diff(match(sub, full)) > 0), info = paste(p, n))
      if (n > 1) expect_true(all(as.character(portinari.pal(p, n = n - 1)) %in% sub))
    }
  }
})

test_that("sequential and diverging palettes keep their ends at n = 2", {
  for (p in portinari.palettes(c("sequential", "diverging"))$palette) {
    full <- .portinari_palettes[[p]]$colors
    expect_equal(as.character(portinari.pal(p, n = 2)), full[c(1, length(full))], info = p)
  }
})

test_that("diverging palettes include the light centre at n = 3", {
  for (p in portinari.palettes("diverging")$palette) {
    full <- .portinari_palettes[[p]]$colors
    lightness <- grDevices::convertColor(t(grDevices::col2rgb(full)) / 255,
                                         from = "sRGB", to = "Lab")[, 1]
    expect_true(full[which.max(lightness)] %in% portinari.pal(p, n = 3), info = p)
  }
})

test_that("sequential palettes are ordered by lightness", {
  for (p in portinari.palettes("sequential")$palette) {
    full <- .portinari_palettes[[p]]$colors
    lightness <- grDevices::convertColor(t(grDevices::col2rgb(full)) / 255,
                                         from = "sRGB", to = "Lab")[, 1]
    expect_true(all(diff(lightness) > 0), info = p)
  }
})

test_that("requesting more discrete colors than available errors clearly", {
  expect_error(portinari.pal("inah", n = 9, type = "discrete"), "continuous")
})

test_that("continuous palettes interpolate from end to end", {
  cols <- portinari.pal("guerra_azul", n = 20, type = "continuous")
  full <- .portinari_palettes$guerra_azul$colors
  expect_length(cols, 20)
  expect_true(all(grepl(hex_pattern, cols)))
  expect_equal(toupper(cols[c(1, 20)]), toupper(full[c(1, length(full))]))
})

test_that("type is chosen automatically from n", {
  expect_length(portinari.pal("cafe", n = 3), 3)
  expect_length(portinari.pal("cafe", n = 30), 30)
})

test_that("direction = -1 reverses the palette", {
  expect_equal(as.character(portinari.pal("cafe", direction = -1)),
               rev(as.character(portinari.pal("cafe"))))
})

test_that("colorblind = TRUE keeps only the colorblind-safe colors", {
  info <- portinari.palettes()
  for (p in info$palette) {
    expect_length(portinari.pal(p, colorblind = TRUE), info$cvd_n[info$palette == p])
  }
  expect_error(portinari.pal("sofia", n = 4, colorblind = TRUE, type = "discrete"),
               "colorblind-safe")
})

test_that("invalid inputs are rejected", {
  expect_error(portinari.pal("not-a-palette"), "Unknown palette")
  expect_error(portinari.pal("cafe", direction = 2), "direction")
  expect_error(portinari.pal("cafe", n = 0), "positive")
  expect_error(portinari.palettes("rainbow"), "category")
})

test_that("portinari.palettes() describes and filters palettes", {
  info <- portinari.palettes()
  expect_setequal(info$palette, pal_names)
  expect_true(all(info$cvd_n <= info$n_colors))
  expect_equal(info$colorblind_friendly, info$cvd_n == info$n_colors)
  expect_setequal(unique(info$category), .portinari_categories)
  expect_true(all(portinari.palettes("sequential")$category == "sequential"))
})

test_that("portinari.works() covers every palette", {
  works <- portinari.works()
  for (p in pal_names) expect_gt(nrow(portinari.works(p)), 0)
  expect_true(all(grepl("^https://", works$url)))
  expect_equal(portinari.works("guerra_azul")$title, portinari.works("guerra")$title)
})
