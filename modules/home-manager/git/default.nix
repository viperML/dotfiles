{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    git-extras
    difftastic
  ];

  xdg.configFile."git/config".source = ./gitconfig;
}
