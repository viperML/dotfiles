{
  pkgs,
  packages,
  lib,
  self,
  config,
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
    # ffmpeg-full
    # (self.libFor.${system}.addFlags pkgs.google-chrome (
    #   if config.viper.isWayland
    #   then [
    #     "--enable-features=UseOzonePlatform,VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
    #     "--ozone-platform=wayland"
    #   ]
    #   else [
    #     "--disable-features=UseChromeOSDirectVideoDecoder"
    #     "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
    #     "--ignore-gpu-blocklist"
    #     "--enable-gpu-rasterization"
    #     "--enable-accelerated-2d-canvas"
    #     "--enable-accelerated-video-decode"
    #     "--enable-zero-copy"
    #     "--ozone-platform-hint=x11"
    #     "--use-gl=desktop"
    #   ]
    # ))
    firefox
    vault
    packages.self.deploy-rs
    pkgs.vscode
    synology-drive-client
  ];

  systemd.user.services = {
    "tailscale-tray" = mkTrayService {
      Service.ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 5";
      Service.ExecStart = "${packages.self.tailscale-systray}/bin/tailscale-systray";
      Unit.Description = "Tailscale indicator for system tray";
    };
    # "mailspring" = mkTrayService {
    #   Service.ExecStart = "/usr/bin/env mailspring --background";
    #   Unit.Description = "Mail client";
    # };
  };
}
