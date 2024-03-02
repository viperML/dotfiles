{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    git
    git-extras
    difftastic
  ];

  xdg.configFile."git/config".text = lib.fileContents ./gitconfig;
}
