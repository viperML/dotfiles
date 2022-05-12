{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: let
  browser = "com.google.Chrome";
in {
  home.packages = with pkgs; [
    mpv
    qbittorrent
    ahoviewer
    krita
    obs-studio
    packages.self.obsidian
    ffmpeg-full

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

  # systemd.user.services.tailscale-systray = {
  #   Unit.Description = "Tailscale tray icon";
  #   Service.ExecStart = "${packages.self.tailscale-systray}/bin/tailscale-systray";
  #   Install.WantedBy = ["xdg-desktop-autostart.target"];
  # };
}
