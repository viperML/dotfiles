# Keybinds
bindkey -e # Set emacs mode
insert-next-word() { zle insert-last-word -- 1 } # Tell `insert-last-word` to go forward (1), instead of backward (-1).
zle -N insert-next-word # Create a widget that calls the function above.
bindkey '3A' insert-last-word # Alt+Up fill history
bindkey '3B' insert-next-word # Alt+Down do the opposite
bindkey '3D' backward-word # Move between words
bindkey '3C' forward-word # Move between words
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>' # Removed / bc it separates words

source /usr/share/zsh/scripts/zplug/init.zsh # ZPLUG installed through AUR

# History config
export HISTFILE=~/.cache/zsh/zsh_history # Where it gets saved
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history # Don't overwrite, append!
setopt INC_APPEND_HISTORY # Write after each command
#setopt hist_expire_dups_first # Expire duplicate entries first when trimming history
#setopt hist_ignore_all_dups # Delete old recorded entry if new entry is a duplicate.
setopt hist_fcntl_lock # use OS file locking
setopt hist_lex_words # better word splitting, but more CPU heavy
setopt hist_reduce_blanks # Remove superfluous blanks before recording entry.
setopt hist_save_no_dups # Don't write duplicate entries in the history file.
setopt share_history # share history between multiple shells
setopt HIST_IGNORE_SPACE # Don't record an entry starting with a space.


# Fish-like autocompletions
ZSH_AUTOSUGGEST_STRATEGY=(match_prev_cmd completion) # Recommend first history matches
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions", defer:2 # Complete some random commands
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _approximate _expand_alias
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "~/.cache/zsh/zsh_completion_cache"
    # Message styles
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
setopt globdots # Include .files in completion
zstyle ':completion:*' squeeze-slashes true # Change // to /


# z
zplug "agkozak/zsh-z"

# Automatic double quotes
zplug "hlissner/zsh-autopair", defer:2

# Abreviations and aliases
ABBR_USER_ABBREVIATIONS_FILE=$ZDOTDIR/abbr
zplug "olets/zsh-abbr"
alias pat="$PAGER"
alias svim="sudoedit"
alias ls="lsd"
alias lt="ls -t"
alias la="ls -a -l"
alias ll="ls -l"
alias ip="ip -c=auto"

# Git aliases
zplug "mdumitru/git-aliases", defer:2

# Suggest all the aliases
zplug "djui/alias-tips"

# Theme file
# zplug "dracula/zsh", as:theme
eval "$(oh-my-posh --init --shell zsh --config $DOTDIR/oh-my-posh/viper.omp.json)"


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load




# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search
