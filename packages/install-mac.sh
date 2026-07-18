#!/usr/bin/env bash
#
# macOS package install. Everything lives in ./packages/Brewfile (regenerate
# with `brew bundle dump --force --file=packages/Brewfile`). Also links the GNU
# coreutils/sed/grep/awk/tar/find
# into ~/.local/gnubin under their *standard* names so the shell behaves the
# same as on Linux instead of falling back to the BSD userland.
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

### HOMEBREW #################################################################
if ! command -v brew >/dev/null 2>&1; then
  echo "==> Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

echo "==> brew bundle (formulae, casks, VS Code / mise / uv / npm tools)"
brew bundle --file="$DOTFILES_DIR/packages/Brewfile"

### GNU TOOLS INSTEAD OF BSD #################################################
# The gnu* / g-prefixed binaries brew installs are exposed here under their
# plain names. ~/.local/gnubin is prepended to PATH in dot-config/zsh/exports.zsh,
# so `sed`, `find`, `date`, `readlink`, ... resolve to the GNU versions.
echo "==> Linking GNU tools into ~/.local/gnubin"
gnubin="$HOME/.local/gnubin"
mkdir -p "$gnubin"
brew_prefix="$(brew --prefix)"

# Each of these packages ships a libexec/gnubin dir of un-prefixed symlinks.
for pkg in coreutils findutils gnu-sed gnu-tar grep; do
  src="$brew_prefix/opt/$pkg/libexec/gnubin"
  [[ -d $src ]] && ln -sf "$src/"* "$gnubin/"
done
# gawk has no gnubin dir; expose it as `awk`.
[[ -x "$brew_prefix/opt/gawk/bin/gawk" ]] && ln -sf "$brew_prefix/opt/gawk/bin/gawk" "$gnubin/awk"

echo "==> macOS packages done."
