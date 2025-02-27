#! /usr/bin/env bash

eval "$(starship init bash)"

spack() {
    loc="$HOME/spack/master/share/spack/setup-env.sh"
    echo ":: source $loc"
    source "$loc"
    spack "$@"
}
