test_that("scale_color_portinari() returns discrete and continuous scales", {
  expect_s3_class(scale_color_portinari("cafe"), "ScaleDiscrete")
  expect_s3_class(scale_color_portinari("sofia", type = "continuous"), "ScaleContinuous")
})

test_that("scale_colour_portinari() is an alias of scale_color_portinari()", {
  expect_identical(scale_colour_portinari, scale_color_portinari)
})

test_that("scale_fill_portinari() returns a fill scale", {
  s <- scale_fill_portinari("retirantes")
  expect_s3_class(s, "ScaleDiscrete")
  expect_identical(s$aesthetics, "fill")
})

test_that("discrete color scale maps levels onto the palette in ggplot2", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(cyl))) +
    ggplot2::geom_point() +
    scale_color_portinari("cafe")
  built <- ggplot2::ggplot_build(p)
  used <- toupper(unique(built$data[[1]]$colour))
  expect_true(all(used %in% toupper(as.character(portinari.pal("cafe")))))
})

test_that("fill scale works in a bar chart", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(factor(gear), fill = factor(carb))) +
    ggplot2::geom_bar() +
    scale_fill_portinari("retirantes")
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("continuous scale builds with numeric data", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = hp)) +
    ggplot2::geom_point() +
    scale_color_portinari("sofia", type = "continuous")
  expect_no_error(ggplot2::ggplot_build(p))
})

test_that("continuous scale runs end to end through the palette", {
  s <- scale_fill_portinari("guerra", type = "continuous")
  full <- .portinari_palettes$guerra$colors
  expect_equal(toupper(s$palette(c(0, 1))), toupper(full[c(1, length(full))]))
})

test_that("too many discrete levels warns and interpolates", {
  skip_if_not_installed("ggplot2")
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = factor(carb))) +
    ggplot2::geom_point() +
    scale_color_portinari("inah")
  expect_warning(ggplot2::ggplot_build(p), "interpolating")
})
