{ config, pkgs, ... }:

{
  services.plex = {
    enable = true;
    managePlugins = false;
  };
}
