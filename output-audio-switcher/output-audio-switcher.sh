#!/bin/bash

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
        __notify "Switched to $LINEOUT_PORT"
    else 
        echo "Switching to $HEADPHONES_PORT"
        pacmd set-sink-port $SINK $HEADPHONES_PORT
        amixer -c 0 set 'Auto-Mute Mode' 'Line Out+Speaker'
        __notify "Switched to $HEADPHONES_PORT"
    fi
}

__notify() {
    if [ -x "$(command -v zenity)" ]; then
        zenity --notification --text ${@:1}
    elif [ -x "$(command -v kdialog)" ]; then
        kdialog --title "Output Audio Switcher" --passivepopup "${@:1}"
    fi
}

main
