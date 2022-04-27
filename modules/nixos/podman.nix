{
  lib,
  config,
  pkgs,
  ...
}: {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    enableNvidia = builtins.any (driver: driver == "nvidia") config.services.xserver.videoDrivers;
  };

  environment.etc."containers/registries.conf".text = lib.mkForce ''
    unqualified-search-registries = ['docker.io']

    [[registry]]
    prefix="docker.io"
    location="mirror.gcr.io"
  '';

  # Fix for docker compat (vscode)
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
}
