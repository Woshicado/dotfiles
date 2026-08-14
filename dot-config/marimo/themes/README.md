# kanagawa for marimo

A port of [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) to marimo's
CSS token surface, matching the nvim setup in `dot-config/nvim/lua/plugins/configs/kanagawa.lua`
(dark → wave, light → lotus).

| file                  | light | dark   |
| --------------------- | ----- | ------ |
| `kanagawa.css`        | lotus | wave   |
| `kanagawa-dragon.css` | lotus | dragon |

Each file covers *both* modes via CSS `light-dark()`, so it follows marimo's
light/dark toggle rather than needing separate files per mode. Pick one file —
they differ only in which dark half they carry.

## Enabling

In `marimo.toml`, under `[display]`:

```toml
custom_css = ["/Users/joshua/dotfiles/dot-config/marimo/themes/kanagawa.css"]
```

The path must be **absolute**. marimo resolves `custom_css` entries from the
user config relative to the *notebook* file, not to `marimo.toml`, so a relative
path would break as soon as you opened a notebook from another directory.
(Per-project overrides in a `pyproject.toml` `[tool.marimo.display]` block *do*
resolve relative to that file.)

marimo inlines the CSS when it renders the page, so a change needs a server
restart plus a browser reload — a hot reload of the notebook is not enough.

## Regenerating

Both stylesheets are generated; edit `gen_kanagawa.py`, not the CSS.

```sh
python gen_kanagawa.py .
```

The palette and the per-variant `ui`/`syn`/`diag` tables are transcribed from
the plugin's `lua/kanagawa/colors.lua` and `lua/kanagawa/themes.lua`, so a
variant means the same thing here as it does in the editor.

## What it covers

- semantic design tokens (`--background`, `--primary`, `--error`, …)
- the Radix `--gray-*` / `--slate-*` / `--sage-*` ramps, plus the accent steps
  used by callouts and admonitions — marimo's cell chrome reads these directly
  and ignores the semantic tokens
- the CodeMirror editor: background, gutter, cursor (including vim's block
  cursor), selection, active line, and syntax tokens
- readonly code in docs panels and tooltips (`.tok-*`)
- Pygments-highlighted fenced code blocks (`--codehilite-*`)
- rendered markdown, including Tailwind Typography's `--tw-prose-*`, and
  heading hues following the `@markup.heading` overrides from `kanagawa.lua`
  (H1 fun, H2 keyword, H3 type, H4 string, H5 constant, H6 identifier)

## Known limits

These are marimo constraints, not gaps in the port:

- **Live-editor syntax colors are hardcoded in marimo's JS**, not exposed as CSS
  variables. The only handle is CodeMirror's generated `ͼ<n><letter>` class
  names, where the letter is fixed by marimo's theme definition but the number
  is a per-page module counter. `gen_kanagawa.py` emits several counters and
  scopes every rule under `.cm-editor`, so a shifted counter degrades to
  marimo's stock One Dark rather than miscoloring anything. If a marimo upgrade
  reorders that theme's `styles` array, re-check the `CM_TOKENS` letter mapping.
- **`<marimo-table>` is a custom element with a shadow root.** Only four
  `::part()` names are exported, so its internal row striping stays marimo's.
  Inherited custom properties still reach inside it.
- marimo's light CodeMirror theme hardcodes `background: #ffffff`, so
  `--cm-background` alone only affects dark mode; the editor background is
  repainted explicitly instead.
- Plot output is not themed — matplotlib figures carry their own background.
  Use a matplotlib style if you want figures to match.
