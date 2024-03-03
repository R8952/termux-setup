#!/bin/bash

source colors.sh

ins() {
    package_list=("$@")
    echo -e "${PURPLE}"
    echo -e "≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈"
    echo -e "${NC}"
    for pkg in "${package_list[@]}";
    do
        if apt install $pkg -y; then
            echo -e "${GREEN}Installed : ${CYAN} $pkg ${NC}"
            echo -e "${PURPLE}"
            echo -e "≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈≈"
            echo -e "${NC}"
        else
            fail "Failed to install package : $pkg"
            exit 1
        fi
    done
}

success() {
    echo -e "${GREEN}"
    echo -e "$1"
    echo -e "${NC}"
    sleep 2s
}

fail() {
    echo -e "${RED}"
    echo -e "ABORTING"
    echo -e "${YELLOW}"
    echo -e "$1"
    echo -e "${NC}"
    sleep 2s
    exit 1
}

banner() {
    echo -e "${BLUE}"
    echo -e "<------------------------------>"
    echo -e " ) $1"
    echo -e "<------------------------------>"
    echo -e "${NC}"
    sleep 3s
}

rsp='n'
askYN() {
    read -p "$1 [Y/n] " rsp
}
