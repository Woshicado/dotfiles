#!/usr/bin/env bash
#
# Linux package install via the native package manager (apt or dnf), falling
# back to mise / upstream installers for what the distro doesn't ship.
#
# Notes vs. macOS:
#   * coreutils/sed/grep/awk/tar/find are already GNU here — no gnubin shim.
#   * Debian/Ubuntu rename a couple of binaries (fdfind, batcat); we symlink
#     them back to fd/bat in ~/.local/bin (on PATH via exports.zsh).
#   * oh-my-posh isn't packaged anywhere, so it comes from its own installer.
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Read a package list file: one entry per line, ignoring blank lines and
# #-comments (both whole-line and trailing). Missing file -> empty list.
read_pkg_file() {
  local file="$1" line
  [[ -f $file ]] || return 0
  while IFS= read -r line || [[ -n $line ]]; do
    line="${line%%#*}"                       # strip trailing comment
    line="${line#"${line%%[![:space:]]*}"}"  # trim leading whitespace
    line="${line%"${line##*[![:space:]]}"}"  # trim trailing whitespace
    [[ -n $line ]] && printf '%s\n' "$line"
  done < "$file"
}

### DETECT PACKAGE MANAGER ###################################################
if command -v apt-get >/dev/null 2>&1; then
  PM=apt
elif command -v dnf >/dev/null 2>&1; then
  PM=dnf
else
  echo "No supported package manager (apt/dnf) found." >&2
  exit 1
fi
echo "==> Package manager: $PM"

### NATIVE PACKAGES ##########################################################
# Package lists live in ./packages/*.txt (one per line) so they can be edited
# without touching this script. Installed best-effort (a name missing on one
# distro/release is skipped, not fatal).
#   linux-common.txt  — same name on apt and dnf
#   linux-apt.txt / linux-dnf.txt — names that differ per distro
mapfile -t COMMON_PKGS < <(read_pkg_file "$DOTFILES_DIR/packages/linux-common.txt")
mapfile -t EXTRA_PKGS  < <(read_pkg_file "$DOTFILES_DIR/packages/linux-$PM.txt")

pm_install() {
  case $PM in
    apt) sudo apt-get install -y "$1" ;;
    dnf) sudo dnf install -y "$1" ;;
  esac
}

[[ $PM == apt ]] && sudo apt-get update

for pkg in "${COMMON_PKGS[@]}" "${EXTRA_PKGS[@]}"; do
  if pm_install "$pkg" >/dev/null 2>&1; then
    echo "  installed: $pkg"
  else
    echo "  skip (unavailable via $PM): $pkg"
  fi
done

### DEBIAN BINARY-NAME GUARDS ################################################
# fd-find installs `fdfind`, bat installs `batcat` on Debian/Ubuntu. Alias them
# back to the canonical names our config (and muscle memory) expect.
mkdir -p "$HOME/.local/bin"
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  echo "  linked fd -> fdfind"
fi
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  echo "  linked bat -> batcat"
fi

### UNPACKAGED / VERSION-SENSITIVE TOOLS #####################################
# oh-my-posh: not in apt/dnf. Drop the binary into ~/.local/bin.
if ! command -v oh-my-posh >/dev/null 2>&1; then
  echo "==> Installing oh-my-posh"
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$HOME/.local/bin"
fi

# fzf's `source <(fzf --zsh)` needs >= 0.48. Older distro builds silently lose
# the shell integration — warn so it can be pulled from mise instead.
if command -v fzf >/dev/null 2>&1; then
  ver="$(fzf --version 2>/dev/null | awk '{print $1}')"
  if [[ -n $ver ]] && ! printf '0.48.0\n%s\n' "$ver" | sort -VC; then
    echo "!! fzf $ver is older than 0.48 — 'fzf --zsh' won't work."
    echo "   Get a newer one with:  mise use -g fzf"
  fi
fi

echo "==> Linux packages done."
