{
  pkgs,
  packages,
  ...
}: {
  services.tailscale.enable = true;
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [22];
  networking.firewall.interfaces.tailscale0.allowedTCPPortRanges = [
    {
      from = 8000;
      to = 8999;
    }
  ];

  systemd.user.services."tailscale-tray" = {
    wantedBy = ["tray.target"];
    after = ["tray.target"];
    serviceConfig.ExecStartPre = "${pkgs.coreutils-full}/bin/sleep 5";
    serviceConfig.ExecStart = "${packages.self.tailscale-systray}/bin/tailscale-systray";
    description = "Tailscale indicator for system tray";
  };
}
