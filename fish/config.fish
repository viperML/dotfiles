set -g -x fish_greeting ''
oh-my-posh --init --shell fish --config ~/.config/oh-my-posh/arch.omp.json | source
export GREP_OPTIONS='--color=always'
export DOTFILES_DIR=$HOME/.dotfiles

alias dot_install="pwsh $DOTFILES_DIR/dotbot.ps1 -c $DOTFILES_DIR/install-arch.yaml"
alias ccat="highlight -O ansi"
alias alas="adb devices && source $HOME/AzurLaneAutoScript/venv/bin/activate.fish && python $HOME/AzurLaneAutoScript/alas_en.pyw"



# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end
