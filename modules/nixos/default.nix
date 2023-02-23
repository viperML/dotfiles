{
  lib,
  config,
  ...
}: {
  flake.nixosModules = {
    kde = ./kde.nix;
    common = ./common.nix;
    podman = ./podman.nix;
  };
}
