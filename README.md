# My dotfiles

## Usage

- Clone to `$Home/dotfiles`
- `cd $HOME/dotfiles`
- Use `stow --no-folding --dotfiles -R .` to create symlinks to the files in this repository

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

```bash
brew install coreutils gnu-sed grep gawk gnu-tar findutils

gln -s /opt/homebrew/opt/coreutils/libexec/gnubin/* ~/.local/gnubin/
ln -s /opt/homebrew/opt/gnu-sed/libexec/gnubin/* ~/.local/gnubin/
ln -s /opt/homebrew/opt/grep/libexec/gnubin/* ~/.local/gnubin/
ln -s /opt/homebrew/opt/gawk/bin/gawk ~/.local/gnubin/awk
ln -s /opt/homebrew/opt/gnu-tar/libexec/gnubin/* ~/.local/gnubin/
ln -s /opt/homebrew/opt/findutils/libexec/gnubin/* ~/.local/gnubin/
```
