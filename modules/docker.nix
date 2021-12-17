{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  users.users.ayats.extraGroups = [ "docker" ];
}
