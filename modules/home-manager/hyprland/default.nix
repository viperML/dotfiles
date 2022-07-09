{pkgs, ...}: {
  xdg.configFile."hypr/hyprland.conf".source =
    (pkgs.substituteAll {
      src = ./hyprland.conf;
    })
    .outPath;

  home.packages = [
    pkgs.foot
    pkgs.wofi
    pkgs.firefox
  ];
}
