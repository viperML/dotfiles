{
  config,
  pkgs,
  packages,
  ...
}: {
  xdg = {
    enable = true;
    mime.enable = true;
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Fonts
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
    corefonts
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk

    roboto
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
