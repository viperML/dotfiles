$ErrorActionPreference = "Stop"

# $CONFIG = $Args[0] + "-win.yaml"
$DOTBOT_DIR = "dotbot"

$DOTBOT_BIN = "bin/dotbot"
$BASEDIR = $PSScriptRoot

Set-Location $BASEDIR
git -C $DOTBOT_DIR submodule sync --quiet --recursive
git submodule update --init --recursive $DOTBOT_DIR

$DOTFILES_DIR = "C:\Users\ayats\.dotfiles"

# Invoke-Expression $(Join-Path -Path $DOTFILES_DIR -ChildPath 'dotfiles_priv\Export-Chocolatey.ps1')

foreach ($PYTHON in ('python', 'python3', 'python2')) {
    # Python redirects to Microsoft Store in Windows 10 when not installed
    if (& { $ErrorActionPreference = "SilentlyContinue"
            ![string]::IsNullOrEmpty((&$PYTHON -V))
            $ErrorActionPreference = "Stop" }) {
        &$PYTHON $(Join-Path $BASEDIR -ChildPath $DOTBOT_DIR | Join-Path -ChildPath $DOTBOT_BIN) -d $BASEDIR $Args
        return
    }
}
Write-Error "Error: Cannot find Python."
