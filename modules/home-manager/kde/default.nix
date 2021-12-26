{ config, pkgs, inputs, lib, ... }:

{
  home.packages = with pkgs; [
    # latte-dock
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
  home.file.".config/latte/original/my-layout.layout.latte".source = ./my-layout.layout.latte;

  home.file.".config/autostart/start-latte.sh" = {
    executable = true;
    text = ''
    #!${pkgs.bash}/bin/bash
    if [[ -f $HOME/.config/latte/my-layout.layout.latte ]]; then
        ${pkgs.latte-dock}/bin/latte-dock --layout my-layout
    else
        ${pkgs.latte-dock}/bin/latte-dock --import-layout $HOME/.config/latte/original/my-layout.layout.latte
    fi
    '';
  };

}
