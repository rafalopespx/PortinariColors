# Tests for the proposed `roxa_terra` palette: a sequential ramp from the
# near-black soil at the bottom of Coffee Agricultural Worker, through the plums
# shared with terra_roxa, to two tints and the pale citrine of Guerra (the
# lightest color of guerra_azul).
# Like the other sequential palettes it is stored dark to light; use
# direction = -1 for light to dark.

roxa_terra <- c("#0B0F13", "#35202E", "#59384F", "#825B7C", "#AD87A4",
                "#BEA5A8", "#CDC4AB", "#DCE3AE")

lab_of <- function(cols) {
  grDevices::convertColor(t(grDevices::col2rgb(cols)) / 255, from = "sRGB", to = "Lab")
}

test_that("roxa_terra is registered as an 8-color sequential palette", {
  info <- portinari.palettes()
  row <- info[info$palette == "roxa_terra", ]
  expect_equal(nrow(row), 1)
  expect_equal(row$category, "sequential")
  expect_equal(row$n_colors, 8L)
  expect_equal(as.character(portinari.pal("roxa_terra")), roxa_terra)
})

test_that("roxa_terra runs from near-black soil to Guerra's citrine in even steps", {
  lab <- lab_of(roxa_terra)
  expect_true(all(diff(lab[, 1]) > 0))
  steps <- sqrt(rowSums(diff(lab)^2))
  expect_true(all(steps > 12))
  expect_lt(max(steps) / min(steps), 1.5)
  # near-neutral black at the dark end
  expect_lt(lab[1, 1], 8)
  # plum hue (a* > 0, b* < 0) in the sampled plums
  expect_true(all(lab[3:5, 2] > 0) && all(lab[3:5, 3] < 0))
  # the light end is the pale citrine of Guerra: light (so it contrasts with the
  # soil black) but not white (so it stays visible on a white page)
  guerra_azul <- as.character(portinari.pal("guerra_azul"))
  expect_equal(roxa_terra[8], guerra_azul[length(guerra_azul)])
  expect_gt(lab[8, 1], 85)
  expect_lt(lab[8, 1], 95)
  expect_gt(lab[8, 3], 0)
  expect_gt(sqrt(sum((lab[8, ] - lab[1, ])^2)), 80)
})

test_that("roxa_terra shares its plums with terra_roxa", {
  tr <- as.character(portinari.pal("terra_roxa"))
  expect_true(all(roxa_terra[2:5] %in% tr))
  expect_equal(roxa_terra[5], tr[4])   # the lightest plum of terra_roxa
})

test_that("roxa_terra discrete subsets keep both ends", {
  for (n in 2:8) {
    sub <- as.character(portinari.pal("roxa_terra", n = n))
    expect_equal(sub[c(1, n)], roxa_terra[c(1, 8)], info = n)
  }
  expect_equal(as.character(portinari.pal("roxa_terra", direction = -1)), rev(roxa_terra))
})

test_that("roxa_terra is colorblind-safe for all 8 colors", {
  info <- portinari.palettes()
  expect_true(info$colorblind_friendly[info$palette == "roxa_terra"])
  expect_true(all(portinari.cvd.check("roxa_terra")$colorblind_safe))
})

test_that("roxa_terra is distinct from every palette except its diverging parent", {
  # Like guerra_azul (from guerra) and paz_ouro (from paz), roxa_terra is a
  # sequential companion of terra_roxa and shares its plums on purpose, so the
  # merge rule does not apply between the two.
  la <- lab_of(roxa_terra)
  for (p in setdiff(names(.portinari_palettes), c("roxa_terra", "terra_roxa"))) {
    lb <- lab_of(.portinari_palettes[[p]]$colors)
    d <- as.matrix(stats::dist(rbind(la, lb)))[seq_len(nrow(la)), nrow(la) + seq_len(nrow(lb))]
    similarity <- (mean(apply(d, 1, min)) + mean(apply(d, 2, min))) / 2
    expect_gt(similarity, 12, label = paste("distance to", p))
  }
})

test_that("roxa_terra works in ggplot2 scales", {
  p <- ggplot2::ggplot(ggplot2::faithfuld, ggplot2::aes(waiting, eruptions, fill = density)) +
    ggplot2::geom_raster() +
    scale_fill_portinari("roxa_terra", type = "continuous")
  expect_no_error(ggplot2::ggplot_build(p))
  q <- ggplot2::ggplot(mtcars, ggplot2::aes(factor(cyl), fill = factor(gear))) +
    ggplot2::geom_bar() +
    scale_fill_portinari("roxa_terra")
  expect_no_error(ggplot2::ggplot_build(q))
})
