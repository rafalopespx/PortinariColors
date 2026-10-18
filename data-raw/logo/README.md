# Hex logo

A posterized portrait of Candido Portinari in the light shades of the `guerra`
palette (cobalt, light blue, pale green-blue, pale citrine) on Guerra's deep
indigo, with red glasses frames, an orange border from the panel's warm counterpoint and a strip of
all nine `guerra` colors.

Source photo: *Candido Portinari (1962)*, Arquivo Nacional (Brazilian National
Archives), public domain, via
[Wikimedia Commons](https://commons.wikimedia.org/wiki/File:C%C3%A2ndido_Portinari_(1962).jpg).

```sh
python3 segment.py
python3 posterize.py
python3 build_logo.py '{"out":"logo","border":"#E07A3A","scale":0.76,"ox":68,"oy":58,"band":"#2A1E4A","band_y":432,"rule":"#E07A3A","text_y":484,"text_size":42,"text_color":"#DCE3AE","strip_y":506,"strip_w":17,"strip_h":9}'
```

Then copy `logo.svg` to `man/figures/logo.svg` and a 518 x 600 `logo.png` to
`man/figures/logo.png`. Requires `opencv-python`, `numpy`, `potracer`,
`cairosvg`, `fonttools` and the Inter Display font.
