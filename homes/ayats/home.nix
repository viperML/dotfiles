{
  lib,
  config,
  pkgs,
  ...
}: {
  home = {
    username = "ayats";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = lib.mkDefault "21.11";
    packages = with pkgs; [
      file
    ];
  };

  unsafeFlakePath = lib.mkDefault "${config.home.homeDirectory}/Documents/dotfiles";
}
