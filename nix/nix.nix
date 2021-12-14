{ config, pkgs, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      http-connections = 50
    '';
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  # home.file.".config/nix/nix.conf".source = ./nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ./config.nix;
}
