set -g -x fish_greeting ''
oh-my-posh --init --shell fish --config ~/.config/oh-my-posh/viper_mod.omp.json | source
export GREP_OPTIONS='--color=always'
export DOTFILES_DIR=$HOME/.dotfiles

function dot_install
  command pwsh $DOTFILES_DIR/dotbot.ps1 -c $DOTFILES_DIR/install-arch.yaml
  command xrdb -merge $HOME/.Xresources
end

alias alas="adb devices && source $HOME/AzurLaneAutoScript/venv/bin/activate.fish && python $HOME/AzurLaneAutoScript/alas_en.pyw"



# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end
