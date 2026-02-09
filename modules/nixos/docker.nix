{
  config,
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
    autoPrune = {
      enable = true;
      flags = [ "--all" ];
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
  };

  users.groups.docker.members = config.users.groups.wheel.members;

  environment.sessionVariables = {
    DOCKER_BUILDKIT = "1";
  };
}
