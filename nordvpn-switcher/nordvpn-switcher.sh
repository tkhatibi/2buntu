#!/bin/bash

STATUS=$(nordvpn status)

echo $STATUS

if [[ "$STATUS" =~ 'Status: Disconnected' ]]; then
    echo 'Connecting...'
    nordvpn set firewall on
    nordvpn set killswitch on
    nordvpn c
else
    echo 'Disconnecting...'
    nordvpn d
    nordvpn set killswitch off
    nordvpn set firewall off
fi
