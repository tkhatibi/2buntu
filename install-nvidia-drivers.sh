#!/bin/bash

if ! [ -x "$(command -v nvidia-xconfig)" ]; then
    sudo ubuntu-drivers autoinstall
fi

# To chekc which device is being used for graphics: nvidia or intel
# prime-select query

# To change current graphic to intel
# sudo prime-select intel

# To check everything is fine
# nvidia-smi
