{ config, pkgs, inputs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''${builtins.readFile ./nix.conf}'';

    # (from flake-utils-plus)
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;

    nixPath = [
      # "nixpkgs=/etc/nixpkgs"
    ];
  };

#
#   systemd.tmpfiles.rules = [
#     "L /etc/nixpkgs - - - - ${inputs.nixpkgs}"
#   ];

  # home.file.".config/nix/nix.conf".source = ./nix.conf;
  # home.file.".config/nixpkgs/config.nix".source = ./config.nix;
}
