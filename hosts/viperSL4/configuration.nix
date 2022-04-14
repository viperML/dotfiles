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
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (with pkgs; [
      stdenv.cc.cc
      openssl
    ]);
    # NIX_LD = builtins.readFile "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    NIX_LD = "$(${pkgs.coreutils}/bin/cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)";
    # NIX_AUTO_RUN = "1";
  };
in {
  environment.variables = env;
  # environment.sessionVariables = env;
  home-manager.users.ayats = _: {
    home.sessionVariables = env;
  };
  environment.defaultPackages = [];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "ayats";
    startMenuLaunchers = true;
    wslConf.network.hostname = hn;
    docker.enable = false;
  };

  networking.hostName = hn;

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

    [[registry]]
    prefix="docker.io/library"
    location="quay.io/libpod"
  '';

  # programs.nix-ld.enable = true;
  # programs.command-not-found.enable = true;
}
