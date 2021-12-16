{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cachix
  ];

  nix = {
    extraOptions = "gc-keep-outputs = true";

    binaryCaches = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org/"
    ];
    binaryCachePublicKeys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
