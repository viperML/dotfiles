set -g -x fish_greeting ''
oh-my-posh --init --shell fish --config ~/dotfiles/Windows/PowerShell/viper_mod.omp.json | source

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /home/ayats/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# GWSL
set --export WSL2 1
set ipconfig_exec (wslpath "C:\\Windows\\System32\\ipconfig.exe")
if which ipconfig.exe >/dev/null
    set ipconfig_exec (which ipconfig.exe)
end

set wsl2_d_tmp (eval $ipconfig_exec | grep -n -m 1 "Default Gateway.*: [0-9a-z]" | cut -d : -f 1)
if test -n "$wsl2_d_tmp"
    set first_line (expr $wsl2_d_tmp - 4)
    set wsl2_d_tmp (eval $ipconfig_exec | sed $first_line,$wsl2_d_tmp!d | grep IPv4 | cut -d : -f 2 | sed -e "s|\s||g" -e "s|\r||g")
    set --export DISPLAY "$wsl2_d_tmp:0"
    set -e first_line
else
    set --export DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
end

set -e wsl2_d_tmp
set -e ipconfig_exec
