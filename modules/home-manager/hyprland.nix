{
  config,
  pkgs,
  packages,
  ...
}: {
  home.packages = [
    packages.hyprland.default
    pkgs.xwayland
    pkgs.foot
  ];
}
