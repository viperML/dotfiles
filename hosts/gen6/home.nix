{
  config,
  pkgs,
  inputs,
  packages,
  lib,
  self,
  ...
}: let
  mkTrayService = lib.recursiveUpdate {
    Install.WantedBy = ["tray.target"];
    Unit.After = ["tray.target"];
  };
in {
  home.packages = with pkgs; [
    packages.self.neofetch
    mpv
    qbittorrent
    packages.self.obsidian
    ffmpeg-full
    filelight
    (self.libFor.${system}.addFlags pkgs.google-chrome-beta [
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
    (inputs.nix-gaming.overlays.default null pkgs).osu-lazer-bin
    krita
    packages.self.hcl
    vault
    packages.self.deploy-rs
  ];

  systemd.user.services = {
    "tailscale-tray" = mkTrayService {
      Service.ExecStart = "${packages.self.tailscale-systray}/bin/tailscale-systray";
      Unit.Description = "Tailscale indicator for system tray";
    };
    "mailspring" = mkTrayService {
      Service.ExecStart = "/usr/bin/env mailspring --background";
      Unit.Description = "Mail client";
    };
  };
}
