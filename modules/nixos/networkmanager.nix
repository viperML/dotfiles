{ config, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";
  };

  services.dnsmasq = {
    enable = true;
    servers = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
    extraConfig = ''
      cache-size=1000
      conf-file=${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf
      dnssec
    '';
  };
}
