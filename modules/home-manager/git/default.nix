{ pkgs, ...}: {
  home.packages = with pkgs; [
    git
    git-extras
    delta
  ];

  home.file.".gitconfig".source = ./gitconfig;
}
