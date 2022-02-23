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

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      # Autostart
      flameshot
      mailspring
      # Misc
      syncthing
      ;
  };
}
