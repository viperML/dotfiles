{ config, pkgs, ... }:
{
  home = {
    packages = with pkgs; [
      libsForQt5.konsole
    ];

    file.".local/share/konsole/Dracula.colorscheme".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/konsole/Dracula.colorscheme";
  };
}
