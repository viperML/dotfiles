set -g -x fish_greeting (echo -n "Welcome to "; set_color cyan; echo "Arch"; set_color normal)
oh-my-posh --init --shell fish --config ~/.config/oh-my-posh/viper.omp.json | source


# Variables
export GREP_OPTIONS='--color=always'
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Aliases
alias alas="GTK_THEME=Adwaita $HOME/Documents/AzurLaneAutoScript/venv/bin/python $HOME/Documents/AzurLaneAutoScript/alas_en.pyw & disown"
alias ip="ip -c=auto"
alias ls="lsd"
alias lt="lsd -t -r"
alias svim="sudoedit"
alias pat="$PAGER"

# Abbreviations
if status --is-interactive
    abbr --add --global p python
    abbr --add --global n nvim
    abbr --add --global x xdg-open
    abbr --add --global ss sudo systemctl
    abbr --add --global us systemctl --user
    abbr --add --global se sudo -E systemctl edit
end

# Fix ssh passing wrong $TERM
function ssh
  begin; set -lx TERM xterm-256color; command ssh $argv; end
end

function dotinstall
  $DOTDIR/dotbot.sh -c $DOTDIR/install-arch.yaml
  $PRIVDIR/dotbot.sh -c $PRIVDIR/install-arch.yaml
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

# After resetting fish, set again each color for each component
function set_colorscheme
    set fish_color_normal brwhite
    set fish_color_command green
    set fish_color_keyword brblue
    set fish_color_quote yellow
    set fish_color_redirection brwhite
    set fish_color_end brred
    set fish_color_error -o red
    set fish_color_param white
    set fish_color_comment brblack
    set fish_color_selection --background=brblack
    # set fish_color_selection cyan
    # set fish_color_search_match cyan
    set fish_color_search_match --background=brblack
    set fish_color_operator green
    set fish_color_escape brblue
    set fish_color_autosuggestion brblack

    # Completion Pager Colors
    set fish_pager_color_progress brblack
    set fish_pager_color_prefix green
    set fish_pager_color_completion white
    set fish_pager_color_description brblack
end

