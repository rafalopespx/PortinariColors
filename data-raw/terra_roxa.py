"""How the `terra_roxa` and `roxa_terra` palettes were made.

Unlike the other palettes, terra_roxa was sampled from the MASP image of
Coffee Agricultural Worker (MASP.00519): the deep plum of the shirt's folds,
the worker's mauve shirt, the violet cut tree stumps, the pale green coffee
rows and hills, and the off-white trousers (used as the light center).

`roxa_terra` is the sequential companion: the near-black soil at the bottom of
Coffee Agricultural Worker, the four plums of terra_roxa, then two tints and an end
on the pale citrine of Guerra (#DCE3AE, the lightest color of guerra_azul). The
tints are interpolated in CIELAB between the pale plum and that citrine, so
they are not sampled from the paintings.

Usage (image from data-raw/extract_masp_palettes.R or the MASP site):
    python3 terra_roxa.py WEB_JM_MASP_00519_01.jpg

The final colors are these cluster centres, plus the brightest tones of the
shirt (#AD87A4), trousers (#CFD5C2) and hills (#A0BB8D).

Requires: numpy, opencv-python. Regions are given on a copy of each image
resized to fit within 900 x 900 pixels.
"""
import sys
import cv2
import numpy as np

import palette_selection as ps

TERRA_ROXA = ["#35202E", "#59384F", "#825B7C", "#AD87A4", "#CFD5C2",
              "#A0BB8D", "#678868", "#516441", "#333D29"]
ROXA_TERRA = ["#0B0F13", "#35202E", "#59384F", "#825B7C", "#AD87A4",
              "#BEA5A8", "#CDC4AB", "#DCE3AE"]
GUERRA_CITRINE = "#DCE3AE"


def lab_to_hex(lab):
    L, a, b = lab
    fy = (L + 16) / 116
    f = np.array([fy + a / 500, fy, fy - b / 200])
    xyz = np.where(f ** 3 > 0.008856, f ** 3, (f - 16 / 116) / 7.787) * ps.WHITE
    lin = np.clip(np.linalg.inv(ps.RGB2XYZ) @ xyz, 0, 1)
    rgb = ps.lin_to_srgb(lin)
    return "#%02X%02X%02X" % tuple(int(round(v * 255)) for v in rgb)


def tints(start, end, k):
    """k colors evenly spaced in CIELAB strictly between start and end."""
    a, b = ps.labs([start])[0], ps.labs([end])[0]
    return [lab_to_hex(a + (b - a) * t) for t in np.linspace(0, 1, k + 2)[1:-1]]


def report_roxa_terra():
    cols = ROXA_TERRA
    assert cols[5:7] == tints("#AD87A4", GUERRA_CITRINE, 2)
    order = ps.spread_rank(len(cols))
    print("roxa_terra:", cols)
    print("order =", order, " cvd_n =", ps.cvd_n(cols, order))


def load(path):
    im = cv2.imread(path)
    s = 900 / max(im.shape[:2])
    im = cv2.resize(im, None, fx=s, fy=s, interpolation=cv2.INTER_AREA)
    return cv2.GaussianBlur(im, (5, 5), 0)


def sample(im, box, k, hue=None, sat=25):
    """k-means cluster centres (in CIELAB) of a region, darkest first."""
    x0, y0, x1, y1 = box
    crop = im[y0:y1, x0:x1]
    px = crop.reshape(-1, 3).astype(np.float32)
    lab = cv2.cvtColor(crop.astype(np.float32) / 255, cv2.COLOR_BGR2Lab).reshape(-1, 3)
    if hue:
        hsv = cv2.cvtColor(crop, cv2.COLOR_BGR2HSV).reshape(-1, 3)
        h = hsv[:, 0].astype(int) * 2
        keep = (h >= hue[0]) & (h <= hue[1]) & (hsv[:, 1] > sat)
        px, lab = px[keep], lab[keep]
    crit = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 50, 0.2)
    _, lbl, cent = cv2.kmeans(lab, k, None, crit, 5, cv2.KMEANS_PP_CENTERS)
    out = []
    for i in np.argsort(cent[:, 0]):
        c = np.median(px[lbl.ravel() == i], axis=0).astype(int)
        out.append("#%02X%02X%02X" % (c[2], c[1], c[0]))
    return out


def deep_plum(im, box=(250, 150, 520, 385), lightness=(12, 20)):
    """Median color of the darkest violet folds of the shirt."""
    x0, y0, x1, y1 = box
    crop = im[y0:y1, x0:x1]
    L = cv2.cvtColor(crop.astype(np.float32) / 255, cv2.COLOR_BGR2Lab)[..., 0].ravel()
    hsv = cv2.cvtColor(crop, cv2.COLOR_BGR2HSV).reshape(-1, 3)
    h = hsv[:, 0].astype(int) * 2
    keep = (h >= 260) & (h <= 345) & (hsv[:, 1] > 20) & (L >= lightness[0]) & (L <= lightness[1])
    c = np.median(crop.reshape(-1, 3)[keep], axis=0).astype(int)
    return "#%02X%02X%02X" % (c[2], c[1], c[0])


def main(coffee_path):
    coffee = load(coffee_path)
    print("shirt purples   ", sample(coffee, (250, 150, 520, 385), 5, (250, 340)))
    print("stump violets   ", sample(coffee, (550, 450, 705, 600), 4, (250, 350)))
    print("field greens    ", sample(coffee, (0, 262, 290, 365), 5, (60, 170)))
    print("hill greens     ", sample(coffee, (530, 212, 731, 310), 4, (60, 170)))
    print("trousers        ", sample(coffee, (280, 390, 500, 640), 4))
    print("shirt deep plum ", deep_plum(coffee))
    print("bottom soil     ", sample(coffee, (0, 700, 250, 880), 4))

    cols = TERRA_ROXA
    order = ps.diverging_rank(ps.labs(cols)[:, 0])
    print("\nterra_roxa:", cols)
    print("order =", order, " cvd_n =", ps.cvd_n(cols, order))
    report_roxa_terra()


if __name__ == "__main__":
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        cols = TERRA_ROXA
        order = ps.diverging_rank(ps.labs(cols)[:, 0])
        print("terra_roxa:", cols, "\norder =", order, " cvd_n =", ps.cvd_n(cols, order))
        report_roxa_terra()
