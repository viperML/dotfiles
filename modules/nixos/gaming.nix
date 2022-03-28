{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.steam.enable = true;

  environment.systemPackages = [
    pkgs.steam-run-native
    # pkgs.lutris
    # ryujinx
  ];
}
