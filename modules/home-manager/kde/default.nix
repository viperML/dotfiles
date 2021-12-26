{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    latte-dock
    multiload-ng
  ];

  # Multiload-ng config
  home.file.".config/multiload-ng/my-systray.conf".source = ../../misc/multiload-ng/systray.conf;

  home.activation.multiload-ng = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD cp $VERBOSE_ARG ~/.config/multiload-ng/my-systray.conf ~/.config/multiload-ng/systray.conf
  '';

  home.file.".config/autostart/multiload-ng.desktop".text = ''
    [Desktop Action Preferences]
    Exec=${pkgs.multiload-ng}/bin/multiload-ng-systray
    Icon=preferences-system
    Name=Preferences

    [Desktop Entry]
    Actions=Preferences;
    Categories=Utility;System;Monitor;GTK;Applet;TrayIcon;
    Comment=Modern graphical system monitor
    Encoding=UTF-8
    Exec=multiload-ng-systray
    Icon=utilities-system-monitor
    Name=Multiload-ng (system tray)
    StartupNotify=false
    Terminal=false
    TryExec=multiload-ng-systray
    Type=Application
  '';


  # Latte dock config
  # home.file.".config/latte-source/my-layout.layout.latte".source = ./my-layout.layout.latte;
  home.file.".config/lattedockrc.new".source = ./lattedockrc;
  home.file.".config/latte/nix.layout.latte.new".source = ./nix.layout.latte;
  home.activation.latte-dock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD cp $VERBOSE_ARG ~/.config/lattedockrc.new ~/.config/lattedockrc
    $DRY_RUN_CMD cp $VERBOSE_ARG ~/.config/latte/nix.layout.latte.new ~/.config/latte/nix.layout.latte
  '';

  # home.file.".config/autostart/start-latte.sh.desktop".text = ''
  #   [Desktop Entry]
  #   Exec=/home/ayats/.config/autostart/start-latte.sh
  #   Icon=dialog-scripts
  #   Name=start-latte.sh
  #   Path=
  #   Type=Application
  #   X-KDE-AutostartScript=true
  # '';

  # home.file.".config/autostart/start-latte.sh" = {
  #   executable = true;
  #   text = ''
  #     #!${pkgs.bash}/bin/bash
  #     if [[ -f $HOME/.config/latte/my-layout.layout.latte ]]; then
  #         ${pkgs.latte-dock}/bin/latte-dock --replace --layout my-layout
  #     else
  #         ${pkgs.latte-dock}/bin/latte-dock --replace --import-layout $HOME/.config/latte-source/my-layout.layout.latte
  #     fi
  #   '';
  # };

}
