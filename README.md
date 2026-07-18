# My dotfiles

## Usage

- Clone to `$HOME/dotfiles`
- `cd $HOME/dotfiles`
- Run `./install-all.sh`

`install-all.sh` detects the OS and delegates:

- **macOS** → `packages/install-mac.sh`: `brew bundle` (source of truth:
  [`packages/Brewfile`](./packages/Brewfile), regenerate with
  `brew bundle dump --force --file=packages/Brewfile`) + links GNU tools into
  `~/.local/gnubin` (see below).
- **Linux** → `packages/install-linux.sh`: native packages via `apt`/`dnf` (best-effort, missing
  names are skipped), symlinks `fd`→`fdfind` / `bat`→`batcat` on Debian, and installs
  `oh-my-posh` from its upstream installer.

Package lists live in [`packages/`](./packages) — edit those plaintext files (one
entry per line) to add or remove packages without touching the install scripts:
`Brewfile` (macOS), `linux-common.txt` / `linux-apt.txt` / `linux-dnf.txt` (Linux),
and `gh-extensions.txt` (gh CLI extensions, cross-platform).

It then runs the shared steps: `stow --no-folding --dotfiles -R .` (symlinks the dotfiles
into `$HOME`), `mise install` (tools declared in `~/.config/mise`), and `gh` extensions.

To only deploy the symlinks without touching packages, run
`stow --no-folding --dotfiles -R .` directly.

## Programs to install

- zsh
- nvim + NvChad
- lsd
- dutree
- (git-)delta
- gping
- glow
- xsv
- ranger
- hexyl
- fd(-find)
- ...
- AND MORE [TODO]

Command (fedora):

```
sudo dnf install zsh neovim lsd git-delta gping glow ranger hexyl fd-find dutree
```

Download ngrams for ltex language server from the [Language Tool Website](https://languagetool.org/download/ngram-data/) into `~/.models`.

At the time of writing

```bash
mkdir -p ~/.models

wget https://languagetool.org/download/ngram-data/ngrams-de-20150819.zip -O ~/.models/ngrams-de.zip
wget https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip -O ~/.models/ngrams-en.zip
wget https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip -O ~/.models/ngrams-es.zip

unzip ~/.models/ngrams-de.zip -d ~/.models
unzip ~/.models/ngrams-en.zip -d ~/.models
unzip ~/.models/ngrams-es.zip -d ~/.models

rm ~/.models/ngrams-*.zip
```

## Otional

- hyperfine for automatic benchmarking (with multiple runs and warmup and timing)
- falsisign: Add print/scan cycle artifacts to make doc look handsigned
- ioping

## About `.local/bin`

While the files in there are not strictly dotfiles, they are executables I always find myself installing from anew. Therefore, I just put them there so they are immediately available on a new install.

### GNU tools instead of BSD ones

On macOS, `packages/install-mac.sh` links the Homebrew GNU tools into `~/.local/gnubin`
under their standard names (`sed`, `find`, `date`, `readlink`, ...), which
`dot-config/zsh/exports.zsh` prepends to `PATH`. This makes the userland behave
like Linux. Equivalent to running by hand:

```bash
brew install coreutils gnu-sed grep gawk gnu-tar findutils

for pkg in coreutils findutils gnu-sed gnu-tar grep; do
  ln -sf /opt/homebrew/opt/$pkg/libexec/gnubin/* ~/.local/gnubin/
done
ln -sf /opt/homebrew/opt/gawk/bin/gawk ~/.local/gnubin/awk
```

On Linux the coreutils are already GNU, so no shimming is needed.
