{ config
, pkgs
, ...
}:
{
  programs.steam.enable = true;

  environment.systemPackages =
    with pkgs; [
      steam-run-native
      # lutris
      ryujinx
    ];
}
