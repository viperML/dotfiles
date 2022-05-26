{
  config,
  pkgs,
  inputs,
  packages,
  lib,
  ...
}: let
  browser = "com.google.Chrome";
  mkTrayService = lib.recursiveUpdate {
    Install.WantedBy = ["tray.target"];
    Unit.After = ["tray.target"];
  };
in {
  home.packages = with pkgs; [
    packages.self.neofetch
    mpv
    qbittorrent
    ahoviewer
    krita
    obs-studio
    packages.self.obsidian
    ffmpeg-full
    packages.self.polychromatic

    hello
    #   packages.nix-matlab.matlab
    #   packages.nix-matlab.matlab-shell
    #   (makeDesktopItem {
    #     name = "Spotify";
    #     desktopName = "Spotify";
    #     exec = "${browser} --app=\"https://open.spotify.com\"";
    #     icon = "spotify";
    #     type = "Application";
    #     categories = ["Network" "Audio"];
    #   })
  ];

  systemd.user.services = {
    "tailscale-tray" = mkTrayService {
      Service.ExecStart = "${packages.self.tailscale-systray}/bin/tailscale-systray";
      Unit .Description = "Tailscale indicator for system tray";
    };
    # "solaar" = {
    #   Service.ExecStart = "${pkgs.solaar}/bin/solaar -w hide";
    #   Install.WantedBy = ["tray.target"];
    #   Unit = {
    #     Description = "LG mice controller";
    #     After = ["tray.target"];
    #   };
    # };
    "polychromatic" = {
      Service.ExecStart = "${packages.self.polychromatic}/bin/polychromatic-tray-applet";
      Unit.Description = "Razer controller";
    };
    "Mailspring" = mkTrayService {
      Service.ExecStart = "${config.xdg.dataHome}/flatpak/exports/bin/com.getmailspring.Mailspring --background";
      Unit.Description = "Mail client";
    };
  };
}
