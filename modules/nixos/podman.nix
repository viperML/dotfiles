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
    pkgs.podman-compose
    pkgs.docker-credential-helpers
  ];

  environment.sessionVariables = {
    BUILDAH_FORMAT = "oci";
  };

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

  maid.sharedModules = [
    {
      systemd.tmpfiles.dynamicRules = [
        "d {{home}}/.docker 0700 {{user}} {{group}} - -"
        "d {{xdg_config_home}}/containers 0755 {{user}} {{group}} - -"
      ];

      systemd.services."containers-auth-reconfigure" = {
        wantedBy = [ "basic.target" ];
        after = [ "basic.target" ];
        path = [
          pkgs.coreutils
          pkgs.jq
          pkgs.moreutils
        ];
        restartIfChanged = true;
        serviceConfig = {
          RemainAfterExit = true;
          Type = "oneshot";
        };

        script =
          let
            knownRegistries = [
              "registry.gitlab.bsc.es"
              "regitry.gitlab.com"
              "docker.io"
              "ghcr.io"
            ];
          in
          ''
            set -x
            if [[ ! -f ~/.docker/config.json ]]; then
              echo "{}" > ~/.docker/config.json
            fi

            jq '.credsStore = "secretservice"' < ~/.docker/config.json | sponge ~/.docker/config.json
            ${
              knownRegistries
              |> builtins.map (reg: ''
                jq '.credHelpers["${reg}"] = "secretservice"' < ~/.docker/config.json | sponge ~/.docker/config.json
                jq '.auths["${reg}"] = {}' < ~/.docker/config.json | sponge ~/.docker/config.json
              '')
              |> builtins.concatStringsSep "\n"
            }
          '';
      };

    }
  ];
}
