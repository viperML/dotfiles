set -g -x fish_greeting ''
oh-my-posh --init --shell fish --config ~/.config/oh-my-posh/viper_mod.omp.json | source
export GREP_OPTIONS='--color=always'



# pyenv init
if command -v pyenv 1>/dev/null 2>&1
  pyenv init - | source
end
