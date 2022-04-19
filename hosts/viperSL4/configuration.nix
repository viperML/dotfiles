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

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "ayats";
    startMenuLaunchers = true;
    wslConf.network.hostname = hn;
    docker.enable = false;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  systemd.user = {
    services.podman.serviceConfig.ExecStart = [
      ""
      "${pkgs.podman}/bin/podman $LOGGING system service"
    ];
    sockets.podman = {
      enable = true;
      wantedBy = ["sockets.target"];
    };
  };

  environment.etc."containers/registries.conf".text = lib.mkForce ''
    unqualified-search-registries = ['docker.io']

    [[registry]]
    prefix="docker.io"
    location="mirror.gcr.io"
  '';

  # Not using /tmp on tmpfs
  boot.cleanTmpDir = true;
}
