{ config, pkgs, ... }:
{
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
  };

  # home.file.".config/nix/nix.conf".source = ./nix.conf;
  home.file.".config/nixpkgs/config.nix".source = ./config.nix;
}
