"""How the `terra_roxa` palette was made.

Unlike the other palettes, terra_roxa was sampled from the MASP images:
  * Coffee Agricultural Worker (MASP.00519): the worker's mauve shirt, the
    violet cut tree stumps, the pale green coffee rows and hills, and the
    off-white trousers (used as the light center).
  * Mr. Queiroz Lima (MASP.00323): the deep plum suit.

Usage (images from data-raw/extract_masp_palettes.R or the MASP site):
    python3 terra_roxa.py WEB_JM_MASP_00519_01.jpg WEB_JM_MASP_00323_01.jpg

The final colors are these cluster centres, plus the brightest tones of the
shirt (#AD87A4), trousers (#CFD5C2) and hills (#A0BB8D).

Requires: numpy, opencv-python. Regions are given on a copy of each image
resized to fit within 900 x 900 pixels.
"""
import sys
import cv2
import numpy as np

import palette_selection as ps

TERRA_ROXA = ["#3A1F29", "#59384F", "#825B7C", "#AD87A4", "#CFD5C2",
              "#A0BB8D", "#678868", "#516441", "#333D29"]


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


def main(coffee_path, queiroz_path):
    coffee, queiroz = load(coffee_path), load(queiroz_path)
    print("shirt purples   ", sample(coffee, (250, 150, 520, 385), 5, (250, 340)))
    print("stump violets   ", sample(coffee, (550, 450, 705, 600), 4, (250, 350)))
    print("field greens    ", sample(coffee, (0, 262, 290, 365), 5, (60, 170)))
    print("hill greens     ", sample(coffee, (530, 212, 731, 310), 4, (60, 170)))
    print("trousers        ", sample(coffee, (280, 390, 500, 640), 4))
    print("suit purples    ", sample(queiroz, (0, 510, 741, 900), 5, (250, 350)))

    cols = TERRA_ROXA
    order = ps.diverging_rank(ps.labs(cols)[:, 0])
    print("\nterra_roxa:", cols)
    print("order =", order, " cvd_n =", ps.cvd_n(cols, order))


if __name__ == "__main__":
    if len(sys.argv) == 3:
        main(sys.argv[1], sys.argv[2])
    else:
        cols = TERRA_ROXA
        order = ps.diverging_rank(ps.labs(cols)[:, 0])
        print("terra_roxa:", cols, "\norder =", order, " cvd_n =", ps.cvd_n(cols, order))
