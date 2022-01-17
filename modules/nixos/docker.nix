{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    extraOptions = "--registry-mirror=https://mirror.gcr.io --add-runtime crun=${pkgs.crun}/bin/crun --default-runtime=crun";
  };

  users.groups.docker.members = config.users.groups.wheel.members;
  # users.users = with pkgs.lib;
  # mkMerge (
  #   forEach config.users (u:
  #     { "${u}".passwordFile = "/secrets/password/${u}"; }
  #   )
  # );

  systemd = {
    timers.docker-prune = {
      wantedBy = [ "timers.target" ];
      partOf = [ "docker-prune.service" ];
      timerConfig.OnCalendar = "weekly";
    };
    services.docker-prune = {
      serviceConfig.Type = "oneshot";
      script = ''
        ${pkgs.docker}/bin/docker system prune --all --force
      '';
      requires = [ "docker.service" ];
    };
  };
}
