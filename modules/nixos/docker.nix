{
  config,
  pkgs,
  lib,
  ...
}:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    # extraOptions =
    extraOptions = lib.concatStringsSep " " [
      "--registry-mirror=https://mirror.gcr.io"
      # "--add-runtime crun=${pkgs.crun}/bin/crun"
      # "--default-runtime=crun"
      # "--iptables=false"
      # "--ip6tables=false"
    ];
    enableNvidia = lib.mkIf (builtins.any (v: v == "nvidia") config.services.xserver.videoDrivers) true;
  };

  virtualisation.oci-containers = {
    backend = "docker";
  };

  users.groups.docker.members = config.users.groups.wheel.members;

  systemd = {
    timers.docker-prune = {
      wantedBy = [ "timers.target" ];
      partOf = [ "docker-prune.service" ];
      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
      };
    };
    services.docker-prune = {
      serviceConfig.Type = "oneshot";
      script = ''
        ${config.virtualisation.docker.package}/bin/docker system prune --all --force
      '';
      requires = [ "docker.service" ];
    };
  };
}
