Import-Module oh-my-posh
Set-PoshPrompt -Theme "C:\Users\ayats\Documents\PowerShell\viper_mod.omp.json"
Set-PSReadLineOption -predictionsource history
Function Function1 {Set-Location C:\Users\ayats\Documents\aurea_test1\jsbsim\ && conda activate aurea && Clear-Host}
Function Function2 { adb forward tcp:8873 tcp:8873 && rsync -avPH --info=progress2 /cygdrive/x/Music rsync://localhost:8873/sdcard && adb forward --remove-all}
Set-Alias -Name pyaurea -Value Function1
Set-Alias -Name rcosas -Value Function2
$env:FLASK_ENV="development"
Import-Module -Name Terminal-Icons
$env:GREP_OPTIONS = '--color=always'