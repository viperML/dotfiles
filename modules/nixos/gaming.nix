{ config, pkgs, ... }:

{
  programs = {
    steam.enable = true;
  };

  # nixpkgs.config.packageOverrides = pkgs: {
  #   steam = pkgs.steam.override {
  #     nativeOnly = true;
  #     # extraPkgs = pkgs: [
  #     #   libgdiplus
  #     # ];
  #   };
  # };

  environment.systemPackages = with pkgs; [
    lutris
    (multimc.override {
       msaClientID = "6998db6c-94fb-48bd-8d97-1e96707f1a5c";
    })
  ];
}
