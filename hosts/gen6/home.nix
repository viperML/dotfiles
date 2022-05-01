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
    streamlink
    ffmpeg-full

    packages.nix-matlab.matlab
    packages.nix-matlab.matlab-shell
    yuzu-ea
    (makeDesktopItem {
      name = "Spotify";
      desktopName = "Spotify";
      exec = "${browser} --app=\"https://open.spotify.com\"";
      icon = "spotify";
      type = "Application";
      categories = ["Network" "Audio"];
    })
  ];
}
