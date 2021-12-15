{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes ca-references
      http-connections = 50
    '';

    generateRegistryFromInputs = true; # (1) (from flake-utils-plus)
    registry = {
      from = {
        id = "nixpkgs";
        type = "indirect";
      };
      to = {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = inputs.nixpkgs.rev;
        type = "github";
      };
    };

    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  # home.file.".config/nix/nix.conf".source = ./nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ./config.nix;
}
