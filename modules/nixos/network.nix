{ config, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };
}
