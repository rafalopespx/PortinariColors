"""Reproduce how the PortinariColors palettes were chosen.

Steps
  1. Start with one candidate palette per painting (dominant tones).
  2. Merge palettes whose mean nearest-neighbour CIE76 dE is below 12,
     one pair at a time, recomputing after each merge until none is left.
  3. Pick each palette's colors by farthest-point sampling in CIELAB, seeded
     with the most chromatic color, so the first colors are the most distinct.
  4. Classify and order each palette (as in RColorBrewer / MetBrewer):
       qualitative  colors on the shortest path through CIELAB; discrete
                    picks follow the farthest-point priority from step 3.
       diverging    shortest path that is dark at both ends and lightest in
                    the middle, cool arm first; discrete picks take both
                    ends, then the center, then fill the two arms evenly.
       sequential   colors sorted by lightness; discrete picks take both
                    ends, then fill evenly.
     The category is the user-facing choice; the script checks that the
     requested ordering exists.
  5. Two sequential palettes are derived from the UN panels (Guerra's blue
     scale and Paz's earth-to-gold run). They are subsets of guerra and paz,
     so they are excluded from the merge step on purpose: they fill a
     different role (sequential) rather than duplicating a palette.
  6. Simulate protanopia, deuteranopia and tritanopia (Machado et al., 2009)
     and record cvd_n: the largest n for which the discrete subsets of
     2..n colors all keep a minimum dE >= 10 in all three simulations.

The candidate tones are HAND-ESTIMATED, not sampled from the MASP images.
See extract_masp_palettes.R to sample the originals.

Run:  python3 palette_selection.py
Requires: numpy
"""
import itertools
import numpy as np

# Estimated dominant tones per work (hex).
WORKS = {
    "coffee-agricultural-worker": ["#2B4C7E", "#E8B04B", "#B5532F", "#5B3B2A", "#F3E2C0", "#6E7F4A"],
    "northeastern-migrants":      ["#3A2B22", "#8B5A3C", "#C9A36A", "#6F7C86", "#D9CBB2"],
    "dead-child":                 ["#1F1B18", "#5E5751", "#A69F94", "#8C5532", "#E0D6C2"],
    "saint-francis":              ["#6B4A2E", "#E9DCC4", "#3D5A80", "#D9A441", "#B33A2A", "#22201D"],
    "inah-prudente-de-moraes":    ["#E8B9A0", "#A9B8A4", "#2D3E56", "#C98F3D", "#F1E6D6"],
    "sofia-cantalupo":            ["#D96B7A", "#2E8B8B", "#E0B04A", "#F2E8DC", "#2F5E46"],
    "felippe-daudt-doliveira":    ["#8A5B2F", "#7F8F80", "#1E1A17", "#D8C9AE", "#3F5670"],
    # UN Headquarters panels (1952-1956). Guerra: "a symphony in blue" of deep
    # violet-dark tones over light blues tending to pale citrine, with an
    # orange-to-red-and-rose counterpoint. Paz: dominated by golden yellows.
    "guerra": ["#2A1E4A", "#24408E", "#3F6FB5", "#9CC3D9", "#B9D8C8", "#DCE3AE", "#E07A3A", "#D9748A", "#A8352E"],
    "paz":    ["#E8B931", "#C98A2B", "#E2763A", "#E59A8F", "#7E9A4E", "#8FB8CF", "#6B4425", "#F4E6C2"],
}
CATEGORY = {"cafe": "qualitative", "paz": "qualitative", "retirantes": "diverging",
            "inah": "diverging", "sofia": "diverging", "guerra": "diverging"}
DERIVED = {  # name: (source palette, colors), all sequential
    "guerra_azul": ("guerra", ["#2A1E4A", "#24408E", "#3F6FB5", "#9CC3D9", "#B9D8C8", "#DCE3AE"]),
    "paz_ouro":    ("paz",    ["#6B4425", "#C98A2B", "#E8B931", "#F4E6C2"]),
}
SIZE = {"cafe": 6, "retirantes": 8, "inah": 5, "sofia": 5, "guerra": 9, "paz": 8}
NAMES = {"coffee-agricultural-worker": "cafe", "northeastern-migrants": "retirantes",
         "inah-prudente-de-moraes": "inah", "sofia-cantalupo": "sofia",
         "guerra": "guerra", "paz": "paz"}
THRESHOLD_MERGE = 12.0
THRESHOLD_CVD = 10.0

WHITE = np.array([0.95047, 1.0, 1.08883])
RGB2XYZ = np.array([[0.4124, 0.3576, 0.1805], [0.2126, 0.7152, 0.0722], [0.0193, 0.1192, 0.9505]])
MACHADO = {
    "protanopia":   np.array([[0.152286, 1.052583, -0.204868], [0.114503, 0.786281, 0.099216], [-0.003882, -0.048116, 1.051998]]),
    "deuteranopia": np.array([[0.367322, 0.860646, -0.227968], [0.280085, 0.672501, 0.047413], [-0.011820, 0.042940, 0.968881]]),
    "tritanopia":   np.array([[1.255528, -0.076749, -0.178779], [-0.078411, 0.930809, 0.147602], [0.004733, 0.691367, 0.303900]]),
}


def hex_to_rgb(h):
    return np.array([int(h[i:i + 2], 16) / 255 for i in (1, 3, 5)])


def lin_to_srgb(v):
    v = np.clip(v, 0, 1)
    return np.where(v <= 0.0031308, 12.92 * v, 1.055 * v ** (1 / 2.4) - 0.055)


def srgb_to_lin(v):
    return np.where(v <= 0.04045, v / 12.92, ((v + 0.055) / 1.055) ** 2.4)


def srgb_to_lab(rgb):
    rgb = np.atleast_2d(rgb)
    xyz = srgb_to_lin(rgb) @ RGB2XYZ.T / WHITE
    f = np.where(xyz > 0.008856, np.cbrt(xyz), 7.787 * xyz + 16 / 116)
    return np.stack([116 * f[:, 1] - 16, 500 * (f[:, 0] - f[:, 1]), 200 * (f[:, 1] - f[:, 2])], 1)


def labs(hexes):
    return srgb_to_lab(np.array([hex_to_rgb(h) for h in hexes]))


def min_pair(lab):
    return min(np.linalg.norm(lab[i] - lab[j]) for i, j in itertools.combinations(range(len(lab)), 2))


def simulate(hexes, kind):
    rgb = np.array([hex_to_rgb(h) for h in hexes])
    sim = lin_to_srgb(srgb_to_lin(rgb) @ MACHADO[kind].T)
    return srgb_to_lab(sim)


def set_similarity(a_hexes, b_hexes):
    la, lb = labs(a_hexes), labs(b_hexes)
    d = np.linalg.norm(la[:, None, :] - lb[None, :, :], axis=-1)
    return float((d.min(1).mean() + d.min(0).mean()) / 2)


def dedupe(hexes, tol=8.0):
    keep = []
    for h in hexes:
        if all(np.linalg.norm(labs([h])[0] - labs([k])[0]) >= tol for k in keep):
            keep.append(h)
    return keep


def farthest_point(hexes, k):
    lab = labs(hexes)
    chroma = np.hypot(lab[:, 1], lab[:, 2])
    chosen = [int(np.argmax(chroma))]
    while len(chosen) < min(k, len(hexes)):
        d = np.min([np.linalg.norm(lab - lab[c], axis=1) for c in chosen], axis=0)
        d[chosen] = -1
        chosen.append(int(np.argmax(d)))
    return [hexes[i] for i in chosen]


def path_length(lab, p):
    return sum(np.linalg.norm(lab[p[i]] - lab[p[i + 1]]) for i in range(len(p) - 1))


def display_order(hexes, category):
    """Indices of `hexes` in display (and continuous) order."""
    lab = labs(hexes)
    L = lab[:, 0]
    n = len(hexes)
    perms = itertools.permutations(range(n))
    if category == "sequential":
        return sorted(range(n), key=lambda i: L[i])
    if category == "diverging":
        def unimodal(p):
            k = int(np.argmax([L[i] for i in p]))
            return (1 <= k <= n - 2
                    and all(L[p[i]] < L[p[i + 1]] for i in range(k))
                    and all(L[p[i]] > L[p[i + 1]] for i in range(k, n - 1)))
        perms = [p for p in perms if unimodal(p)]
        if not perms:
            raise ValueError("no diverging ordering exists for this palette")
        best = list(min(perms, key=lambda p: path_length(lab, p)))
        if lab[best[0]][2] > lab[best[-1]][2]:   # cool (lower b*) arm first
            best = best[::-1]
        return best
    best = list(min(perms, key=lambda p: path_length(lab, p)))
    if L[best[0]] > L[best[-1]]:                 # darker end first
        best = best[::-1]
    return best


def spread_rank(n):
    """Sequential: ends first, then fill the gaps evenly."""
    chosen = [0, n - 1]
    while len(chosen) < n:
        cand = [i for i in range(n) if i not in chosen]
        chosen.append(max(cand, key=lambda i: (min(abs(i - c) for c in chosen), -abs(i - (n - 1) / 2))))
    return rank_from(chosen, n)


def diverging_rank(L):
    """Diverging: both ends, then the lightest (center), then balance the arms."""
    n = len(L)
    c = int(np.argmax(L))
    pos = [-(c - i) / c if i < c else (0.0 if i == c else (i - c) / (n - 1 - c)) for i in range(n)]
    chosen = [0, n - 1, c]
    while len(chosen) < n:
        cand = [i for i in range(n) if i not in chosen]
        left = sum(1 for j in chosen if j < c)
        right = sum(1 for j in chosen if j > c)
        def key(i):
            gap = min(abs(pos[i] - pos[j]) for j in chosen)
            need = (left <= right) if i < c else (right < left)
            return (round(gap, 6), need)
        chosen.append(max(cand, key=key))
    return rank_from(chosen, n)


def rank_from(chosen, n):
    rank = [0] * n
    for r, i in enumerate(chosen):
        rank[i] = r + 1
    return rank


def discrete_subset(cols, order, n):
    return [c for c, o in zip(cols, order) if o <= n]


def cvd_n(cols, order):
    n_safe = 1
    for n in range(2, len(cols) + 1):
        sub = discrete_subset(cols, order, n)
        if all(min_pair(simulate(sub, kind)) >= THRESHOLD_CVD for kind in MACHADO):
            n_safe = n
        else:
            break
    return n_safe


def finalise(name, priority, category):
    idx = display_order(priority, category)
    cols = [priority[i] for i in idx]
    if category == "qualitative":
        order = [priority.index(c) + 1 for c in cols]
    elif category == "sequential":
        order = spread_rank(len(cols))
    else:
        order = diverging_rank(labs(cols)[:, 0])
    return {"colors": cols, "order": order, "category": category, "cvd_n": cvd_n(cols, order)}


def main():
    groups = {k: [k] for k in WORKS}
    pool = lambda members: sum((WORKS[m] for m in members), [])

    while True:
        best = None
        for a, b in itertools.combinations(list(groups), 2):
            s = set_similarity(pool(groups[a]), pool(groups[b]))
            if s < THRESHOLD_MERGE and (best is None or s < best[0]):
                best = (s, a, b)
        if best is None:
            break
        s, a, b = best
        print(f"merge {groups[a]} + {groups[b]} (dE {s:.1f})")
        groups[a] = groups[a] + groups.pop(b)

    results = {}
    for lead, members in groups.items():
        name = NAMES[lead]
        priority = farthest_point(dedupe(pool(members)), SIZE[name])
        results[name] = dict(finalise(name, priority, CATEGORY[name]), works=members)
    for name, (source, cols) in DERIVED.items():
        results[name] = dict(finalise(name, cols, "sequential"), works=[f"derived from {source}"])

    print()
    for name, r in results.items():
        print(f"{name} ({r['category']}): works={r['works']}")
        print(f"  colors = {r['colors']}")
        print(f"  order  = {r['order']}")
        print(f"  cvd_n  = {r['cvd_n']}")
    return results


if __name__ == "__main__":
    main()
