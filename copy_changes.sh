#!/bin/sh

# Alacritty
cp ~/.config/alacritty/alacritty.yml ./.config/alacritty/alacritty.yml

# Conda
cp ~/.config/conda/condarc ./.config/conda/condarc

# Neovim
rm -r ./.config/nvim/lua/custom
cp ~/.config/nvim/init.lua ./.config/nvim/init.lua
cp -r ~/.config/nvim/lua/custom ./.config/nvim/lua/custom

# LSD
cp ~/.config/lsd/config.yaml ./.config/lsd/config.yaml

# Tmux
cp ~/.config/tmux/tmux.conf ./.config/tmux/tmux.conf
cp ~/.config/tmux/gitmux.conf ./.config/tmux/gitmux.conf

# Zsh
cp ~/.config/zsh/.zshrc ./.config/zsh/.zshrc
cp /etc/zshenv ./etc/zshenv

# Git
cp ~/.gitconfig ./.gitconfig

