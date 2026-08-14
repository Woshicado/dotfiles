#!/usr/bin/env python3
"""Generate kanagawa themes for marimo.

Ports rebelot/kanagawa.nvim to marimo's CSS token surface. The palette and the
per-variant theme mappings below are transcribed from the plugin's
`lua/kanagawa/colors.lua` and `lua/kanagawa/themes.lua`, so a variant here means
the same thing it means in the editor.

marimo pairs one light and one dark theme in a single stylesheet via CSS
`light-dark()`, switched by the `.dark`/`.light` class marimo puts on <body>.
Lotus is always the light half; wave or dragon is the dark half.

Usage: gen_kanagawa.py <output-dir>
"""

import sys
import pathlib

# ---------------------------------------------------------------- palette
# verbatim from kanagawa.nvim/lua/kanagawa/colors.lua
P = {
    "sumiInk0": "#16161D", "sumiInk1": "#181820", "sumiInk2": "#1a1a22",
    "sumiInk3": "#1F1F28", "sumiInk4": "#2A2A37", "sumiInk5": "#363646",
    "sumiInk6": "#54546D",
    "waveBlue1": "#223249", "waveBlue2": "#2D4F67",
    "winterGreen": "#2B3328", "winterYellow": "#49443C",
    "winterRed": "#43242B", "winterBlue": "#252535",
    "autumnGreen": "#76946A", "autumnRed": "#C34043", "autumnYellow": "#DCA561",
    "samuraiRed": "#E82424", "roninYellow": "#FF9E3B",
    "waveAqua1": "#6A9589", "dragonBlue": "#658594",
    "oldWhite": "#C8C093", "fujiWhite": "#DCD7BA", "fujiGray": "#727169",
    "oniViolet": "#957FB8", "oniViolet2": "#b8b4d0", "crystalBlue": "#7E9CD8",
    "springViolet1": "#938AA9", "springViolet2": "#9CABCA", "springBlue": "#7FB4CA",
    "lightBlue": "#A3D4D5", "waveAqua2": "#7AA89F",
    "springGreen": "#98BB6C", "boatYellow1": "#938056", "boatYellow2": "#C0A36E",
    "carpYellow": "#E6C384",
    "sakuraPink": "#D27E99", "waveRed": "#E46876", "peachRed": "#FF5D62",
    "surimiOrange": "#FFA066", "katanaGray": "#717C7C",
    "dragonBlack0": "#0d0c0c", "dragonBlack1": "#12120f", "dragonBlack2": "#1D1C19",
    "dragonBlack3": "#181616", "dragonBlack4": "#282727", "dragonBlack5": "#393836",
    "dragonBlack6": "#625e5a",
    "dragonWhite": "#c5c9c5", "dragonGreen": "#87a987", "dragonGreen2": "#8a9a7b",
    "dragonPink": "#a292a3", "dragonOrange": "#b6927b", "dragonOrange2": "#b98d7b",
    "dragonGray": "#a6a69c", "dragonGray2": "#9e9b93", "dragonGray3": "#7a8382",
    "dragonBlue2": "#8ba4b0", "dragonViolet": "#8992a7", "dragonRed": "#c4746e",
    "dragonAqua": "#8ea4a2", "dragonAsh": "#737c73", "dragonTeal": "#949fb5",
    "dragonYellow": "#c4b28a",
    "lotusInk1": "#545464", "lotusInk2": "#43436c",
    "lotusGray": "#dcd7ba", "lotusGray2": "#716e61", "lotusGray3": "#8a8980",
    "lotusWhite0": "#d5cea3", "lotusWhite1": "#dcd5ac", "lotusWhite2": "#e5ddb0",
    "lotusWhite3": "#f2ecbc", "lotusWhite4": "#e7dba0", "lotusWhite5": "#e4d794",
    "lotusViolet1": "#a09cac", "lotusViolet2": "#766b90", "lotusViolet3": "#c9cbd1",
    "lotusViolet4": "#624c83",
    "lotusBlue1": "#c7d7e0", "lotusBlue2": "#b5cbd2", "lotusBlue3": "#9fb5c9",
    "lotusBlue4": "#4d699b", "lotusBlue5": "#5d57a3",
    "lotusGreen": "#6f894e", "lotusGreen2": "#6e915f", "lotusGreen3": "#b7d0ae",
    "lotusPink": "#b35b79", "lotusOrange": "#cc6d00", "lotusOrange2": "#e98a00",
    "lotusYellow": "#77713f", "lotusYellow2": "#836f4a", "lotusYellow3": "#de9800",
    "lotusYellow4": "#f9d791",
    "lotusRed": "#c84053", "lotusRed2": "#d7474b", "lotusRed3": "#e82424",
    "lotusRed4": "#d9a594",
    "lotusAqua": "#597b75", "lotusAqua2": "#5e857a",
    "lotusTeal1": "#4e8ca2", "lotusTeal2": "#6693bf", "lotusTeal3": "#5a7785",
    "lotusCyan": "#d7e3d8",
}


def _t(**kw):
    """Resolve palette names to hex."""
    return {k: P[v] for k, v in kw.items()}


# ------------------------------------------------------- theme mappings
# from kanagawa.nvim/lua/kanagawa/themes.lua
THEMES = {
    "wave": {
        "ui": _t(fg="fujiWhite", fg_dim="oldWhite", bg_dim="sumiInk1",
                 bg_gutter="sumiInk4", bg_m3="sumiInk0", bg_m2="sumiInk1",
                 bg_m1="sumiInk2", bg="sumiInk3", bg_p1="sumiInk4",
                 bg_p2="sumiInk5", special="springViolet1", nontext="sumiInk6",
                 bg_search="waveBlue2", bg_visual="waveBlue1",
                 float_bg="sumiInk0", float_fg="oldWhite",
                 pmenu_bg="waveBlue1", pmenu_bg_sel="waveBlue2"),
        "syn": _t(string="springGreen", number="sakuraPink", constant="surimiOrange",
                  identifier="carpYellow", parameter="oniViolet2", fun="crystalBlue",
                  statement="oniViolet", keyword="oniViolet", operator="boatYellow2",
                  preproc="waveRed", type="waveAqua2", regex="boatYellow2",
                  deprecated="katanaGray", comment="fujiGray", punct="springViolet2",
                  special1="springBlue", special2="waveRed", special3="peachRed"),
        "diag": _t(ok="springGreen", error="samuraiRed", warning="roninYellow",
                   info="dragonBlue", hint="waveAqua1"),
        "vcs": _t(added="autumnGreen", removed="autumnRed", changed="autumnYellow"),
        "action": _t(bg="winterYellow", bg_hover="sumiInk6", fg="carpYellow"),
        # Radix --gray-1..12, background end -> foreground end. marimo's cell
        # chrome reads these directly, bypassing the semantic tokens.
        "gray": ["#16161D", "#1a1a22", "#1F1F28", "#2A2A37", "#363646", "#43435a",
                 "#54546D", "#626282", "#727169", "#8a8a9e", "#C8C093", "#DCD7BA"],
    },
    "dragon": {
        "ui": _t(fg="dragonWhite", fg_dim="oldWhite", bg_dim="dragonBlack1",
                 bg_gutter="dragonBlack4", bg_m3="dragonBlack0", bg_m2="dragonBlack1",
                 bg_m1="dragonBlack2", bg="dragonBlack3", bg_p1="dragonBlack4",
                 bg_p2="dragonBlack5", special="dragonGray3", nontext="dragonBlack6",
                 bg_search="waveBlue2", bg_visual="waveBlue1",
                 float_bg="dragonBlack0", float_fg="oldWhite",
                 pmenu_bg="waveBlue1", pmenu_bg_sel="waveBlue2"),
        "syn": _t(string="dragonGreen2", number="dragonPink", constant="dragonOrange",
                  identifier="dragonYellow", parameter="dragonGray", fun="dragonBlue2",
                  statement="dragonViolet", keyword="dragonViolet", operator="dragonRed",
                  preproc="dragonRed", type="dragonAqua", regex="dragonRed",
                  deprecated="katanaGray", comment="dragonAsh", punct="dragonGray2",
                  special1="dragonTeal", special2="dragonRed", special3="dragonRed"),
        "diag": _t(ok="springGreen", error="samuraiRed", warning="roninYellow",
                   info="dragonBlue", hint="waveAqua1"),
        "vcs": _t(added="autumnGreen", removed="autumnRed", changed="autumnYellow"),
        "action": _t(bg="winterYellow", bg_hover="dragonBlack6", fg="dragonYellow"),
        "gray": ["#0d0c0c", "#12120f", "#1D1C19", "#282727", "#393836", "#4a4947",
                 "#5a5754", "#625e5a", "#737c73", "#8e8e88", "#a6a69c", "#c5c9c5"],
    },
    "lotus": {
        "ui": _t(fg="lotusInk1", fg_dim="lotusInk2", bg_dim="lotusWhite1",
                 bg_gutter="lotusWhite4", bg_m3="lotusWhite0", bg_m2="lotusWhite1",
                 bg_m1="lotusWhite2", bg="lotusWhite3", bg_p1="lotusWhite4",
                 bg_p2="lotusWhite5", special="lotusViolet2", nontext="lotusViolet1",
                 bg_search="lotusBlue2", bg_visual="lotusViolet3",
                 float_bg="lotusWhite0", float_fg="lotusInk2",
                 pmenu_bg="lotusBlue1", pmenu_bg_sel="lotusBlue3"),
        "syn": _t(string="lotusGreen", number="lotusPink", constant="lotusOrange",
                  identifier="lotusYellow", parameter="lotusBlue5", fun="lotusBlue4",
                  statement="lotusViolet4", keyword="lotusViolet4", operator="lotusYellow2",
                  preproc="lotusRed", type="lotusAqua", regex="lotusYellow2",
                  deprecated="lotusGray3", comment="lotusGray3", punct="lotusTeal1",
                  special1="lotusTeal2", special2="lotusRed", special3="lotusRed"),
        "diag": _t(ok="lotusGreen", error="lotusRed3", warning="lotusOrange2",
                   info="lotusTeal3", hint="lotusAqua2"),
        "vcs": _t(added="lotusGreen2", removed="lotusRed2", changed="lotusYellow3"),
        "action": _t(bg="lotusYellow4", bg_hover="lotusWhite5", fg="lotusYellow2"),
        "gray": ["#ebe4b2", "#e5ddb0", "#dcd5ac", "#d5cea3", "#c9c096", "#bab189",
                 "#a8a087", "#928f80", "#8a8980", "#716e61", "#545464", "#43436c"],
    },
}

# CodeMirror's StyleModule generates the live editor's token classes at runtime
# as `ͼ<n><letter>`. The letter is the index into marimo's createTheme `styles`
# array (a=settings, e=styles[0]) and so is fixed by marimo's theme definition;
# the number is a per-page module counter. We emit several counters because that
# number can shift if marimo loads a different set of style modules, and scope
# every rule under .cm-editor so a stale guess cannot color anything else.
CM_PREFIXES = range(3, 10)
CM_TOKENS = [  # (letter, syn key, extra declarations)
    ("e", "comment", "font-style:italic"),   # commentStyle.italic in kanagawa.lua
    ("f", None, None),                       # variableName -> ui.fg
    ("g", "string", "font-style:italic"),    # String italic override in kanagawa.lua
    ("h", "number", None),
    ("i", "constant", None),                 # bool
    ("j", "constant", None),                 # null
    ("k", "keyword", "font-weight:600"),     # keywordStyle.bold
    ("l", "type", None),                     # className
    ("m", "type", None),                     # definition(typeName)
    ("n", "type", None),                     # typeName
    ("o", "punct", None),                    # angleBracket
    ("p", "special1", None),                 # tagName
    ("q", "identifier", None),               # attributeName
    ("r", "operator", None),
    ("s", "fun", None),                      # function(variableName)
    ("t", "identifier", None),               # propertyName
]

# Pygments classes used by marimo's server-rendered fenced code blocks, mapped
# onto kanagawa syntax groups.
CODEHILITE = {
    "comment": ["c", "c1", "ch", "cm", "cs", "cpf"],
    "preproc": ["cp", "cpf"],
    "keyword": ["k", "kc", "kd", "kn", "kp", "kr"],
    "type": ["kt", "nc", "ne", "nn", "no"],
    "fun": ["nf", "nd", "nt"],
    "identifier": ["na", "py", "nv", "vc", "vg", "vi", "vm", "fm"],
    "constant": ["bp", "nb", "ni", "nl"],
    "string": ["s", "s1", "s2", "sa", "sb", "sc", "sd", "se", "sh",
               "si", "sr", "ss", "sx", "dl"],
    "number": ["m", "mb", "mf", "mh", "mi", "mo", "il", "l", "ld"],
    "operator": ["o", "ow"],
    "punct": ["p"],
    "special3": ["err"],
}


def ld(light, dark):
    """A CSS light-dark() pair — marimo's token value format."""
    return f"light-dark({light},{dark})"


def render(dark_name):
    """Emit the full stylesheet pairing lotus (light) with `dark_name` (dark)."""
    d, l = THEMES[dark_name], THEMES["lotus"]
    du, lu, ds, ls = d["ui"], l["ui"], d["syn"], l["syn"]
    dd, ldg = d["diag"], l["diag"]
    da, la = d["action"], l["action"]

    def pair(group, key):
        """light-dark() for the same key in both halves."""
        return ld(l[group][key], d[group][key])

    o = []
    w = o.append

    w(f"""/* kanagawa for marimo — lotus (light) + {dark_name} (dark)
 *
 * Ported from rebelot/kanagawa.nvim. Generated by gen_kanagawa.py — edit that,
 * not this file.
 *
 * marimo switches modes with a .dark/.light class on <body>, which sets
 * `color-scheme`; CSS light-dark() below resolves against it. Enable with
 *   [display]
 *   custom_css = ["/abs/path/to/{"kanagawa" if dark_name == "wave" else f"kanagawa-{dark_name}"}.css"]
 */
""")

    # ---- semantic design tokens -------------------------------------
    w("/* ---- design tokens ------------------------------------------------ */")
    w("/* marimo defines these on `.marimo,:root`; our block is injected at the")
    w(" * end of <head>, so equal specificity wins on source order. */")
    w(".marimo, :root {")
    w(f"  --background:{ld(lu['bg'], du['bg'])};")
    w(f"  --foreground:{ld(lu['fg'], du['fg'])};")
    w(f"  --muted:{ld(lu['bg_m1'], du['bg_m1'])};")
    w(f"  --muted-foreground:{pair('syn', 'comment')};")
    # floats/popovers sit *below* the page bg in kanagawa, unlike marimo's default
    w(f"  --popover:{ld(lu['float_bg'], du['float_bg'])};")
    w(f"  --popover-foreground:{ld(lu['float_fg'], du['float_fg'])};")
    w(f"  --card:{ld(lu['float_bg'], du['float_bg'])};")
    w(f"  --card-foreground:{ld(lu['float_fg'], du['float_fg'])};")
    w(f"  --border:{ld(l['gray'][3], d['gray'][3])};")
    w(f"  --input:{ld(l['gray'][6], d['gray'][6])};")
    w(f"  --primary:{pair('syn', 'fun')};")
    w(f"  --primary-foreground:{ld(lu['bg'], du['bg'])};")
    # marimo's stock dark --secondary is inverted (light bg / dark fg); we make
    # it behave like every other surface token instead.
    w(f"  --secondary:{ld(lu['bg_p1'], du['bg_p1'])};")
    w(f"  --secondary-foreground:{ld(lu['fg'], du['fg'])};")
    w(f"  --accent:{ld(lu['pmenu_bg'], du['pmenu_bg'])};")
    w(f"  --accent-foreground:{pair('syn', 'special1')};")
    w(f"  --ring:{pair('syn', 'fun')};")
    w(f"  --link:{pair('syn', 'special1')};")
    w(f"  --link-visited:{pair('syn', 'keyword')};")
    w(f"  --destructive:{pair('diag', 'error')};")
    w(f"  --destructive-foreground:{ld(lu['bg'], du['bg'])};")
    w(f"  --error:{pair('diag', 'error')};")
    w(f"  --error-foreground:{ld(lu['bg'], du['bg'])};")
    w(f"  --success:{pair('diag', 'ok')};")
    w(f"  --success-foreground:{ld(lu['bg'], du['bg'])};")
    # "needs run" affordance — kanagawa's winter/lotus yellows
    w(f"  --action:{ld(la['bg'], da['bg'])};")
    w(f"  --action-hover:{ld(la['bg_hover'], da['bg_hover'])};")
    w(f"  --action-foreground:{ld(la['fg'], da['fg'])};")
    w(f"  --stale:{ld(P['boatYellow1'] + '40', P['sumiInk5'] + '80')};")
    w(f"  --base-shadow:{ld('#00000014', '#00000059')};")
    w(f"  --base-shadow-darker:{ld('#00000029', '#00000080')};")
    # the live editor's background and comment color are the only two CM tokens
    # marimo exposes as variables
    w(f"  --cm-background:{ld(lu['bg_m1'], du['bg_m1'])};")
    w(f"  --cm-comment:{pair('syn', 'comment')};")
    w("}")
    w("")

    # ---- radix gray ramp --------------------------------------------
    w("/* ---- Radix gray ramp ---------------------------------------------- */")
    w("/* Cell borders, gutter text, setup-cell and console backgrounds read")
    w(" * --gray-N directly rather than the tokens above, so the ramp has to be")
    w(" * replaced too or the chrome stays marimo-colored. */")
    w(".light, .light-theme, :root {")
    for i, c in enumerate(l["gray"], 1):
        w(f"  --gray-{i}:{c};")
    w("}")
    w(".dark, .dark-theme {")
    for i, c in enumerate(d["gray"], 1):
        w(f"  --gray-{i}:{c};")
    w("}")
    w("")
    # marimo ships display-p3 duplicates of the Radix scales inside an @supports
    # block; without matching overrides those win back on wide-gamut displays.
    w("/* marimo ships display-p3 duplicates of the Radix scales that would")
    w(" * otherwise win on wide-gamut screens — restate ours in that context. */")
    w("@supports (color: color(display-p3 1 1 1)) {")
    w("  @media (color-gamut: p3) {")
    w("    .light, .light-theme, :root {")
    for i, c in enumerate(l["gray"], 1):
        w(f"      --gray-{i}:{c};")
    w("    }")
    w("    .dark, .dark-theme {")
    for i, c in enumerate(d["gray"], 1):
        w(f"      --gray-{i}:{c};")
    w("    }")
    w("  }")
    w("}")
    w("")
    # slate and sage are the neutral scales marimo reaches for in places the
    # gray ramp does not cover (neutral callouts, some chips); keep them on the
    # same ink ramp so nothing renders as an off-palette gray.
    w("/* Neutral scales marimo uses alongside --gray-* — same ink ramp. */")
    for scale in ("slate", "sage"):
        w(f".light, .light-theme, :root {{")
        for i, c in enumerate(l["gray"], 1):
            w(f"  --{scale}-{i}:{c};")
        w("}")
        w(f".dark, .dark-theme {{")
        for i, c in enumerate(d["gray"], 1):
            w(f"  --{scale}-{i}:{c};")
        w("}")
    w("")

    # ---- accent scales used by callouts/admonitions -------------------
    w("/* ---- accent steps used by callouts, admonitions and status chips --- */")
    for scale, key, grp in [("blue", "info", "diag"), ("red", "error", "diag"),
                            ("yellow", "warning", "diag"), ("amber", "warning", "diag"),
                            ("grass", "ok", "diag"), ("green", "ok", "diag"),
                            ("cyan", "hint", "diag"), ("purple", "keyword", "syn"),
                            ("orange", "constant", "syn"), ("crimson", "error", "diag"),
                            ("sky", "special1", "syn"), ("lime", "ok", "diag")]:
        lc, dc = l[grp][key], d[grp][key]
        w(f".light, .light-theme, :root {{ --{scale}-9:{lc}; --{scale}-10:{lc}; "
          f"--{scale}-11:{lc}; --{scale}-8:{lc}; }}")
        w(f".dark, .dark-theme {{ --{scale}-9:{dc}; --{scale}-10:{dc}; "
          f"--{scale}-11:{dc}; --{scale}-8:{dc}; }}")
    w("")

    # ---- editor ------------------------------------------------------
    w("/* ---- CodeMirror editor --------------------------------------------- */")
    # --cm-background only reaches dark mode: marimo's light CodeMirror theme
    # hardcodes background:#ffffff in JS. Repaint the editor explicitly so light
    # mode is not a white slab on lotus cream. Two classes beats the generated
    # single-class theme rule, so no !important is needed.
    w(f".marimo-cell .cm-editor, .marimo-cell .cm-editor .cm-scroller, "
      f".marimo-cell .cm-editor .cm-content "
      f"{{ background-color:{ld(lu['bg_m1'], du['bg_m1'])}; }}")
    w(f".cm .cm-gutters {{ background-color:{ld(lu['bg_m1'], du['bg_m1'])}; }}")
    w(f".dark .cm .cm-gutters {{ background-color:{du['bg_m1']}; }}")
    w(f".cm-cursor, .cm-dropCursor {{ border-left-color:{ld(lu['fg'], P['oldWhite'])}; }}")
    # CodeMirror's vim mode draws a block cursor and defaults it to #ff9696,
    # which is off-palette. Translucent so the character under it stays legible.
    w(f".cm-fat-cursor {{ background:{ld(lu['fg'] + '55', P['oldWhite'] + '55')} !important; }}")
    w(".cm-editor:not(.cm-focused) .cm-fat-cursor "
      f"{{ background:none !important; "
      f"outline:solid 1px {ld(lu['fg'], P['oldWhite'])} !important; }}")
    # marimo sets these with !important, so we have to as well
    w(f".light .cm-selectionBackground, .light .cm-editor .cm-selectionBackground "
      f"{{ background-color:{lu['bg_visual']} !important; }}")
    w(f".dark .cm-selectionBackground, .dark .cm-editor .cm-selectionBackground "
      f"{{ background-color:{du['bg_visual']} !important; }}")
    w(f".light .cm-searchMatch {{ background-color:{lu['bg_search']}; }}")
    w(f".dark .cm-searchMatch {{ background-color:{du['bg_search']}; }}")
    w(".marimo-cell .cm-editor.cm-focused .cm-activeLine:not(.cm-error-line) "
      f"{{ background:{ld(lu['bg_p1'] + '80', du['bg_p1'] + '80')}; }}")
    w(".marimo-cell .cm-editor.cm-focused .cm-activeLineGutter "
      f"{{ background:{ld(lu['bg_p1'], du['bg_p1'])}; }}")
    w(".dark .marimo-cell .cm-editor.cm-focused .cm-activeLine "
      f"{{ background:{du['bg_p1']}80; }}")
    w(".dark .marimo-cell .cm-editor.cm-focused .cm-activeLineGutter "
      f"{{ background:{du['bg_p1']}; }}")
    w(f".mo-cm-reactive-reference {{ color:{pair('syn', 'special1')}; "
      f"border-bottom-color:{ld(l['gray'][5], d['gray'][5])}; }}")
    w(f".mo-cm-reactive-reference-hover {{ border-bottom-color:{pair('syn', 'fun')}; }}")
    w("")

    w("/* Live-editor syntax. marimo hardcodes these colors in JS, so the only")
    w(" * handle is CodeMirror's generated class names (see CM_PREFIXES). */")
    for letter, key, extra in CM_TOKENS:
        lc = lu["fg"] if key is None else ls[key]
        dc = du["fg"] if key is None else ds[key]
        sel = ", ".join(f".cm-editor .ͼ{n}{letter}" for n in CM_PREFIXES)
        decls = f"color:{ld(lc, dc)}"
        if extra:
            decls += ";" + extra
        w(f"{sel} {{ {decls}; }}")
    w("")

    # ---- static/readonly code (docs, tooltips) -----------------------
    w("/* ---- readonly code in docs panels and tooltips (.tok-*) ------------ */")
    w("/* Scoped exactly as marimo scopes them, so specificity matches and our")
    w(" * later source position wins. */")
    tok_scope = ":is(.docs-documentation,.cm-tooltip .documentation)"
    for cls, key, extra in [
        ("tok-keyword", "keyword", "font-weight:600"),
        ("tok-string", "string", "font-style:italic"),
        ("tok-string2", "string", "font-style:italic"),
        ("tok-number", "number", None),
        ("tok-atom", "constant", None),
        ("tok-bool", "constant", None),
        ("tok-comment", "comment", "font-style:italic"),
        ("tok-className", "type", None),
        ("tok-namespace", "type", None),
        ("tok-typeName", "type", None),
        ("tok-operator", "operator", None),
        ("tok-propertyName", "identifier", None),
        ("tok-punctuation", "punct", None),
        ("tok-variableName", None, None),
    ]:
        lc = lu["fg"] if key is None else ls[key]
        dc = du["fg"] if key is None else ds[key]
        decls = f"color:{ld(lc, dc)}"
        if extra:
            decls += ";" + extra
        w(f"{tok_scope} .{cls} {{ {decls}; }}")
    w("")

    # ---- pygments fenced code blocks ---------------------------------
    w("/* ---- fenced code blocks in markdown (Pygments) --------------------- */")
    w(".marimo, :root {")
    for key, classes in CODEHILITE.items():
        for c in classes:
            w(f"  --codehilite-{c}:{ld(ls[key], ds[key])};")
    w(f"  --codehilite-n:{ld(lu['fg'], du['fg'])};")
    w(f"  --codehilite-nx:{ld(lu['fg'], du['fg'])};")
    w(f"  --codehilite-hll:{ld(lu['bg_p1'], du['bg_p1'])};")
    w("}")
    w(f".markdown .codehilite, .prose .codehilite, .codehilite, .codehilite pre "
      f"{{ background-color:{ld(lu['bg_m1'], du['bg_m1'])}; }}")
    w(".markdown .codehilite, .prose .codehilite, .codehilite "
      "{ border-radius:var(--radius); }")
    w("")

    # ---- prose / markdown output -------------------------------------
    w("/* ---- rendered markdown --------------------------------------------- */")
    w(".prose, .prose-sm, .prose-base, .prose-lg, .prose-xl, .prose-2xl {")
    w("  --tw-prose-body:var(--foreground);")
    w("  --tw-prose-headings:var(--foreground);")
    w("  --tw-prose-lead:var(--muted-foreground);")
    w("  --tw-prose-links:var(--link);")
    w("  --tw-prose-bold:var(--foreground);")
    w(f"  --tw-prose-counters:{pair('syn', 'special1')};")
    w(f"  --tw-prose-bullets:{pair('syn', 'special1')};")
    w("  --tw-prose-hr:var(--border);")
    w("  --tw-prose-quotes:var(--muted-foreground);")
    w(f"  --tw-prose-quote-borders:{pair('syn', 'fun')};")
    w("  --tw-prose-captions:var(--muted-foreground);")
    w(f"  --tw-prose-code:{pair('syn', 'string')};")
    w("  --tw-prose-pre-code:var(--foreground);")
    w(f"  --tw-prose-pre-bg:{ld(lu['bg_m1'], du['bg_m1'])};")
    w("  --tw-prose-th-borders:var(--border);")
    w("  --tw-prose-td-borders:var(--border);")
    w("}")
    w("")
    # kanagawa.lua gives markdown headings syntax hues rather than plain fg
    w("/* Heading hues follow the markdown overrides in the user's kanagawa.lua:")
    w(" * H1 fun, H2 keyword, H3 type, H4 string, H5 constant, H6 identifier. */")
    for lvl, key in enumerate(["fun", "keyword", "type", "string",
                               "constant", "identifier"], 1):
        w(f".markdown h{lvl}, .prose h{lvl} {{ color:{ld(ls[key], ds[key])}; }}")
    w(f".markdown blockquote {{ border-left-color:{pair('syn', 'fun')}; "
      f"color:{pair('syn', 'comment')}; font-style:italic; }}")
    # `:not(pre) >` matters: without it this also repaints every line of a
    # fenced block, which renders its own <code> inside <pre>.
    w(f".markdown :not(pre) > code, .prose :not(pre) > code "
      f"{{ color:{pair('syn', 'string')}; "
      f"background-color:{ld(lu['bg_p1'], du['bg_p1'])}; }}")
    w(f".markdown a {{ color:var(--link); }}")
    w(f".markdown hr {{ border-color:var(--border); }}")
    # marimo's table rows fall back to a plain white/near-white fill, which
    # reads as a hole punched in lotus's cream. Drive striping off the ink ramp.
    w(".markdown table tr, .markdown table td, .markdown table th, "
      "table.dataframe tr, table.dataframe td, table.dataframe th "
      "{ background-color:transparent; }")
    w(f".markdown table thead, table.dataframe thead "
      f"{{ background-color:{ld(lu['bg_p1'], du['bg_p1'])}; }}")
    w(f".markdown table tbody tr:nth-child(2n), table.dataframe tbody tr:nth-child(2n) "
      f"{{ background-color:{ld(lu['bg_m1'], du['bg_m1'])}; }}")
    w(f".markdown table, table.dataframe {{ border-color:var(--border); }}")
    w("")
    w("/* admonition rails */")
    for kinds, key in [(["warn", "warning"], "warning"), (["info", "note"], "info"),
                       (["caution", "danger", "error"], "error"),
                       (["success", "tip"], "ok")]:
        sel = ", ".join(f".markdown details.{k}" for k in kinds)
        w(f"{sel} {{ border-left-color:{ld(ldg[key], dd[key])}; }}")
    w("")

    # ---- cell chrome and app shell -----------------------------------
    w("/* ---- cell chrome ---------------------------------------------------- */")
    w(f".marimo-cell {{ background-color:{ld(lu['bg'], du['bg'])}; }}")
    w(f".dark .marimo-cell:hover {{ border-color:{d['gray'][5]}; }}")
    w(f".console-output-area {{ color:{ld(lu['fg_dim'], du['fg_dim'])}; }}")
    # <marimo-table> is a custom element with a shadow root: ordinary descendant
    # selectors cannot reach inside it. Only these four ::part() names and
    # inherited custom properties are available, so its internal row striping
    # stays whatever marimo ships.
    w(f"marimo-table::part(table-wrapper), marimo-table::part(table-footer), "
      f"marimo-table::part(table-tabs) "
      f"{{ background-color:{ld(lu['bg'], du['bg'])}; color:{ld(lu['fg'], du['fg'])}; }}")
    w(f"#cell-setup, #cell-setup .cm-editor, #cell-setup .cm-gutter "
      f"{{ background-color:{ld(l['gray'][1], d['gray'][1])}; }}")
    w("")

    return "\n".join(o) + "\n"


def main():
    outdir = pathlib.Path(sys.argv[1])
    outdir.mkdir(parents=True, exist_ok=True)
    for dark, name in [("wave", "kanagawa.css"), ("dragon", "kanagawa-dragon.css")]:
        path = outdir / name
        path.write_text(render(dark))
        print(f"wrote {path} ({path.stat().st_size} bytes)")


if __name__ == "__main__":
    main()
