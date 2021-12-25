Set-PSReadLineOption -predictionsource history
$env:GREP_OPTIONS = '--color=always'
Invoke-Expression (&starship init powershell)
$ENV:STARSHIP_CONFIG = "C:\Users\ayats\.dotfiles\fish\starship.toml"
