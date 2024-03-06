#!/bin/bash

export PRD=$(pwd)

# Add support colors in echo
source $PRD/support/colors.sh

# Contain Function
source $PRD/support/functions.sh

# <------------------------------>
#          Initial Setup
# <------------------------------>

termux-setup-storage

banner "Updating Packages"
apt update -y && apt upgrade -y
success "Updation Successful"

banner "Adding Repositories"
repos=( "x11-repo" "root-repo" "glibc-repo" "tur-repo")
ins "${repos[@]}"
success "Repositories added successfully"

# <------------------------------>
#       Installing Packages
# <------------------------------>


banner "Installing Packages"

pkg=(
    "termux-am-socket"
    "termux-x11-nightly" "xfce4" "gtk2" "gtk3" "tigervnc"
    "lsd" "vivid"
    "vim" "neovim" "kakoune" "helix"
    "c-script" "openjdk-17" "php" "composer" "python"
    "xfce4-taskmanager" "xfce4-appfinder"
    "neofetch"" htop"
    "net-tools" "wireless-tools"
    "man" "texinfo"
    "wget" "curl"
    "git" "firefox"
    "xfce-theme-manager" "papirus-icon-theme" "fluent-gtk-theme" "fluent-icon-theme"
    "7zip" "tmux" )

ins "${pkg[@]}"

success "Packages are installed successfully"

# <------------------------------>
#        VNC configuration
# <------------------------------>

if ! vncserver -list | grep -q '^:'; then
    vncserver
fi

# <------------------------------>
#    Copying dot(config) files
# <------------------------------>


cp -i dotfiles/.bashrc $HOME
cp -r -i dotfiles/.bash_config $HOME
cp -r -i dotfiles/.vnc $HOME
cp -r -i dotfiles/.termux $HOME

echo -e "${CYAN}"

if [[ ! -e $HOME/.themes ]]; then
    tar -xzvf dotfiles/themes.tar.gz -C $HOME
else
    echo -e "~/.themes already exists delete to overwrite"
fi

if [[ ! -e $HOME/.fonts ]]; then
    tar -xzvf dotfiles/fonts.tar.gz -C $HOME
else
    echo -e "~/.fonts already exists delete to overwrite"
fi

if [[ ! -e $HOME/.config ]]; then
    tar -xzvf dotfiles/config.tar.gz -C $HOME
else
    echo -e "~/.config already exists delete to overwrite"
fi

echo -e "${NC}"
