{
  config,
  pkgs,
  ...
}: {
  xdg = {
    enable = true;
    mime.enable = true;
    configFile = {
      # "autostart/Mailspring.desktop".source = ./Mailspring.desktop;
      "autostart/Flameshot.desktop".source = ./Flameshot.desktop;
    };
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
    roboto
    #
    # hoefler-text
    etBook
    source-sans
    redaction
  ];

  systemd.user = {
    services.update-flatpak = {
      Unit.Description = "Update all flatpaks";
      Service.Type = "oneshot";
      Service.ExecStart = let
        script = pkgs.writeShellScript "update-flatpak" ''
          ${pkgs.flatpak}/bin/flatpak update --noninteractive
          ${pkgs.flatpak}/bin/flatpak uninstall --unused --noninteractive
        '';
      in
        script.outPath;
    };
    timers.update-flatpak = {
      Unit.Description = "Update all flatpaks on a schedule";
      Unit.PartOf = ["update-flatpak.service"];
      Timer.OnCalendar = ["weekly"];
      Timer.Persistent = true;
      Install.WantedBy = ["timers.target"];
    };
  };
}
