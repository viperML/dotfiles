#!/usr/bin/env zsh
unsetopt BEEP

export WORDCHARS='*?_-.[]~=&;!$%^(){}<>'

for prefix in /usr/share/zsh /nix/var/nix/profiles/per-user/ayats/profile/share/zsh; do
    fpath+=($prefix/site-functions $prefix/$ZSH_VERSION/functions $prefix/vendor-completions)
done
