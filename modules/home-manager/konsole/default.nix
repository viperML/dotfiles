{ config, pkgs, lib, ... }:
{
  home = {
    packages = with pkgs; [
      libsForQt5.konsole
    ];

    file.".local/share/konsole/Dracula.colorscheme".source = ./Dracula.colorscheme;
    file.".local/share/konsole/Main.profile".source = ./Main.profile;

    # activation.konsole = lib.hm.dag.entryAfter [ "writeBoundary" ] ''

    # '';
  };
}
