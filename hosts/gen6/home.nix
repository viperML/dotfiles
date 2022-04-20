{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: {
  home.packages = with pkgs; [
    mpv
    qbittorrent
    ahoviewer
    krita
    obs-studio
    packages.self.obsidian
    streamlink
    ffmpeg-full
  ];
}
