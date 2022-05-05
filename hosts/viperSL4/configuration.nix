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
    QT_QPA_PLATFORM = "wayland";
    DONT_PROMPT_WSL_INSTALL = "1";
    BROWSER = "wslview";
  };
in {
  environment.variables = env;
  environment.sessionVariables = env;
  home-manager.users.ayats = _: {
    home.sessionVariables = env;
  };
  environment.defaultPackages = [];
  environment.systemPackages = with pkgs; [
    wslu
  ];

  networking.hostName = hn;

  nix = {
    extraOptions = ''
      auto-optimise-store = true
    '';
  };

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "ayats";
    startMenuLaunchers = true;
    wslConf.network.hostname = hn;
    docker-desktop.enable = false;
  };

  # Not using /tmp on tmpfs
  boot.cleanTmpDir = true;

  systemd.tmpfiles.rules = [
    "d /home/ayats/.ssh 0700 ayats users - -"
  ];

  systemd.services.bind-ssh = {
    serviceConfig.Type = "forking";
    script = ''
      ${pkgs.bindfs}/bin/bindfs -p 700 /mnt/c/Users/ayats/.ssh /home/ayats/.ssh
    '';
    wantedBy = ["multi-user.target"];
    after = ["systemd-tmpfiles-setup.service"];
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };
}
