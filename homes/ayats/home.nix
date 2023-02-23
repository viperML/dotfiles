{
  packages,
  lib,
  config,
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
  };

  unsafeFlakePath = lib.mkDefault "${config.home.homeDirectory}/Documents/dotfiles";

  nixpkgs.config.allowUnfree = true;
}
