{ config, pkgs, ... }:

{
  programs = {
    steam.enable = true;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      nativeOnly = true;
      # extraPkgs = pkgs: [
      #   libgdiplus
      # ];
    };
  };

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
