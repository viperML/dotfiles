#!/bin/sh
# code --list-extensions | jq -R -s 'split("\n")' >
cwd="$(dirname $0)"
xargs -n1 code --install-extension < "$cwd/extensions"
