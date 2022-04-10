#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$DIR/../notify.sh"

# CURRENT_PROFILE=$(pacmd list-cards | grep "active profile" | cut -d ' ' -f 3-)

main() {
    CURRENT_PORT=$(pacmd list-sinks | grep "active port"| cut -d ' ' -f 3-)
    HEADPHONES_PORT="analog-output-headphones"
    LINEOUT_PORT="analog-output-lineout"
    SINK=$(pacmd list-sinks | grep "* index: ")
    SINK=${SINK: -1}

    if [ "$CURRENT_PORT" = "<$HEADPHONES_PORT>" ]; then
        echo "Switching to $LINEOUT_PORT"
        pacmd set-sink-port $SINK $LINEOUT_PORT
        # adjust als amixer
        amixer -c 0 set 'Auto-Mute Mode' 'Disabled'
        amixer set Master unmute
        amixer set Front unmute
        amixer set Surround unmute
        amixer set Center unmute
        amixer set LFE unmute
        TITLE="Output Audio Switcher" MESSAGE="Switched to $LINEOUT_PORT" notify
    else 
        echo "Switching to $HEADPHONES_PORT"
        pacmd set-sink-port $SINK $HEADPHONES_PORT
        amixer -c 0 set 'Auto-Mute Mode' 'Line Out+Speaker'
        TITLE="Output Audio Switcher" MESSAGE="Switched to $HEADPHONES_PORT" notify
    fi
}

main
