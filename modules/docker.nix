{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    enableNvidia = true;
    extraOptions = "--registry-mirror=https://mirror.gcr.io --add-runtime crun=${pkgs.crun}/bin/crun --default-runtime=crun";
  };

  users.users.mainUser.extraGroups = [ "docker" ];
}
