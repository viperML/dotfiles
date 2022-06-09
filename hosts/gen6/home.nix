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
    krita
    obs-studio
    packages.self.obsidian
    ffmpeg-full

    microsoft-edge-beta
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
