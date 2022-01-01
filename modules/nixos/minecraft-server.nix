{ config, pkgs, ... }:

{
  services.minecraft-server = {
    enable = true;
    eula = true;
  };
}
