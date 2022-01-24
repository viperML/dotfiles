{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    extraOptions = "--registry-mirror=https://mirror.gcr.io --add-runtime crun=${pkgs.crun}/bin/crun --default-runtime=crun";
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      # test = {
      #   ports = [
      #     "8080:80"
      #   ];
      #   image = "nginx:latest";
      # };
    };
  };

  users.groups.docker.members = config.users.groups.wheel.members;

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
