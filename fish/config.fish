set -g -x fish_greeting ''
oh-my-posh --init --shell fish --config ~/.config/oh-my-posh/viper.omp.json | source


# Variables
export GREP_OPTIONS='--color=always'
export DOTFILES_DIR=$HOME/.dotfiles
export VIRTUAL_ENV_DISABLE_PROMPT=true

# Aliases
alias alas="adb devices && source $HOME/AzurLaneAutoScript/venv/bin/activate.fish && GTK_THEME=Adwaita python $HOME/AzurLaneAutoScript/alas_en.pyw"
alias icat="kitty +kitten icat"
alias ip="ip -c=auto"

if status --is-interactive
    abbr --add --global hc herbstclient
    abbr --add --global dot_install ~/.dotfiles/dotbot.sh -c ~/.dotfiles/install-arch.yaml
    abbr --add --global p python
end

# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end

function lsimg
  for file in (ls $argv)
    kitty +kitten icat $argv/$file
  end
end
