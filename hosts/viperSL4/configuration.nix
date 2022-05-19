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
  prefix = "/run/current/system/sw/bin";
  env = {
    FLAKE = "/mnt/c/Users/ayats/Documents/dotfiles";
    GDK_DPI_SCALE = "1.5";
    QT_QPA_PLATFORM = "wayland";
    DONT_PROMPT_WSL_INSTALL = "1";
    BROWSER = "${prefix}/wslu";
    EDITOR = "${prefix}/nvim";
    SHELL = "${prefix}/fish";
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

  systemd.services = {
    bind-ssh-ayats = {
      serviceConfig.Type = "forking";
      script = ''
        ${pkgs.bindfs}/bin/bindfs -p 700 /mnt/c/Users/ayats/.ssh /home/ayats/.ssh
      '';
      wantedBy = ["multi-user.target"];
      after = ["systemd-tmpfiles-setup.service"];
    };
    bind-ssh-root = {
      serviceConfig.Type = "forking";
      script = "${pkgs.bindfs}/bin/bindfs --map=1000/0:@100/@0 -p 700 /mnt/c/Users/ayats/.ssh /root/.ssh";
      wantedBy = ["multi-user.target"];
      after = ["systemd-tmpfiles-setup.service"];
    };
  };

  programs.ssh = {
    startAgent = true;
    agentTimeout = "1h";
  };
}
