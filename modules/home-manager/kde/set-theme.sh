#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash libsForQt5.kconfig libsForQt5.full
set -ex

kwriteconfig5 --group General --key ColorScheme $1

# exec qdbus org.kde.KWin /KWin reconfigure
