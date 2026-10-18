"""Step 1 of the logo: separate Portinari from the background (GrabCut).

Source photo: "Candido Portinari (1962)", Arquivo Nacional (Brazilian National
Archives), public domain, via Wikimedia Commons:
https://commons.wikimedia.org/wiki/File:C%C3%A2ndido_Portinari_(1962).jpg

Run from this folder:  python3 segment.py && python3 posterize.py &&
python3 build_logo.py '<config json>'   (see README.md here)
Requires: opencv-python, numpy, potracer, cairosvg, fonttools; Inter Display font.
"""
import cv2, numpy as np
img = cv2.imread('portinari_1962.png'); h, w = img.shape[:2]
mask = np.full((h, w), cv2.GC_PR_BGD, np.uint8)
body = np.array([[150,40],[360,40],[380,170],[372,290],[350,300],[445,368],[470,450],
                 [482,667],[55,667],[85,470],[110,400],[200,340],[160,300],[140,170]], np.int32)
cv2.fillPoly(mask, [body], cv2.GC_PR_FGD)
mask[:28, :] = cv2.GC_BGD
outside = np.ones((h, w), np.uint8); cv2.fillPoly(outside, [body], 0); mask[outside == 1] = cv2.GC_BGD
cv2.ellipse(mask, (255, 215), (80, 105), 0, 0, 360, cv2.GC_FGD, -1)
cv2.rectangle(mask, (170, 400), (420, 667), cv2.GC_FGD, -1)
bgd = np.zeros((1, 65)); fgd = np.zeros((1, 65))
cv2.grabCut(img, mask, None, bgd, fgd, 10, cv2.GC_INIT_WITH_MASK)
m = np.where((mask == 1) | (mask == 3), 255, 0).astype(np.uint8)
m = cv2.morphologyEx(m, cv2.MORPH_OPEN, np.ones((5, 5), np.uint8))
m = cv2.morphologyEx(m, cv2.MORPH_CLOSE, np.ones((11, 11), np.uint8))
n, lab, st, _ = cv2.connectedComponentsWithStats(m); k = 1 + np.argmax(st[1:, 4])
m = np.where(lab == k, 255, 0).astype(np.uint8)
inv = 255 - m; n, lab, st, _ = cv2.connectedComponentsWithStats(inv)
for i in range(1, n):
    x, y, ww, hh, a = st[i]
    if x > 0 and y > 0 and x + ww < w and y + hh < h:
        m[lab == i] = 255
m = cv2.GaussianBlur(m, (7, 7), 0); m = np.where(m > 127, 255, 0).astype(np.uint8)
cv2.imwrite('mask.png', m)
