{
  config,
  pkgs,
  inputs,
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
    ffmpeg-full
    firefox
  ];
}
