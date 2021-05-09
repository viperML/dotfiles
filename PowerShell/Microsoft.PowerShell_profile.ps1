Invoke-Expression (oh-my-posh --init --shell pwsh --config ~\.config\oh-my-posh\viper.omp.json)
Set-PSReadLineOption -predictionsource history
Function Function1 {Set-Location ~\Documents\aurea_test1\jsbsim\ && conda activate aurea && Clear-Host}
Set-Alias -Name pyaurea -Value Function1
$env:FLASK_ENV="development"
$env:GREP_OPTIONS = '--color=always'