{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    syncthingtray
    syncthing
  ];

  home.file.".config/autostart/syncthingtray.desktop".text = "${builtins.readFile ./syncthingtray.desktop}";
}
