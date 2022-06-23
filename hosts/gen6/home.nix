{
  config,
  pkgs,
  inputs,
  packages,
  lib,
  self,
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
    # krita
    # obs-studio
    packages.self.obsidian
    ffmpeg-full
    filelight

    (packages.self.addFlags pkgs.microsoft-edge-beta [
      "--disable-features=UseChromeOSDirectVideoDecoder"
      "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
      "--ignore-gpu-blocklist"
      "--enable-gpu-rasterization"
      "--enable-accelerated-2d-canvas"
      "--enable-accelerated-video-decode"
      "--enable-zero-copy"
      "--ozone-platform-hint=x11"
      "--use-gl=desktop"
    ])
    mailspring
  ];

  systemd.user.services = {
    "tailscale-tray" = mkTrayService {
      Service.ExecStart = "${packages.self.tailscale-systray}/bin/tailscale-systray";
      Unit .Description = "Tailscale indicator for system tray";
    };
    "mailspring" = mkTrayService {
      Service.ExecStart = "/usr/bin/env mailspring --background";
      Unit.Description = "Mail client";
    };
  };
}
