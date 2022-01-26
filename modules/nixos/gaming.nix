{ config, pkgs, ... }:

{
  programs = {
    steam.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # lutris
    (polymc.override {
      # Thanks https://github.com/linyinfeng/dotfiles/blob/0d86a257f34b51742f3012fb27b5ed8c173d9fe9/overlays/multimc.nix
      # for setting your API ID public
      msaClientID = "6998db6c-94fb-48bd-8d97-1e96707f1a5c";
    })
  ];
}
