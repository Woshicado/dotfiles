# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME/zsh/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="bira"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

export FZF_BASE=/usr/bin/fzf

DISABLE_FZF_KEY_BINDINGS="false"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  # git # With tmux, we do not really need this
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
#
# You may need to manually set your language environment
# export LANG=en_US.UTF-8
#
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# >>> conda initialize >>>
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

# Put history in $XDG_CONFIG_HOME
export HISTFILE=$XDG_CONFIG_HOME/zsh/zsh_history
export LESSHISTFILE=$XDG_CONFIG_HOME/.lesshst

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

### DEFAULT EDITOR
export VISUAL=nvim
export EDITOR="$VISUAL"

### LOCAL BINARY DIR
export PATH="$HOME/.local/bin:$PATH"

### HELPFUL ALIASES
alias cwd=pwd
alias dnfi='sudo dnf install'
alias dnfu='sudo dnf update'
alias dnfua='sudo dnf update --refresh'
alias n='nvim'

### ANYDSL: The paths for this are kinda random... change to own need
export PATH="$HOME/Documents/Uni/CG/anydsl/llvm_install/bin:$HOME/Documents/Uni/CG/anydsl/artic/build/bin:$HOME/Documents/Uni/CG/anydsl/impala/build/bin:${PATH:-}"
export LD_LIBRARY_PATH="$HOME/Documents/Uni/CG/anydsl/llvm_install/lib:${LD_LIBRARY_PATH:-}"

### CUDA
export CUDA_HOME="/usr/local/cuda"
export PATH="${CUDA_HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:$LD_LIBRARY_PATH"

### HANDY KEYBINDS
bindkey "^K" kill-line
bindkey "^[^?" backward-kill-line
bindkey "^W" backward-kill-word

### Sort "*2.smth" before "*10.smth"
setopt numericglobsort

