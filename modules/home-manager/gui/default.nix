{
  config,
  pkgs,
  ...
}:
{
  xdg = {
    enable = true;
    mime.enable = true;
    configFile = {
      # "autostart/Mailspring.desktop".source = ./Mailspring.desktop;
      "autostart/Flameshot.desktop".source = ./Flameshot.desktop;
    };
  };

  home.packages =
    with pkgs; [
      # Autostart
      flameshot
      mailspring

      # Misc
      tym
    ];
}
