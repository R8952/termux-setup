#!/bin/bash

export PRD=$(pwd)

source $PRD/support/colors.sh
source $PRD/support/functions.sh

banner "Updating App"
apt update -y && apt upgrade -y
success "Updation Complete"

askYN "Install Extra Packages?"
if [[ "$rsp" = "Y" || "$rsp" = "y" ]]; then
    pkg=( "exiftool" "gtypist" "gh" )
    ins "${pkg[@]}"
fi

askYN "Setup Laravel?"
if [[ "$rsp" = "Y" || "$rsp" =  "y" ]]; then
    composer global require laravel/installer
    echo "export PATH=\"$PATH:$HOME/.composer/vendor/bin\"" >> $HOME/.bash_config/environment_variables.sh
fi

askYN "Setup MariaDB?"
if [[ "$rsp" = "Y"  ||  "$rsp" = "y" ]]; then
    apt install mariadb -y
    echo -e "${CYAN}Enter ${YELLOW}mariadbd ${CYAN}to start the server."
    echo -e "And"
    echo -e "To enter the mariadb shell enter mariadb -u <username> -p"
    askYN "Create new User?"
    if [[ "$rsp" = "Y" || "$rsp" = "y" ]]; then
        read -p "Enter Username : " uname
        read -p "Enter Password : " password
        mariadb -u root -e "CREATE USER '$uname'@'localhost' IDENTIFIED BY '$password';"
        mariadb -u root -e "GRANT ALL PRIVILEGES ON *.* TO '$uname'@'localhost' WITH GRANT OPTION;"
        mariadb -u root -e "FLUSH PRIVILEGES;"
    fi
fi
