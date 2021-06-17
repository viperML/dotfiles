set -g -x fish_greeting ''
oh-my-posh --init --shell fish --config ~/.config/oh-my-posh/viper.omp.json | source


# Variables
export GREP_OPTIONS='--color=always'
export DOTFILES_DIR=$HOME/.dotfiles
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Aliases
alias alas="GTK_THEME=Adwaita $HOME/Documents/AzurLaneAutoScript/venv/bin/python $HOME/Documents/AzurLaneAutoScript/alas_en.pyw"
alias ip="ip -c=auto"
alias ls="lsd"
alias svim="sudoedit"
alias pat="$PAGER"
#alias pp="paru"
#alias n="nvim"

# Abbreviations
if status --is-interactive
    # abbr --add --global hc herbstclient
    abbr --add --global dotinstall ~/.dotfiles/dotbot.sh -c ~/.dotfiles/install-arch.yaml
    abbr --add --global p python
    abbr --add --global n nvim
    abbr --add --global x xdg-open
    abbr --add --global ss sudo systemctl
    abbr --add --global us systemctl --user
    abbr --add --global se sudo -E systemctl edit
    # abbr --add --global c codium
    abbr --add --global pp paru
end

# Fix ssh passing wrong $TERM
function ssh
  begin; set -lx TERM xterm-256color; command ssh $argv; end
end

switch $TERM
    case 'st-*' # suckless' simple terminal
                # Enable keypad, do it once before fish_postexec ever fires
        tput smkx
        function st_smkx --on-event fish_postexec
            tput smkx
        end
        function st_rmkx --on-event fish_preexec
            tput rmkx
        end
end
