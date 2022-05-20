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
  prefix = "/run/current-system/sw/bin";
  env = {
    FLAKE = "/mnt/c/Users/ayats/Documents/dotfiles";
    GDK_DPI_SCALE = "1.5";
    QT_QPA_PLATFORM = "wayland";
    DONT_PROMPT_WSL_INSTALL = "1";
    BROWSER = "${prefix}/wslu";
    EDITOR = "${prefix}/nvim";
    SHELL = "${prefix}/fish";
    SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
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
    packages.self.vshell
    packages.self.neovim
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
    wslConf.network.hostname = hn;
    docker-desktop.enable = false;
    docker-native.enable = false;
    compatibility.interopPreserveArgvZero = true;
    startMenuLaunchers = false;
    tarball.includeConfig = false;
  };

  # Not using /tmp on tmpfs
  boot.cleanTmpDir = true;

  systemd.tmpfiles.rules = [
    "d /home/ayats/.ssh 0700 ayats users - -"
    "d /root/.ssh 0700 root root - -"
  ];

  programs.ssh = {
    startAgent = true;
    agentTimeout = "3h";
  };
}
