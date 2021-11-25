#!/bin/bash

STATUS=$(nordvpn status)

echo $STATUS

if [[ "$STATUS" =~ 'Status: Disconnected' ]]; then
    echo 'Connecting...'
    nordvpn c Cyprus
else
    echo 'Disconnecting...'
    nordvpn d
fi
