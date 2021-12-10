#!/bin/sh
cwd="$(dirname $0)"
xargs -n1 code --install-extension < "$cwd/extensions"
