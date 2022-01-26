{ config, pkgs, ... }:

{
  networking.networkmanager = {
    enable = true;
    dns = "default";
  };

  # services.resolved = {
  #   enable = true;
  #   dnssec = "allow-downgrade";
  #   domains = [
  #     "1.1.1.1"
  #     "1.0.0.1"
  #     "2606:4700:4700::1111"
  #     "2606:4700:4700::1001"
  #   ];
  # };
}
