{ lib
, config
, pkgs
, ...
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
    location="docker.io"

    [[registry.mirror]]
    location="mirror.gcr.io"
  '';

  # Fix for docker compat (vscode)
  systemd.user = {
    services = {
      "podman-prune" = {
        description = "Cleanup podman images";
        requires = [ "podman.socket" ];
        after = [ "podman.socket" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.podman} image prune --all --external --force";
        };
      };
    };
    timers."podman-prune" = {
      partOf = [ "podman-prune.service" ];
      timerConfig = {
        OnCalendar = "weekly";
        RandomizedDelaySec = "900";
        Persistent = "true";
      };
    };
  };
}
