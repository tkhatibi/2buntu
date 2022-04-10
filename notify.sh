#!/bin/bash

notify() {
    if [ -x "$(command -v zenity)" ]; then
        zenity --notification --text "$MESSAGE"
    elif [ -x "$(command -v kdialog)" ]; then
        kdialog --title "$TITLE" --passivepopup "$MESSAGE"
    fi
}
