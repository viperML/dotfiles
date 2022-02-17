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
      "autostart/Mailspring.desktop".source = ./Mailspring.desktop;
      "autostart/Flameshot.desktop".source = ./Flameshot.desktop;
      "autostart/Caffeine.desktop".source = ./Caffeine.desktop;
    };
  };

  home.packages =
    with pkgs; [
      # Autostart
      flameshot
      mailspring
      caffeine-ng

      # Misc
    ];
}
