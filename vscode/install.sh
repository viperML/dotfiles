#!/bin/sh
cwd="$(dirname $0)"
xargs -n1 code-oss --install-extension < "$cwd/extensions"
