autoload -U compinit; compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _expand _complete _match _ignored
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh-compcache"
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
# zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-suffixes true

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
