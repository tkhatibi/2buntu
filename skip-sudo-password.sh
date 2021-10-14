#!/bin/bash

sudo bash -c 'echo "$(logname) ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)'
