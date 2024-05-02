{pkgs, ...}: {
  home.packages = [pkgs.rofi];
  xdg.configFile."rofi".source = ./.;
}
