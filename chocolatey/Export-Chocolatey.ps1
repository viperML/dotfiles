#You can install the packages using
# choco install packages.xml -y

#Write-Output "<?xml version=`"1.0`" encoding=`"utf-8`"?>" > packages.xml
#Write-Output "<packages>" >> packages.xml
# choco list -lo -r -y | % { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />" } >> packages.xml
# Write-Output "</packages>" >> packages.xml

Set-Content -Path $PSScriptRoot\packages.xml -Value ("<!-- choco install packages.xml -y -->")
Add-Content -Path $PSScriptRoot\packages.xml -Value ("<?xml version=`"1.0`" encoding=`"utf-8`"?>")
Add-Content -Path $PSScriptRoot\packages.xml -Value ("<packages>")
#Add-Content -Path $PSScriptRoot\packages.xml -Value (choco list -lo -r -y | % { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`" version=`"$($_.SubString($_.IndexOf("|") + 1))`" />" })
Add-Content -Path $PSScriptRoot\packages.xml -Value (choco list -lo -r -y | % { "   <package id=`"$($_.SubString(0, $_.IndexOf("|")))`"/>" })
Add-Content -Path $PSScriptRoot\packages.xml -Value ("</packages>")