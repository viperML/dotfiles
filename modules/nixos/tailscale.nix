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
}
