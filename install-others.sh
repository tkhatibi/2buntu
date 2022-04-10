#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$DIR/notify.sh"

TEMP_DIR="$DIR/temp"

LOCAL_DIR="$DIR/local"

APPS_DIR="$HOME/Apps"

main() {
    output-audio-switcher/install.sh

    nordvpn-switcher/install.sh

    __install_local_deb_packages

    __install_local_app_images

    __install_apt_packages

    __install_remote_deb_packages

    if ! [ -x "$(command -v nvidia-xconfig)" ]; then
        sudo ubuntu-drivers autoinstall

        TITLE="Nvidia Drivers" MESSAGE="Installed successfully" notify
    fi

    __install_snap_packages

    __install_nvm_node_yarn

    __install_v2ray

    # TODO: error: Can't load uri https://flathub.org/repo/flathub.flatpakrepo: Unacceptable TLS certificate
    __install_flatpak

    __install_docker
}

__install_local_deb_packages() {
    if [ -d $LOCAL_DIR ]; then
        for package in $LOCAL_DIR/*.deb; do
            sudo apt-get install "$package" -y

            TITLE="Local Deb Package" MESSAGE="$package installed successfully" notify
        done
    fi
}

__install_local_app_images() {
    if [ -d $LOCAL_DIR ]; then
        for package in $LOCAL_DIR/*.AppImage; do
            cp $package $APPS_DIR

            TITLE="Local App Image" MESSAGE="$package copied successfully" notify
        done
    fi
}

__install_apt_packages() {
    __install_remote_deb_package nord https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb

    sudo apt-get update

    __install_apt_package nordvpn
    sudo usermod -aG nordvpn $USER

    __install_apt_package gnome-keyring

    __install_apt_package stacer

    __install_apt_package vim
    __install_apt_package neovim

    __install_apt_package ddccontrol
    __install_apt_package gddccontrol

    __install_apt_package tor

    __install_apt_package aria2

    __install_apt_package vokoscreen

    __install_apt_package peek

    __install_apt_package vlc

    __install_apt_package uget

    __install_apt_package qbittorrent
}

__install_apt_package() {
    if ! [ -x "$(command -v ${1})" ]; then
        sudo apt-get install ${@:1} -y

        TITLE="apt-get" MESSAGE="${1} Installed successfully" notify
    fi
}

__install_remote_deb_packages() {
    __install_remote_deb_package spotify http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.1.68.632.g2b11de83_amd64.deb

    __install_remote_deb_package telegram-desktop http://archive.ubuntu.com/ubuntu/pool/universe/t/telegram-desktop/telegram-desktop_2.0.1+ds-1build1_amd64.deb

    __install_remote_deb_package skypeforlinux https://go.skype.com/skypeforlinux-64.deb

    __install_remote_deb_package slack https://downloads.slack-edge.com/releases/linux/4.20.0/prod/x64/slack-desktop-4.20.0-amd64.deb

    __install_remote_deb_package stremio https://dl.strem.io/shell-linux/v4.4.137/stremio_4.4.137-1_amd64.deb

    __install_remote_deb_package atomic https://atomicwallet.io/download/atomicwallet.deb
}

__install_remote_deb_package() {
    if ! [ -x "$(command -v ${1})" ]; then
        mkdir -p $TEMP_DIR
        TEMP_FILE="$TEMP_DIR/${1}.deb"
        if [[ ! -f $TEMP_FILE ]]; then
            wget -O "$TEMP_FILE" ${2}
        fi
        sudo apt-get install "$TEMP_FILE" -y

        TITLE="Remote Deb Package" MESSAGE="$package isntalled successfully" notify
    fi
}

__install_snap_packages() {
    __install_snap_package code --classic

    __install_snap_package postman
}

__install_snap_package() {
    if ! [ -x "$(command -v ${1})" ]; then
        sudo snap install ${@:1}

        TITLE="Snap Package" MESSAGE="${1} installed successfully" notify
    fi
}

__install_flatpak() {
    sudo apt-get install flatpak -y

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

__install_flatpack_packages() {
    __install_flatpack_package fr.handbrake.ghb
}

__install_flatpack_package() {
    if ! [ -x "$(command -v ${1})" ]; then
        flatpak install flathub ${@:1} -y

        TITLE="Flatpack Package" MESSAGE="${1} installed successfully" notify
    fi
}

__install_nvm_node_yarn() {
    if ! [ -x "$(command -v nvm)" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh

        echo "" >> ~/.zshrc
        echo "" >> ~/.bashrc
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
        echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> ~/.zshrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> ~/.bashrc

        if [ $SHELL = "/bin/bash" ]; then
            source ~/.bashrc
        else
            source ~/.zshrc
        fi

        TITLE="NVM" MESSAGE="nvm installed successfully" notify
    fi

    if ! [ -x "$(command -v npm)" ]; then
        nvm install --lts

        # nvm alias default node

        TITLE="NVM" MESSAGE="node and npm installed successfully" notify
    fi


    if ! [ -x "$(command -v npm)" ]; then
        npm install --global yarn

        TITLE="NVM" MESSAGE="yarn installed successfully" notify
    fi
}

__install_v2ray() {
    QV2RAY_PATH="$APPS_DIR/Qv2ray.AppImage"
    VCORE_DIR_PATH="$HOME/.config/qv2ray/vcore"
    VCORE_ZIP_PATH="$VCORE_DIR_PATH/vcore.zip"

    if ! [ -f $QV2RAY_PATH ]; then
        wget -O "$QV2RAY_PATH" https://github.com/Qv2ray/Qv2ray/releases/download/v2.7.0/Qv2ray-v2.7.0-linux-x64.AppImage

        chmod +x "$QV2RAY_PATH"

        TITLE="v2ray" MESSAGE="Qv2ray installed successfully" notify
    fi

    if ! [ -d $VCORE_DIR_PATH ]; then
        mkdir -p $VCORE_DIR_PATH

        wget -O "$VCORE_ZIP_PATH" https://github.com/v2fly/v2ray-core/releases/download/v4.42.2/v2ray-linux-64.zip

        unzip "$VCORE_ZIP_PATH" -d "$VCORE_DIR_PATH"

        rm -f "$VCORE_ZIP_PATH"

        TITLE="v2ray" MESSAGE="v2ray-core installed successfully" notify
    fi
}

__install_docker() {
    if ! [ -x "$(command -v docker)" ]; then
        sudo sh -c "$(curl -fsSL https://get.docker.com)"

        sudo groupadd docker

        sudo usermod -aG docker $USER

        TITLE="Docker" MESSAGE="installed successfully" notify
    fi

    if ! [ -x "$(command -v docker-compose)" ]; then
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        sudo chmod +x /usr/local/bin/docker-compose

        TITLE="Docker Compose" MESSAGE="installed successfully" notify
    fi

    newgrp docker
}

__get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' | # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' # Pluck JSON value
}

main
