#!/usr/bin/env python3
"""Generate the Yeezy Omarchy themes from the palettes below.

Writes themes/yeezy-<slug>/{colors.toml,icons.theme}. Wallpapers are built
separately by wallpapers.sh into themes/yeezy-<slug>/backgrounds/.
"""
from pathlib import Path

ROOT = Path(__file__).parent

# slug: (era, icons, bg, fg, faint fg, dim fg, bright fg, accent, selection, muted,
#        red, green, yellow, blue, magenta, cyan)
PALETTES = {
    "murakami":        ("graduation", "Yaru-purple",     "#f1eaf5", "#33214f", "#baadc8", "#685486", "#1c0d33", "#b9549c", "#e2d4ec", "#cbbcd8", "#bd4660", "#33826a", "#a06e22", "#4a69bd", "#9a48a6", "#2a7c90"),
    "good-morning":    ("graduation", "Yaru",            "#fcefe4", "#2f2852", "#cdb8ab", "#6c6286", "#18123a", "#dc7448", "#f5dccb", "#e0c9ba", "#c24a48", "#44815f", "#a0701a", "#4868b8", "#a4508a", "#2c7c8c"),
    "flashing-lights": ("graduation", "Yaru-magenta",    "#f3e7de", "#35252c", "#c8b4aa", "#745c63", "#1d1016", "#bd5f6e", "#ead5cb", "#d7c2b6", "#b34c4c", "#5a7250", "#966c22", "#52629c", "#955284", "#3f7782"),
    "dropout-bear":    ("graduation", "Yaru-wartybrown", "#f0e6d5", "#3b2c20", "#c0b098", "#735e4a", "#20150d", "#a66a34", "#e2d3ba", "#cebda2", "#aa4a40", "#507046", "#96721a", "#465f92", "#864e70", "#3b727a"),
    "sleeve":          ("808s",       "Yaru-red",        "#d8dbdd", "#24282c", "#a0a5a9", "#585e64", "#0e1012", "#c0424f", "#c4c9cd", "#adb2b6", "#b8405a", "#3a7a58", "#8a6c14", "#2f6e8e", "#6c5aa6", "#33747e"),
    "love-lockdown":   ("808s",       "Yaru-red",        "#fbfaf8", "#303032", "#c4c2be", "#777572", "#101011", "#cf4755", "#ebe7e2", "#d5d2cc", "#bf4250", "#5f7a64", "#977a3c", "#5a708f", "#966078", "#5a8088"),
    "heartless":       ("808s",       "Yaru-magenta",    "#ebe7ef", "#2e2739", "#b7afc2", "#685e78", "#171120", "#b55c90", "#dcd4e6", "#c8bfd3", "#b04c6c", "#448074", "#90703e", "#5166aa", "#8659a2", "#377c8e"),
    "coldest-winter":  ("808s",       "Yaru-blue",       "#e7eef3", "#22303e", "#a5b2bf", "#54667a", "#0d1924", "#4a7fb2", "#cfdce8", "#b7c5d2", "#a84a60", "#407a6e", "#887336", "#3a6ba4", "#6f5ea0", "#2a7f93"),
    "jewel-case":      ("yeezus",     "Yaru-red",        "#eaeded", "#1b1d1d", "#aaaeae", "#5c6060", "#050606", "#d0392d", "#d2d7d7", "#babfbf", "#c2362b", "#4c6156", "#6d6a58", "#48586c", "#8a4a48", "#52686a"),
    "mountain":        ("yeezus",     "Yaru-wartybrown", "#efede8", "#2c2a28", "#b9b5ad", "#68645e", "#141312", "#aa856e", "#ded9d0", "#c9c4ba", "#a4503f", "#5d6c56", "#8c7238", "#566a80", "#84616a", "#557470"),
    "slide":           ("season",     "Yaru-sage",       "#e9e6dc", "#2c2e2a", "#aeac9f", "#62645c", "#171916", "#6f7a6a", "#d4d5c8", "#bebdaf", "#a05540", "#4f6a4e", "#8a7030", "#4e6578", "#7d5d70", "#44706a"),
    "black-square":    ("donda",      "Yaru-sage",       "#f2f1ee", "#1e1e1e", "#b8b7b3", "#62615e", "#050505", "#2b2b2b", "#dcdbd7", "#c6c5c1", "#2a2a2a", "#555555", "#707070", "#3a3a3a", "#626262", "#808080"),
    "perfect-hoodie":  ("donda",      "Yaru-blue",       "#efeeea", "#25282f", "#b3b3ae", "#5d6068", "#0e1014", "#4d68aa", "#d7dce8", "#c3c3be", "#a6483e", "#4a6b54", "#886c24", "#4d68aa", "#6f5796", "#407286"),
    "bourgeois":       ("donda",      "Yaru-red",        "#f6f1ea", "#2d2728", "#c2b8ae", "#6f6462", "#151011", "#c24e58", "#f0dcd8", "#d3c8bd", "#b8404a", "#5c7558", "#947234", "#465f98", "#a04e70", "#487686"),
    "childhood-home":  ("donda",      "Yaru-yellow",     "#e3e1dd", "#26282d", "#a8a7a3", "#5a5c62", "#101114", "#b37a22", "#d0cec9", "#b7b5b0", "#a44c3c", "#586a4e", "#90701e", "#4a5c7c", "#7a586c", "#4c6f72"),
}


def mix(a, b, t):
    """Blend hex colour a toward b by fraction t."""
    pa, pb = (tuple(int(c[i:i + 2], 16) for i in (1, 3, 5)) for c in (a, b))
    return "#" + "".join(f"{round(x + (y - x) * t):02x}" for x, y in zip(pa, pb))


def colors_toml(p):
    (_, _, bg, fg, dfg, lfg, bfg, accent, sel, muted,
     red, green, yellow, blue, magenta, cyan) = p
    # On a light ground every "other background" is a step toward the text colour.
    rows = [
        ("mode", "light"), None,
        ("accent", accent), ("selection", sel), ("muted", muted), None,
        ("background", bg),
        ("dark_background", mix(bg, fg, 0.04)),
        ("darker_background", mix(bg, fg, 0.09)),
        ("lighter_background", mix(bg, fg, 0.07)), None,
        ("foreground", fg), ("dark_foreground", dfg),
        ("light_foreground", lfg), ("bright_foreground", bfg), None,
        ("red", red), ("yellow", yellow), ("orange", mix(red, yellow, 0.5)),
        ("green", green), ("cyan", cyan), ("blue", blue), ("magenta", magenta),
        ("brown", mix(yellow, fg, 0.45)), None,
    ]
    rows += [(f"bright_{n}", mix(c, fg, 0.18)) for n, c in
             (("red", red), ("yellow", yellow), ("green", green),
              ("cyan", cyan), ("blue", blue), ("magenta", magenta))]
    return "".join("\n" if r is None else f'{r[0]} = "{r[1]}"\n' for r in rows)


def main():
    for slug, p in PALETTES.items():
        out = ROOT / "themes" / f"yeezy-{slug}"
        (out / "backgrounds").mkdir(parents=True, exist_ok=True)
        (out / "colors.toml").write_text(colors_toml(p))
        (out / "icons.theme").write_text(p[1] + "\n")
    print(f"wrote {len(PALETTES)} themes")


if __name__ == "__main__":
    main()
