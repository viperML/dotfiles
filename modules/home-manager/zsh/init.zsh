#!/usr/bin/env zsh
zstyle ':completion:*' menu select

bindkey -e
bindkey "^H" backward-kill-word
bindkey "^[[1;5C" emacs-forward-word
bindkey "^[[1;5D" emacs-backward-word

# insert-last-word-forward() zle insert-last-word 1
# zle -N insert-last-word-forward
# bindkey "^[[A" insert-last-word-forward
# bindkey "^[[A" up-line-or-beginning-search # Up
# bindkey "^[[B" down-line-or-beginning-search # Down
autoload -Uz copy-earlier-word
zle -N copy-earlier-word
bindkey "^[m" copy-earlier-word

# https://superuser.com/questions/1580099/reverse-scrolling-through-the-last-argument-of-command-in-zsh
insert-next-word() {
  zle insert-last-word -- 1
}
zle -N insert-next-word
bindkey '^[;' insert-next-word
