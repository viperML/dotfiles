Import-Module PSReadLine

Set-PSReadlineOption -BellStyle None
Set-PSReadlineKeyHandler -Key Tab -Function Complete

Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord

Remove-PSReadLineKeyHandler -Chord "ctrl+v"
# Remove-PSReadLineKeyHandler -Chord "ctrl+v" -ViMode Command

$ESC = [char]27

function prompt {
    Write-Host "$ESC[96m$pwd$ESC[0m" -NoNewline
    Write-Host

    return "> "
}
