Get-Content $PSScriptRoot\extensions | ForEach-Object { vscodium --install-extension $_}
