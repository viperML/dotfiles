# Linux
xargs -n1 codium --install-extension < Code/extensions


# Windows
Get-Content $PSScriptRoot\extensions | ForEach-Object { code --install-extension $_}
