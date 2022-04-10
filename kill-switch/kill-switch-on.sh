#!/bin/bash

# see https://thetinhat.com/tutorials/misc/linux-vpn-drop-protection-firewall.html

sudo ufw reset
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw allow out on tun0 from any to any
sudo ufw enable
