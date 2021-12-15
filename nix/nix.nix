{ config, pkgs, inputs, ... }:
{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
      http-connections = 50
    '';

    # (from flake-utils-plus)
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  # home.file.".config/nix/nix.conf".source = ./nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ./config.nix;
}
