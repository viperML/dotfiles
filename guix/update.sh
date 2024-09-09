#! /usr/bin/env bash
set -eux

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"

guix time-machine \
    -C "$dir/channels.scm" \
    -q \
    -- \
    describe -f channels \
    > "$dir/channels.locked.scm"
