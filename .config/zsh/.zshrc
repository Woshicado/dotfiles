# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME/zsh/oh-my-zsh"
export ZSHRC="$XDG_CONFIG_HOME/zsh/.zshrc"

### Sort "*2.smth" before "*10.smth"
setopt numericglobsort

ZSH_THEME="customized-bira"

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


### DEFAULT EDITOR
export VISUAL=nvim
export EDITOR="$VISUAL"

### PAGER (LESS) CONFIG
export PAGER='less -r'
export LESS='--mouse --wheel-lines 4'
export LESSHISTFILE=$XDG_CONFIG_HOME/.lesshst

### HELPFUL ALIASES
alias cwd=pwd
alias dnfi='sudo dnf install'
alias dnfu='sudo dnf update'
alias dnfua='sudo dnf update --refresh'
alias n='nvim'
alias c='xclip -sel c -r'
# Directory aliases
alias ls='lsd'
alias l='lsd -l'
alias ll='lsd -la'
alias la='lsd -lA'
alias lt='lsd --tree'
# Copy directory over ssh (from remote to local)
alias rcp='rsync -saLPz --port 22 -e ssh '
# Custom git aliases for submodules
alias gsua='git submodule update --remote --recursive && git add . && git commit -m "Update Submodules to latest remote version" -e'
alias gsp='git push --recurse-submodules=on-demand'

### HANDY KEYBINDS
bindkey "^K" kill-line
bindkey "^[^?" backward-kill-line
bindkey "^W" backward-kill-word

### ANYDSL: The paths for this are kinda random... change to own need
#export PATH="$HOME/Documents/Uni/CG/anydsl/llvm_install/bin:$HOME/Documents/Uni/CG/anydsl/artic/build/bin:$HOME/Documents/Uni/CG/anydsl/impala/build/bin:${PATH:-}"
#export LD_LIBRARY_PATH="$HOME/Documents/Uni/CG/anydsl/llvm_install/lib:${LD_LIBRARY_PATH:-}"

### LOCAL BINARY DIR
export PATH="$HOME/.local/bin:$PATH"

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
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:{CUDA_HOME}/lib64"


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
  local git_prompt_info=$(git_prompt_info)$(hg_prompt_info)

  # Compute length of the left prompt
  local left_pref_length=${#${(S%%)left_pref//$~zero/}} 
  local left_length=${#${(S%%)left_eval//$~zero/}}
  left_length=$(($left_length+$left_pref_length+2))

  # Compute length of the git prompt
  local git_length=${#${(S%%)git_prompt_info//$~zero/}}

  # Compute the necessary width for the middle prompt.
  local middle_width=$((COLUMNS-left_length-${#PS1_1_right}-git_length))
  
  # Fill middle up to necessary length with spaces
  PS1_1_middle=${(r:$middle_width:: :)}

  # Finally build the prompt. First line right prompt color hard coded because of length calculation.
  ### GIT ON RIGHT
  PROMPT="${PROMPT_FL}${PS1_1_middle}${git_prompt_info}%{$fg[green]%}${PS1_1_right}%{$reset_color%}"$'\n'"${PROMPT_SL}"
  ### GIT ON LEFT
  #PROMPT="${PROMPT_FL}${git_prompt_info}${PS1_1_middle}%{$fg[green]%}${PS1_1_right}%{$reset_color%}"$'\n'"${PROMPT_SL}"
  ### GIT IN MIDDLE? Should be possible, but idk if better
}
precmd_functions+=(precmd_prompt)

