{ config, pkgs, ... }:

{
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
    androidStudioPackages.beta
  ];
  users.groups.libvirtd.members = config.users.groups.wheel.members;
}
