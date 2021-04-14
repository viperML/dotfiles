Import-Module oh-my-posh
Set-PoshPrompt -Theme "~\.config\oh-my-posh\viper.omp.json"
Set-PSReadLineOption -predictionsource history
Function Function1 {Set-Location ~\Documents\aurea_test1\jsbsim\ && conda activate aurea && Clear-Host}
Set-Alias -Name pyaurea -Value Function1
$env:FLASK_ENV="development"
Import-Module -Name Terminal-Icons
$env:GREP_OPTIONS = '--color=always'