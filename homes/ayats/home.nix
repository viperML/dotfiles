{
  packages,
  pkgs,
  lib,
  self,
  config,
  flakePath,
  ...
}: let
  username = "ayats";
  homeDirectory = "/home/${username}";
  env = {
    FLAKE = flakePath;
    EDITOR = "${homeDirectory}/.nix-profile/bin/nvim";
    SHELL = "${homeDirectory}/.nix-profile/bin/fish";
    VAULT_ADDR = "http://kalypso.ayatsfer.gmail.com.beta.tailscale.net:8200";
    NOMAD_ADDR = "http://sumati.ayatsfer.gmail.com.beta.tailscale.net:4646";
  };
in {
  home = {
    inherit username homeDirectory;
    sessionVariables = env;
    stateVersion = "21.11";

    packages = [
      packages.home-manager.default
    ];
  };

}
