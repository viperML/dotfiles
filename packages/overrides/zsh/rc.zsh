#!/usr/bin/env zsh
unsetopt BEEP

bindkey '^[^?' backward-kill-word

bindkey -r "^[[A"
bindkey -r "^[[B"
bindkey -r "^[[C"
bindkey -r "^[[D"
bindkey -r "^["

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey "^[[C" autosuggest-accept

export WORDCHARS='*?_-.[]~=&;!$%^(){}<>'


for prefix in /usr/share/zsh /nix/var/nix/profiles/per-user/ayats/profile/share/zsh; do
    fpath+=($prefix/site-functions $prefix/$ZSH_VERSION/functions $prefix/vendor-completions)
done
