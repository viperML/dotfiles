{ config, pkgs, ... }:

{
  services.modded-minecraft-servers = {
    eula = true;

    myserver = {
      enable = true;

      serverConfig = {
        server-port = 25566;
      };
    };
  };
}
