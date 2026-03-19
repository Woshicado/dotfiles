#!/usr/bin/env bash

### ENVIRONMENT VARIABLES
# This file is sourced from ~/.zshrc.

### VERY FIRST THING: DECRYPT KEYS
export $(sops --decrypt ~/dotfiles/secrets.env | xargs)

### PATHS
# Zsh/Oh-My-Zsh Paths
export ZSH="${XDG_CONFIG_HOME}/zsh/oh-my-zsh"
export ZSHRC="${XDG_CONFIG_HOME}/zsh/.zshrc"
export OMPY="${XDG_CONFIG_HOME}/oh-my-posh/.mytheme.omp.yaml"
export BOOKMARKS="${XDG_CONFIG_HOME}/zsh/.zsh_hashes"

# History
export HISTFILE="${XDG_CONFIG_HOME}/zsh/zsh_history"
export HIST_STAMPS='yyyy-mm-dd'
export HISTSIZE=10000000
export SAVEHIST=${HISTSIZE}

### TOOLS
# FZF
export FZF_BASE=/usr/bin/fzf
export FZF_DEFAULT_OPTS='--height 40% --tmux center,60%'

# Pagers and Editors
export MANPAGER='nvim +Man!'
export VISUAL="nvim"
export EDITOR="${VISUAL}"
export PAGER='less -r'
export LESS='--mouse --wheel-lines 4'
export LESSHISTFILE="${XDG_CONFIG_HOME}/.lesshst"

### SETTINGS
# Wandb
export WANDB_MODE='online'

# Locale
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Standard Notes
export SN_USE_SESSION=yes

# Gemini
export GEMINI_SANDBOX=true

# LaTeX
export VIMTEX_OUTPUT_DIRECTORY='out'

# XCompose
export XCOMPOSEFILE='$XDG_CONFIG_HOME/XCompose'

# Google Cloud
export GOOGLE_CLOUD_PROJECT="see-far"

# Homebrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar"
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew"
export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}"


### PATH
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/go/bin:${PATH}"
export PATH="${PATH}:${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin"
export PATH="${PATH}:${HOME}/.cache/lm-studio/bin"

# OS-specific PATH additions
if [[ "${OSTYPE}" == "darwin"* ]]; then
  # Use GNU tools instead of BSD tools on macOS
  export PATH="${HOME}/.local/gnubin:${PATH}"
  export PATH="${PATH}:/opt/homebrew/opt/coreutils/libexec/gnubin"

  export OVPN_PROFILE="${HOME}/Library/Application Support/OpenVPN Connect/profiles/1728929973375.ovpn"
fi

### COMMENTED OUT EXPORTS

# CUDA
#export CUDA_HOME="/usr/local/cuda"
#export PATH="${PATH}:${CUDA_HOME}/bin"
#export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${CUDA_HOME}/lib64:/usr/lib64"
#export LIBRARY_PATH="${LIBRARY_PATH:+${LIBRARY_PATH}:}${LD_LIBRARY_PATH}"

# Jekyll/Ruby
#export PATH="/opt/homebrew/bin:$PATH"

# Mujoco
#export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
#export CC="/opt/homebrew/opt/llvm/bin/clang"
#export CXX="/opt/homebrew/opt/llvm/bin/clang++"
#export CXX11="/opt/homebrew/opt/llvm/bin/clang++"
#export CXX14="/opt/homebrew/opt/llvm/bin/clang++"
#export CXX17="/opt/homebrew/opt/llvm/bin/clang++"
#export CXX1X="/opt/homebrew/opt/llvm/bin/clang++"
#export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
#export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

# NVM
# export NVM_DIR="$HOME/.nvm"

# Android Studio
# export ANDROID_HOME=$HOME/Library/Android/sdk
# export PATH=$PATH:$ANDROID_HOME/platform-tools
# export PATH=$PATH:$ANDROID_HOME/tools
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
