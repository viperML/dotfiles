# zstyle ':completion:*' menu select
# zstyle ':completion:*' completer _expand _complete _match _ignored
# zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# # zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' list-suffixes true

# https://superuser.com/questions/1586405/zsh-autocomplete-if-only-one-suggestion
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-/]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh-compcache"
zstyle :compinstall filename "$XDG_CACHE_HOME/zsh-compinstall"

autoload -Uz compinit
compinit

bindkey '^I' complete-word

setopt completealiases
alias n='nvim'

alias ls="exa --icons"
alias la="exa --icons --all"
alias ll="exa --icons --long --header --group"
alias lla="exa --icons --all --long --header --group"
alias lal="exa --icons --all --long --header --group"
alias lt="exa --sort modified -1"

alias ip="ip -c=auto"
alias svim="sudoedit"
