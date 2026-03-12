#!/usr/bin/env bash

# This file is sourced from ~/.zshrc.
# It contains custom functions.

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude '.git' . "$1"
}

fzf-home-widget() {
  local file
  file=$(cd ~ && fd --type f --hidden --follow --exclude '.git' . | fzf)
  [[ -n $file ]] && LBUFFER+="$HOME/$file"
  zle redisplay
}
zle -N fzf-home-widget
bindkey '^[t' fzf-home-widget # Alt-T


copy-command() {
  echo -n $BUFFER | pbcopy
  zle -M 'Copied to clipboard'
}
zle -N copy-command
bindkey '^Xc' copy-command


# TMUX custom function
tmuxsc() {
  local session_name="$1"

  if tmux has-session -t "$session_name" 2>/dev/null; then
    # If the session exists, switch to it
  else
    # If the session doesn't exist, create it in detached mode and switch to it
    tmux new-session -d -s "$session_name"
  fi
  tmux switch-client -t "$session_name"
}
