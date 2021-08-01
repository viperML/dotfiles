Invoke-Expression (oh-my-posh --init --shell pwsh --config ~\dotfiles\oh-my-posh\viper.omp.json)
Set-PSReadLineOption -predictionsource history
Function FnLSD {lsd}
Function FnLSA {lsd -a}
Function FnLSL {lsd -l -a}
Set-Alias -Name ls -Value FnLSD
Set-Alias -Name la -Value FnLSA
Set-Alias -Name ll -Value FnLSL
$env:GREP_OPTIONS = '--color=always'
#$env:DOTFILES_DIR=Join-Path -Path $env:USERPROFILE -ChildPath '.dotfiles'
