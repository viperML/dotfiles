{
  config,
  pkgs,
  packages,
  ...
}: {
  xdg = {
    enable = true;
    mime.enable = true;
    # configFile."fontconfig/conf.d/10-hm-fonts.conf"
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    corefonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk
    roboto

    packages.self.iosevka
  ];

  services.syncthing = {
    enable = true;
  };
  systemd.user.services."syncthingtray" = {
    Install.WantedBy = ["tray.target"];
    Service = {ExecStart = "${pkgs.syncthingtray}/bin/syncthingtray";};
    Unit = {
      Description = "syncthingtray";
      After = ["tray.target"];
    };
  };
}
