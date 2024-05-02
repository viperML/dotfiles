{
  boot.binfmt.emulatedSystems = ["x86_64-windows"];

  environment.sessionVariables.WINEPREFIX = "$HOME/.local/state/wine64";
}
