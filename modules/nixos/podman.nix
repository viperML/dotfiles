{
  pkgs,
  lib,
  ...
}:
let
  toml = pkgs.formats.toml { };
in
{
  virtualisation.podman = {
    enable = true;

    autoPrune = {
      enable = true;
      flags = [ "--all" ];
      dates = "weekly";
    };
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
            location = "mirror.gcr.io";
            insecure = false;
          }
        ];
      };
  };
}
