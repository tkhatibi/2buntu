#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

APPLICATIONS_DIR="$HOME/.local/share/applications"

SHORTCUT_NAME="output-audio-switcher.desktop"

cp $DIR/$SHORTCUT_NAME $APPLICATIONS_DIR

sed -i "s|./|$DIR/|g" "$APPLICATIONS_DIR/$SHORTCUT_NAME"
