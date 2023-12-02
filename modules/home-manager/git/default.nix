{ pkgs, ...}: {
  home.packages = with pkgs; [
    git
    git-extras
    delta
  ];

  xdg.configFile."git/config".source = ./gitconfig;
}
