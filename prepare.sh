#!/bin/bash

sudo bash -c 'echo "$(logname) ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'

sudo sed -i "s|http://ir.|http://de.|g" "/etc/apt/sources.list"

sudo apt-get update

sudo apt-get install network-manager-openvpn -y
