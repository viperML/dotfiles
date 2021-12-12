Set-PSReadLineOption -predictionsource history
$env:GREP_OPTIONS = '--color=always'
Invoke-Expression (&starship init powershell)
