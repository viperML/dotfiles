{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    gitFull
    git-extras
    difftastic
  ];

  xdg.configFile."git/config".text = lib.fileContents ./gitconfig;
}
