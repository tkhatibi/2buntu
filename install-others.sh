#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

TEMP_DIR="$DIR/temp"

main() {
    output-audio-switcher/install.sh

    __add_repositories

    sudo apt-get update

    sudo apt-get install \
        gnome-keyring \
        spotify-client \
        stacer \
        nordvpn \
        tor \
        aria2 \
        vokoscreen \
        peek \
        vlc \
        uget \
        qbittorrent \
        -y

    sudo usermod -aG nordvpn $USER

    if ! [ -x "$(command -v nvidia-xconfig)" ]; then
        sudo ubuntu-drivers autoinstall
    fi

    if ! [ -x "$(command -v code)" ]; then
        sudo snap install code --classic
    fi

    sudo snap install telegram-desktop

    sudo snap install postman

    if ! [ -x "$(command -v yarn)" ]; then
        __install_nvm_node_yarn
    fi

    __install_v2ray

    __install_remote_deb atomic https://atomicwallet.io/download/atomicwallet.deb

    __install_remote_deb skypeforlinux https://go.skype.com/skypeforlinux-64.deb

    __install_remote_deb slack https://downloads.slack-edge.com/releases/linux/4.20.0/prod/x64/slack-desktop-4.20.0-amd64.deb

    __install_remote_deb stremio https://dl.strem.io/shell-linux/v4.4.137/stremio_4.4.137-1_amd64.deb

    __install_flatpak

    __install_docker
}

__add_repositories() {
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

    __install_remote_deb nord https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
}

__install_remote_deb() {
    if ! [ -x "$(command -v ${1})" ]; then
        mkdir -p $TEMP_DIR
        TEMP_FILE="$TEMP_DIR/${1}.deb"
        if [[ ! -f $TEMP_FILE ]]; then
            wget -O "$TEMP_FILE" ${2}
        fi
        sudo apt-get install "$TEMP_FILE" -y
    fi
}

__install_flatpak() {
    sudo apt-get install flatpak -y

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

__install_nvm_node_yarn() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh

    echo "" >> ~/.zshrc
    echo "" >> ~/.bashrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm' >> ~/.bashrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >> ~/.bashrc

    nvm install --lts

    # nvm alias default node

    npm install --global yarn
}

__install_v2ray() {
    QV2RAY_PATH="$HOME/Apps/Qv2ray.AppImage"
    VCORE_DIR_PATH="$HOME/.config/qv2ray/vcore"
    VCORE_ZIP_PATH="$VCORE_DIR_PATH/vcore.zip"

    if ! [ -f $QV2RAY_PATH ]; then
        wget -O "$QV2RAY_PATH" https://github.com/Qv2ray/Qv2ray/releases/download/v2.7.0/Qv2ray-v2.7.0-linux-x64.AppImage

        chmod +x "$QV2RAY_PATH"
    fi

    if ! [ -d $VCORE_DIR_PATH ]; then
        mkdir -p $VCORE_DIR_PATH

        wget -O "$VCORE_ZIP_PATH" https://github.com/v2fly/v2ray-core/releases/download/v4.42.2/v2ray-linux-64.zip

        unzip "$VCORE_ZIP_PATH" -d "$VCORE_DIR_PATH"

        rm -f "$VCORE_ZIP_PATH"
    fi
}

__install_docker() {
    if ! [ -x "$(command -v docker)" ]; then
        sudo sh -c "$(curl -fsSL https://get.docker.com)"

        sudo groupadd docker

        sudo usermod -aG docker $USER
    fi

    if ! [ -x "$(command -v docker-compose)" ]; then
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        sudo chmod +x /usr/local/bin/docker-compose
    fi

    newgrp docker
}

__get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' | # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' # Pluck JSON value
}

# main
    if ! [ -f "./.zshrc" ]; then
        echo 'oops'
    fi

    # if ! [ -x "$(command -v docker-compose)" ]; then
    # fi