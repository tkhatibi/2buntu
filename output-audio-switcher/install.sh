#!/bin/bash

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

APPLICATIONS_DIR="$HOME/.local/share/applications"

SHORTCUT_NAME="output-audio-switcher.desktop"

if [[ -f $APPLICATIONS_DIR ]]; then
    rm -f $APPLICATIONS_DIR
fi

mkdir -p $APPLICATIONS_DIR

cp $DIR/$SHORTCUT_NAME $APPLICATIONS_DIR

sed -i "s|./|$DIR/|g" "$APPLICATIONS_DIR/$SHORTCUT_NAME"
