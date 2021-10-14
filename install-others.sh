#!/bin/bash

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

    sudo ubuntu-drivers autoinstall

    sudo snap install code --classic

    sudo snap install telegram-desktop

    sudo snap install postman

    __install_nvm_node_yarn

    __install_v2ray

    __install_remote_deb https://atomicwallet.io/download/atomicwallet.deb

    __install_remote_deb https://go.skype.com/skypeforlinux-64.deb

    __install_remote_deb https://downloads.slack-edge.com/releases/linux/4.20.0/prod/x64/slack-desktop-4.20.0-amd64.deb

    __install_remote_deb https://dl.strem.io/shell-linux/v4.4.137/stremio_4.4.137-1_amd64.deb

    __install_flatpak

    __install_docker
}

__add_repositories() {
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

    __install_remote_deb https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb
}

__install_remote_deb() {
    TEMP_FILE="$(mktemp).deb"
    wget -O "$TEMP_FILE" ${1}
    sudo apt-get install "$TEMP_FILE" -y
    rm -f "$TEMP_FILE"
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

    wget -O "$QV2RAY_PATH" https://github.com/Qv2ray/Qv2ray/releases/download/v2.7.0/Qv2ray-v2.7.0-linux-x64.AppImage

    chmod +x "$QV2RAY_PATH"

    mkdir -p $VCORE_DIR_PATH

    wget -O "$VCORE_ZIP_PATH" https://github.com/v2fly/v2ray-core/releases/download/v4.42.2/v2ray-linux-64.zip

    unzip "$VCORE_ZIP_PATH" -d "$VCORE_DIR_PATH"

    rm -f "$VCORE_ZIP_PATH"
}

__install_docker() {
    sudo sh -c "$(curl -fsSL https://get.docker.com)"

    sudo groupadd docker

    sudo usermod -aG docker $USER

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    sudo chmod +x /usr/local/bin/docker-compose

    newgrp docker
}

__get_latest_release() {
    curl --silent "https://api.github.com/repos/$1/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' | # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/' # Pluck JSON value
}

main
