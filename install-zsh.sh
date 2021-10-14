#!/bin/bash

sudo apt-get install zsh -y

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    cp .zshrc ~/.zshrc

    source ~/.zshrc

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    sed -i 's|# source $ZSH/oh-my-zsh.sh|source $ZSH/oh-my-zsh.sh|g' ~/.zshrc
fi
