Set-PSReadLineOption -PredictionSource History
$Env:DOTFILES = "C:\Users\ayats\Documents\dotfiles"
$Env:STARSHIP_CONFIG = "$Env:DOTFILES\packages\overrides\vshell\starship.toml"
Invoke-Expression (&starship init powershell)
