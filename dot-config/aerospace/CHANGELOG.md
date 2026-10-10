# Changelog

## [0.1.1] - 2026-10-10

### Features

- **`dot-local/bin/aerospace-summon`**: a hidden or minimized window is now
  brought back to a normal state (`open -a`) and only moved once AeroSpace
  reports it as `floating`. The target workspace is read *before* that.

### Design Rationale

- Bug: summoning KeePassXC while it was hidden left it floating but sized to
  the full tile rect (2536x1375 instead of 1187x785). AeroSpace's
  `move-node-to-workspace` picks the target container via `window.isFloating`,
  which is false for windows in the `macos_native_*` containers, so the window
  was bound into the tiling root and resized. When AeroSpace later re-flagged it
  floating (`exitMacOsNativeUnconventionalState`) it never restored
  `lastFloatingSize`. Reproduced on 0.21.3-Beta; the `on-window-detected`
  `layout floating` rule is not involved.
- The workspace is read first because `open -a` activates the app and AeroSpace
  follows macOS focus to the window's old workspace, which made the script
  "move" the window to where it already was.

### Notes & Caveats

- Any other `move-node-to-workspace` (e.g. `alt-shift-<key>`) on a hidden or
  minimized floating window hits the same upstream bug; only the summon path is
  worked around here.
- Relies on `window-layout` values starting with `macos_native_`.

## [0.1.0] - 2026-09-29

### Features

- **`dot-local/bin/aerospace-toggle`**: one script for turning AeroSpace off and
  back on. `toggle` (suspend if running, resume if suspended, start if not
  running at all), `on` (ensure running *and* managing), `off` (suspend, process
  stays up), `quit` (suspend, then kill AeroSpace and JankyBorders).
- **New leader-key bindings** (`dot-config/leader-key/config.json`):
  - `<leader>ae` — `aerospace-toggle toggle`, the presentation escape hatch.
  - `<leader>as` — `aerospace-toggle on`, works whether or not AeroSpace is
    running, so there is always a way back in.
  - `<leader>ka` — `aerospace-toggle quit`, in the existing `kill` group next to
    `ks` (sketchybar).

### Design Rationale

- Motivation: multi-monitor slideshows. Automatic tiling and
  `focus-follows-mouse.enabled = true` both move windows / steal focus while
  presenting, and the presenter has no hands free to fight them.
- The soft path is AeroSpace's own `enable off`, not a kill: the process stays
  alive, so the same key resumes it and nothing has to re-tile from scratch.
  `enable` is also the only thing that keeps working while suspended (AeroSpace
  stops intercepting key events, but the CLI talks over its socket).
- `quit` runs `enable off` *first* on purpose. AeroSpace hides the windows of
  invisible workspaces by parking them outside the visible screen area, and
  `enable off` is what pulls them back in; quitting without it strands those
  windows off-screen with no window manager left to fetch them.
- `quit` also `pkill`s borders, because AeroSpace owns that process via
  `after-startup-command` — and that command already `pkill`s borders before
  starting it, so a later AeroSpace start brings it back cleanly.
- Bindings live under the existing `a` (aerospace) and `k` (kill) groups rather
  than a new group; `e`/`s` and `k`'s `a` were free, no rebinding needed.

### Notes & Caveats

- `enable off` is documented to stop tiling and key interception; whether it
  also stops focus-follows-mouse is **not** documented and was not verified
  live. If the cursor still steals focus while suspended, use `<leader>ka`
  (full quit) instead — that is unambiguous.
- `enable off` pulls every window from every invisible workspace onto the
  visible screen, so expect a crowded desktop while suspended. Resuming puts
  them back.
- Leader Key may need its config reloaded (menu bar item) to pick the new
  bindings up if it does not watch the file.
- The script is symlinked into `~/.local/bin` by hand: `stow -R .` currently
  aborts on an unrelated pre-existing conflict
  (`.config/oh-my-posh/.mytheme.omp.yaml` is a real file, not a link).
