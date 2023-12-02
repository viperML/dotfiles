{ pkgs, ...}: {
  home.packages = with pkgs; [
    git
    git-extras
    delta
  ];

  xdg.file."git/config".source = ./gitconfig;
}
