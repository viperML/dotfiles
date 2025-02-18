#! /usr/bin/env bash
set -eux

tee .envrc <<EOF
path_add GUIX_PACKAGE_PATH $(pwd)
EOF

