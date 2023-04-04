{
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    username = "ayats";
    homeDirectory = "/home/${config.home.username}";
    sessionVariables = {
      VAULT_ADDR = "http://kalypso.ayatsfer.gmail.com.beta.tailscale.net:8200";
      NOMAD_ADDR = "http://chandra.ayatsfer.gmail.com.beta.tailscale.net:4646";
    };
    stateVersion = lib.mkDefault "21.11";
    packages = with pkgs; [
      file
    ];
  };

  unsafeFlakePath = lib.mkDefault "${config.home.homeDirectory}/Documents/dotfiles";
}
