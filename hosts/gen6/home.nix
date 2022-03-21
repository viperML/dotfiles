{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    mpv
    qbittorrent
    ahoviewer
    krita
    obs-studio
    obsidian
    streamlink
  ];
}
