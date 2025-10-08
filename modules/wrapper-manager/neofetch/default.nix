{ pkgs, ... }:
{
  wrappers.neofetch = {
    basePackage = pkgs.neofetch.override { x11Support = false; };
    prependFlags = [
      "--config"
      ./config.sh
      "--ascii"
      ./logo
    ];
  };
}
