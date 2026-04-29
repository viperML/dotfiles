{ config, pkgs, ... }:
{
  imports = [
    ./wayland-compositors.nix
  ];

  maid.sharedModules = [
    ../maid/hyprland
  ];

  programs.niri = {
    enable = true;
  };
}
