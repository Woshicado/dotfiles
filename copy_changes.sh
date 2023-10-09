#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BGREEN='\033[0;92m'
BRED='\033[0;33m'
YELLOW='\033[1;33m'
NC='\033[0m' # No color

# Initialize the swap flag
swap=false
whole_path=false

# Parse command line options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -o|--out)
            swap=true
            shift
            ;;
        -p|--whole-path)
            whole_path=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Define a list of path pairs in the format "source:destination"; Files and directories allowed
path_pairs=(
  "$HOME/.config/alacritty/alacritty.yml:./.config/alacritty/alacritty.yml" # Alacritty
  "$HOME/.config/conda/condarc:./.config/conda/condarc"                     # Conda
  "$HOME/.config/nvim/init.lua:./.config/nvim/init.lua"                     # Nvim
  "$HOME/.config/nvim/lua/custom:./.config/nvim/lua/custom"
  "$HOME/.config/lsd/config.yaml:./.config/lsd/config.yaml"                 # LSD
  "$HOME/.config/tmux/tmux.conf:./.config/tmux/tmux.conf"                   # Tmux
  "$HOME/.config/tmux/gitmux.conf:./.config/tmux/gitmux.conf"
  "$HOME/.config/zsh/.zshrc:./.config/zsh/.zshrc"                           # zsh
  "/etc/zshenv:./etc/zshenv"
  "$HOME/.gitconfig:./.gitconfig"                                           # git
  "$HOME/.config/glow/glow.yml:./.config/glow/glow.yml"                     # glow
  "$HOME/.config/zsh/oh-my-zsh/custom/themes/customized-bira.zsh-theme:./.config/zsh/oh-my-zsh/custom/themes/customized-bira.zsh-theme"
  "$HOME/.local/bin/ansi_colors:./ansi_colors"
)

ask_yes_no() {
    local question="$1"
    local default="${2:-yes}"  # Default value is "yes" if not provided

    while true; do
        read -p "$question (yes/no) [$default]: " response
        case "$response" in
            [Yy]*)
                return 0  # Yes
                ;;
            [Nn]*)
                return 1  # No
                ;;
            *)
                if [ -z "$response" ]; then
                    # Default value
                    return 0  # Yes
                else
                    echo "Please answer 'yes' or 'no'."
                fi
                ;;
        esac
    done
}


# Tell what happens and wait for keyboard interrupt
if [ "$swap" = true ]; then
  echo -e "Starting copying ${BGREEN}out${NC} of the dotfiles repository"
else
  echo -e "Starting copying ${BGREEN}into${NC} the dotfiles repository"
fi

if ! ask_yes_no "Do you want to continue?"; then
    exit 1
fi

# Iterate over the path pairs and copy the contents of the source to the destination
for pair in "${path_pairs[@]}"; do
    # Split the pair into source and destination using ":" as a delimiter
    IFS=':' read -ra pair_parts <<< "$pair"

    # Determine source and destination paths based on the CLI flag
    if [ "$swap" = true ]; then
        source_path="${pair_parts[1]}"
        dest_path="${pair_parts[0]}"
    else
        source_path="${pair_parts[0]}"
        dest_path="${pair_parts[1]}"
    fi

    # Check if the source path exists
    if [ -e "$source_path" ]; then
        filename=$source_path
        if [ "$whole_path" = false ]; then
          filename="${filename##*/}"
        fi
        echo -ne "[${YELLOW}Copying${NC}] ${NC}$filename${NC}..."
        errormsg=$(cp -r --no-target-directory "$source_path" "$dest_path" 2>&1) # 2> /dev/null
        if [ $? == 0 ]; then
          echo -e "\r[${BGREEN}Copied${NC}] ${NC}$filename${NC}$(tput el)"
        else
          echo -e "\r[${RED}FAILED${NC}] ${NC}$filename${NC}$(tput el): ${BRED}${errormsg}${NC}"
        fi
    else
        echo -e "[${RED}ERROR${NC}] Source path ${YELLOW}$source_path${NC} does not exist."
    fi
done

exit 0

