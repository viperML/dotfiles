#!/usr/bin/env zsh
unsetopt BEEP
unsetopt autocd

export WORDCHARS='*?_-.[]~=&;!$%^(){}<>'

for prefix in /usr/share/zsh /nix/var/nix/profiles/per-user/ayats/profile/share/zsh; do
    fpath+=($prefix/site-functions $prefix/$ZSH_VERSION/functions $prefix/vendor-completions)
done

setopt HIST_FCNTL_LOCK
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$ZSH_CACHE/histfile"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
