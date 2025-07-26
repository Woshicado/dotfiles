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

## Otional

- hyperfine for automatic benchmarking (with multiple runs and warmup and timing)
- falsisign: Add print/scan cycle artifacts to make doc look handsigned
- ioping

## About `.local/bin`

While the files in there are not strictly dotfiles, they are executables I always find myself installing from anew. Therefore, I just put them there so they are immediately available on a new install.
