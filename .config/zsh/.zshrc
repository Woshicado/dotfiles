# Path to your oh-my-zsh installation.
export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$XDG_CONFIG_HOME/zsh/oh-my-zsh"
export ZSHRC="$XDG_CONFIG_HOME/zsh/.zshrc"
export OMPY="$XDG_CONFIG_HOME/oh-my-posh/.mytheme.omp.yaml"

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

### Sort "*2.smth" before "*10.smth"
setopt numericglobsort

# Because ZSH did not take into account custom prompt functions we need to disable async loading
zstyle ':omz:alpha:lib:git' async-prompt no
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
ZSH_THEME="customized-bira"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# CASE_SENSITIVE="true"    # a == A ?
HYPHEN_INSENSITIVE="true"  # - == _ ?

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

### HISTORY FILE
export HISTFILE=$XDG_CONFIG_HOME/zsh/zsh_history
HIST_STAMPS="yyyy-mm-dd"

export FZF_BASE=/usr/bin/fzf
export FZF_DEFAULT_OPTS='--height 40% --tmux center,60%'
DISABLE_FZF_KEY_BINDINGS="false"

### PLUGINS
plugins=(
  git # With tmux, we do not really need this
  z       # Easy fuzzy navigation
  vscode  # cmd shortcuts. E.g.: `vscd f1 f2` opens diff in code
  sudo    # Double escape sudo's last command
  dirhistory
  history
  copybuffer
  zsh-autosuggestions
  virtualenv
  fzf
)

FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

source $ZSH/oh-my-zsh.sh

### User configuration

### >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
export CONDARC=$XDG_CONFIG_HOME/conda/condarc

__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

### MACROS
# mkdir and cd into it
function mcd() {
  mkdir -p "$1" && cd "$1";
}

# Replace `man` escape sequences to colorize instead
man() {
  export GROFF_NO_SGR=1   # Do not emit SGR sequences. These are different than the replaced ones
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[45;93m' \
  LESS_TERMCAP_se=$'\e[0m' \
  command man "$@"
}

# Source .source_me when entering a directory
autoload -U add-zsh-hook
load-local-conf() {
     # check file exists, is regular file and is readable:
     if [[ -f .source_me && -r .source_me ]]; then
       source .source_me
     fi
}
add-zsh-hook chpwd load-local-conf

# Ranger: cd to current if exiting via Q
function ranger {
  local IFS=$'\t\n'
  local tempfile="$(mktemp $HOME/.rangerdir.XXXXXXXXX)"
#  chmod a+rw $tempfile
  local ranger_cmd=(
    command
    ranger
    --cmd="map Q chain shell echo %d > \"$tempfile\"; quitall"
  )

  ${ranger_cmd[@]} "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "" ]]; then
    cd -- "$(cat -- "$tempfile")" || return
    clear
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}


### DEFAULT EDITOR
export VISUAL=nvim
export EDITOR="$VISUAL"
export VIMTEX_OUTPUT_DIRECTORY='out'

### CUSTOM COMPOSE FILE
export XCOMPOSEFILE='/home/woshi/.config/XCompose'

### PAGER (LESS) CONFIG
export PAGER='less -r'
export LESS='--mouse --wheel-lines 4'
export LESSHISTFILE=$XDG_CONFIG_HOME/.lesshst

### DOCKER
#export DOCKER_DEFAULT_PLATFORM='linux/amd64'
alias ssh_tb='ssh -L 16006:127.0.0.1:6006'

### HELPFUL ALIASES
alias cwd=pwd
alias dnfi='sudo dnf install'
alias dnfu='sudo dnf update'
alias dnfua='sudo dnf update --refresh'
alias brewua='brew update && brew upgrade && brew upgrade --cask && brew cleanup'
alias n='nvim'
alias c='xclip -sel c -r'
alias pdf='zathura'

# Directory aliases
alias ls='lsd'
alias l='lsd -l'
alias ll='lsd -la'
alias la='lsd -lA'
alias lt='lsd --tree'
alias llt='lsd -a --tree'
alias lat='lsd -la --tree'
alias llat='lsd -la --tree'
#alias cd='z'

# Copy directory over ssh (from remote to local)
alias rcp='rsync -saLPz --port 22 -e ssh '

# Custom git aliases for submodules
alias gsua='git submodule update --remote --recursive && git add . && git commit -m "Update Submodules to latest remote version" -e'
alias gsp='git push --recurse-submodules=on-demand'

# Always start ipython with current venv
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"

# Start obsidian (flatpak installation) manually to allow for gpg-signing
alias obsidian="/var/lib/flatpak/app/md.obsidian.Obsidian/current/active/files/obsidian"

### HANDY KEYBINDS
bindkey "^K" kill-line
bindkey "^[^?" backward-kill-line
bindkey "^W" backward-kill-word

### TMUX custom function
function tmuxsc() {
    local session_name="$1"

    if tmux has-session -t "$session_name" 2>/dev/null; then
        # If the session exists, switch to it
    else
        # If the session doesn't exist, create it in detached mode and switch to it
        tmux new-session -d -s "$session_name"
    fi
    tmux switch-client -t "$session_name"
}

### yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

### DEEPL
export DEEPL_AUTH_KEY="9ab11644-e033-4b12-6aee-67649d6fabe6:fx"

# Detect source and translate to
ts() {
  if [ "$1" = "-d" ]; then
    shift
    deepl text --to=ES --show-detected-source "$*"
  else
    deepl text --to=ES "$*"
  fi
}

te() {
  if [ "$1" = "-d" ]; then
    shift
    deepl text --to=EN-US --show-detected-source "$*"
  else
    deepl text --to=EN-US "$*"
  fi
}

tg() {
  if [ "$1" = "-d" ]; then
    shift
    deepl text --to=DE --show-detected-source "$*"
  else
    deepl text --to=DE "$*"
  fi
}

td() {
  if [ "$1" = "-d" ]; then
    shift
    deepl text --to=DE --show-detected-source "$*"
  else
    deepl text --to=DE "$*"
  fi
}
tj() {
  if [ "$1" = "-d" ]; then
    shift
    deepl text --to=JA --show-detected-source "$*"
  else
    deepl text --to=JA "$*"
  fi
}

# Explicitly translate from...
dts() { deepl text --to=ES --from=DE "$*" }
std() { deepl text --to=DE --from=ES "$*" }
dtj() { deepl text --to=JA --from=DE "$*" }

### LOCAL BINARY DIR
export PATH="$HOME/.local/bin:$PATH"

### GO BINARIES
export PATH="$HOME/go/bin:$PATH"

### Add homebrew to path, but APPEND
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew";
export HOMEBREW_CELLAR="/home/linuxbrew/.linuxbrew/Cellar";
export HOMEBREW_REPOSITORY="/home/linuxbrew/.linuxbrew/Homebrew";
export PATH="${PATH}:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin";
export MANPATH="/home/linuxbrew/.linuxbrew/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:${INFOPATH:-}";

### CUDA
export CUDA_HOME="/usr/local/cuda"
export PATH="${PATH}:${CUDA_HOME}/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${CUDA_HOME}/lib64:/usr/lib64"
export LIBRARY_PATH="${LIBRARY_PATH:+${LIBRARY_PATH}:}${LD_LIBRARY_PATH}"

eval "$(oh-my-posh init zsh --config "${HOME}/.config/oh-my-posh/.mytheme.omp.yaml")"

### Load venvwrapper
if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$HOME/Library/Python/3.9/bin/virtualenvwrapper.sh"

  ### Tev wrapper for macos... Seems to try and execute x86 instead of arm64 otherwise...
  alias tev="arch -arm64 /Applications/tev.app/Contents/MacOS/tev"
fi
# Load base env (macOS does not seem to do that by default)
workon base

### CUSTOM ZSH PROMPT

precmd_prompt () {
  # Regex to find visible character length of prompt string
  local zero='%([BSUbfksu]|([FK]|){*})'

  # split left part of first line
  local left_pref='─%B%(!.%{%}.%{%})%n@%m%{%} %B%{%}%4~ %{%}'
  left_eval=$(ruby_prompt_info)$(conda_info)$(venv_info) # $(git_prompt_info)$(hg_prompt_info)

  # Define what should be shown on the right
  PS1_1_right=${(%):-'[%D{%H:%M:%S}] '}

  # Git Prompt. Currently placed on the right. Could also be placed in the middle maybe? Will see
  local vcs_branch=$(git_prompt_info)$(hg_prompt_info)

  # Compute length of the left prompt
  local left_pref_length=${#${(S%%)left_pref//$~zero/}}
  local left_length=${#${(S%%)left_eval//$~zero/}}
  left_length=$(($left_length+$left_pref_length+2))

  # Compute length of the git prompt
  local git_length=${#${(S%%)vcs_branch//$~zero/}}
 
  # Compute the necessary width for the middle prompt.
  local middle_width=$((COLUMNS-left_length-${#PS1_1_right}-git_length))

  # Fill middle up to necessary length with spaces
  PS1_1_middle=${(r:$middle_width:: :)}

  # Finally build the prompt. First line right prompt color hard coded because of length calculation.
  ### GIT ON RIGHT
  PROMPT="${PROMPT_FL}${PS1_1_middle}${vcs_branch}%{$fg[green]%}${PS1_1_right}%{$reset_color%}"$'\n'"${PROMPT_SL}"
  ### GIT ON LEFT
  # PROMPT="${PROMPT_FL}${vcs_branch}${PS1_1_middle}%{$fg[green]%}${PS1_1_right}%{$reset_color%}"$'\n'"${PROMPT_SL}"
  ### GIT IN MIDDLE? Should be possible, but idk if better
}
#precmd_functions+=(precmd_prompt)


###### THE FOLLOWING SHOULD BE AT THE END.
### Make sure homebrew is the first to be looked up
export PATH="/opt/homebrew/bin:$PATH"
### Apply all defined hooks, e.g., sourcing .source_me files.
load-local-conf

