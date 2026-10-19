# WCAG 2 relative luminance and contrast ratio.
luminance <- function(col) {
  rgb <- grDevices::col2rgb(col)[, 1] / 255
  lin <- ifelse(rgb <= 0.03928, rgb / 12.92, ((rgb + 0.055) / 1.055)^2.4)
  sum(c(0.2126, 0.7152, 0.0722) * lin)
}
contrast <- function(a, b) {
  l <- sort(c(luminance(a), luminance(b)), decreasing = TRUE)
  (l[1] + 0.05) / (l[2] + 0.05)
}

test_that("theme_portinari() returns a complete ggplot2 theme", {
  th <- theme_portinari()
  expect_s3_class(th, "theme")
  expect_true(attr(th, "complete"))
})

test_that("every mood builds a plot and paints its own ground", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
  for (mood in names(.portinari_moods)) {
    th <- theme_portinari(mood)
    expect_no_error(ggplot2::ggplotGrob(p + th))
    expect_equal(th$plot.background$fill, .portinari_moods[[mood]]$paper, info = mood)
    expect_equal(th$text$colour, .portinari_moods[[mood]]$ink, info = mood)
  }
})

test_that("text in every mood meets WCAG AA contrast", {
  for (mood in names(.portinari_moods)) {
    m <- .portinari_moods[[mood]]
    expect_gte(contrast(m$ink, m$paper), 4.5, label = paste(mood, "ink"))
    expect_gte(contrast(m$muted, m$paper), 4.5, label = paste(mood, "muted text"))
    expect_gte(contrast(m$ink, m$wash), 4.5, label = paste(mood, "strip text"))
    # drawn lines are graphics, so the 3:1 non-text threshold applies
    expect_gte(contrast(m$line, m$paper), 3, label = paste(mood, "axis lines"))
  }
})

test_that("grid controls which major grid lines are drawn", {
  is_blank <- function(x) inherits(x, "element_blank")
  th <- theme_portinari(grid = "y")
  expect_true(is_blank(th$panel.grid.major.x))
  expect_false(is_blank(th$panel.grid.major.y))
  th <- theme_portinari(grid = "x")
  expect_false(is_blank(th$panel.grid.major.x))
  expect_true(is_blank(th$panel.grid.major.y))
  th <- theme_portinari(grid = "xy")
  expect_false(is_blank(th$panel.grid.major.x) || is_blank(th$panel.grid.major.y))
  th <- theme_portinari(grid = "none")
  expect_true(is_blank(th$panel.grid.major.x) && is_blank(th$panel.grid.major.y))
  expect_true(is_blank(th$panel.grid.minor))
})

test_that("frame draws or removes the painted border", {
  expect_equal(theme_portinari(frame = TRUE)$plot.background$colour, .portinari_moods$canvas$line)
  expect_true(is.na(theme_portinari(frame = FALSE)$plot.background$colour))
})

test_that("base_size scales the text", {
  expect_equal(theme_portinari(base_size = 14)$text$size, 14)
})

test_that("invalid arguments are rejected", {
  expect_error(theme_portinari("cubism"))
  expect_error(theme_portinari(grid = "diagonal"))
  expect_error(theme_portinari(frame = NA), "frame")
})

test_that("theme_portinari() combines with Portinari scales and facets", {
  p <- ggplot2::ggplot(ggplot2::mpg, ggplot2::aes(displ, hwy, colour = drv)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~year) +
    scale_color_portinari("paz") +
    ggplot2::labs(title = "t", subtitle = "s", caption = "c") +
    theme_portinari("guerra")
  expect_no_error(ggplot2::ggplotGrob(p))
})
