# Tests for the proposed `terra_roxa` palette: purples from Coffee Agricultural
# Worker (shirt, cut tree stumps) and Mr. Queiroz Lima (suit), pale greens from
# the coffee rows and hills of Coffee Agricultural Worker.

terra_roxa <- c("#3A1F29", "#59384F", "#825B7C", "#AD87A4", "#CFD5C2",
                "#A0BB8D", "#678868", "#516441", "#333D29")

lab_of <- function(cols) {
  grDevices::convertColor(t(grDevices::col2rgb(cols)) / 255, from = "sRGB", to = "Lab")
}

test_that("terra_roxa is registered as a 9-color diverging palette", {
  info <- portinari.palettes()
  row <- info[info$palette == "terra_roxa", ]
  expect_equal(nrow(row), 1)
  expect_equal(row$category, "diverging")
  expect_equal(row$n_colors, 9L)
  expect_equal(as.character(portinari.pal("terra_roxa")), terra_roxa)
})

test_that("terra_roxa runs purple -> light center -> green", {
  lab <- lab_of(terra_roxa)
  center <- which.max(lab[, 1])
  expect_equal(center, 5L)
  # lightness rises along the purple arm and falls along the green arm
  expect_true(all(diff(lab[1:center, 1]) > 0))
  expect_true(all(diff(lab[center:9, 1]) < 0))
  # purple arm: a* > 0 and b* < 0 (magenta-violet); green arm: a* < 0
  expect_true(all(lab[1:4, 2] > 0))
  expect_true(all(lab[2:4, 3] < 0))
  expect_true(all(lab[6:9, 2] < 0))
})

test_that("terra_roxa discrete subsets are balanced around the center", {
  expect_equal(as.character(portinari.pal("terra_roxa", n = 2)), terra_roxa[c(1, 9)])
  expect_equal(as.character(portinari.pal("terra_roxa", n = 3)), terra_roxa[c(1, 5, 9)])
  five <- match(as.character(portinari.pal("terra_roxa", n = 5)), terra_roxa)
  expect_equal(sum(five < 5), sum(five > 5))
})

test_that("terra_roxa is colorblind-safe for all 9 colors", {
  expect_true(portinari.palettes()$colorblind_friendly[portinari.palettes()$palette == "terra_roxa"])
  chk <- portinari.cvd.check("terra_roxa")
  expect_true(all(chk$colorblind_safe))
  expect_gt(min(chk$normal), 14)
})

test_that("terra_roxa is distinct from every existing palette (merge rule)", {
  la <- lab_of(terra_roxa)
  for (p in setdiff(names(.portinari_palettes), "terra_roxa")) {
    lb <- lab_of(.portinari_palettes[[p]]$colors)
    d <- as.matrix(stats::dist(rbind(la, lb)))[seq_len(nrow(la)), nrow(la) + seq_len(nrow(lb))]
    similarity <- (mean(apply(d, 1, min)) + mean(apply(d, 2, min))) / 2
    expect_gt(similarity, 12, label = paste("distance to", p))
  }
})

test_that("terra_roxa works in ggplot2 scales", {
  p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = mpg - mean(mpg))) +
    ggplot2::geom_point() +
    scale_color_portinari("terra_roxa", type = "continuous")
  expect_no_error(ggplot2::ggplot_build(p))
  q <- ggplot2::ggplot(mtcars, ggplot2::aes(factor(carb), fill = factor(carb))) +
    ggplot2::geom_bar() +
    scale_fill_portinari("terra_roxa")
  expect_no_error(ggplot2::ggplot_build(q))
})
