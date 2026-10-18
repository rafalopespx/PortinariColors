test_that("stored cvd_n agrees with the colour-vision simulation", {
  info <- portinari.palettes()
  for (p in info$palette) {
    cvd_n <- info$cvd_n[info$palette == p]
    chk <- portinari.cvd.check(p)
    if (cvd_n >= 2L) {
      expect_true(all(chk$colorblind_safe[chk$n <= cvd_n]), info = p)
    }
    if (cvd_n < info$n_colors[info$palette == p]) {
      expect_false(chk$colorblind_safe[chk$n == cvd_n + 1L], info = p)
    }
  }
})

test_that("portinari.cvd.check() returns the expected structure", {
  chk <- portinari.cvd.check("cafe")
  expect_named(chk, c("n", "normal", "protanopia", "deuteranopia", "tritanopia", "colorblind_safe"))
  expect_equal(chk$n, 2:6)
  expect_true(all(chk$normal > 0))
})
