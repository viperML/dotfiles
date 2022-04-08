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
  env = {
  FLAKE = "/mnt/c/Users/ayats/Documents/dotfiles";
  GDK_DPI_SCALE = "1.5";
  QT_QPA_PLATFORM="wayland";
  DONT_PROMPT_WSL_INSTALL = "1";
  };
in {
  environment.variables = env;
  environment.sessionVariables = env;
  home-manager.users.ayats = _: {
    home.sessionVariables = env;
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
