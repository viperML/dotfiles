{
  pkgs,
  lib,
  config,
  ...
}:
let
  toml = pkgs.formats.toml { };
in
{
  environment.systemPackages = [
    pkgs.skopeo
    pkgs.buildah
    pkgs.crane
  ];

  virtualisation.podman = {
    enable = true;

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
      dates = "weekly";
    };

    dockerSocket.enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  environment.etc = {
    "containers/registries.conf".source =
      lib.mkForce
      <| toml.generate "registries.conf" {
        unqualified-search-registries = [ "docker.io" ];
        registry = [
          {
            prefix = "docker.io";
            location = "docker.io";
            mirror = [
              { location = "mirror.gcr.io"; }
            ];
          }
        ];
      };
  };

  users.groups.podman.members = config.users.groups.wheel.members;
}
