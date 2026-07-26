# Neovim config

A standalone [lazy.nvim](https://github.com/folke/lazy.nvim) config. Requires Neovim 0.12+.

## Layout

```
init.lua                 bootstrap lazy, load the modules below
lua/lazy-config.lua      lazy.nvim options (disabled rtp plugins, install colorscheme)
lua/options.lua          vim options
lua/autocmds.lua         autocmds (trailing whitespace, binary files, quit-on-last)
lua/commands.lua         user commands (:Format, :BDCloseFT, :MacOSQuicklook)
lua/quickfix.lua         quickfix text formatter (_G.qftf)
lua/mappings.lua         keymaps
lua/complicated_mappings.lua  keymaps that need real logic
lua/floatterm.lua        toggleable floating terminal
lua/utils.lua            shared helpers
lua/plugins/init.lua     the plugin list; every entry is a file in plugins/configs/
lua/plugins/configs/     one file per plugin spec
```

## Theme

[kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim), driven by `'background'`:
`dark` maps to _wave_, `light` maps to _lotus_. Toggle with `<leader>tt`.

Custom colours live under a `my` namespace in `lua/plugins/configs/kanagawa.lua`
(`colors.theme.all.my` as the base, `colors.theme.lotus.my` overriding it for light),
and are consumed from the `overrides` function. Anything with a semantic equivalent
(`theme.vcs.*`, `theme.diag.*`, `theme.diff.*`, `theme.ui.*`) should use that directly
instead — those are already correct in every theme.

## Deploying

Files are symlinked into `~` with GNU Stow from the dotfiles root:

```sh
mise run stow
```
