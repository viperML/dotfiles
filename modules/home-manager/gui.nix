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
    # Autostart
    flameshot
    mailspring
    # Misc
    syncthing

    # Fonts
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
      ];
    })
    corefonts
    noto-fonts
    # noto-fonts-cjk
    noto-fonts-extra
    noto-fonts-emoji
    # roboto
    # etBook
    source-sans
    # packages.self.redaction
  ];

  systemd.user = {
    services.update-flatpak = {
      Unit.Description = "Update all flatpaks";
      Service.Type = "oneshot";
      Service.ExecStart =
        (pkgs.writeShellScript "update-flatpak" ''
          ${pkgs.flatpak}/bin/flatpak update --noninteractive
          ${pkgs.flatpak}/bin/flatpak uninstall --unused --noninteractive
        '')
        .outPath;
    };
    timers.update-flatpak = {
      Unit.Description = "Update all flatpaks on a schedule";
      Unit.PartOf = ["update-flatpak.service"];
      Timer.OnCalendar = ["weekly"];
      Timer.Persistent = true;
      Install.WantedBy = ["timers.target"];
    };
  };

  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.dataHome}/fonts - - - - /etc/profiles/per-user/ayats/share/fonts"
    "L+ ${config.home.homeDirectory}/.icons - - - - /run/current-system/sw/share/icons"
  ];
}
