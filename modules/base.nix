{ config, pkgs, inputs, ... }:
{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
      http-connections = 50
      max-jobs = 8
    '';

    # (from flake-utils-plus)
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
  };

  systemd.tmpfiles.rules = [
    "L /etc/nixpkgs/channels - - - - ${pkgs}"
  ];

  # home.file.".config/nix/nix.conf".source = ./nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ./config.nix;
}
