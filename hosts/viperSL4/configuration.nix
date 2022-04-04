{
  lib,
  pkgs,
  config,
  modulesPath,
  self,
  packages,
  ...
}: let
  hn = "viperSL4";
  FLAKE = "/home/ayats/dotfiles";
in {
  environment.variables = {inherit FLAKE;};
  environment.sessionVariables = {inherit FLAKE;};
  home-manager.users.ayats = _: {
    home.sessionVariables = {inherit FLAKE;};
  };

  imports = [
    "${modulesPath}/profiles/minimal.nix"
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "ayats";
    startMenuLaunchers = true;

    wslConf.network.hostname = hn;
  };

  networking.hostName = hn;
}
