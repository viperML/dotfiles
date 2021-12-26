#!/bin/bash

if [[ -f $HOME/.config/latte/my-layout.layout.latte ]]; then
    latte-dock --layout my-layout
