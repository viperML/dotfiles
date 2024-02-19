{ config, ... }:
let
  inherit (config.services.tailscale) interfaceName;
in
{
  services.tailscale.enable = true;

  networking.firewall = {
    # Strict reverse path filtering breaks Tailscale exit node use and some subnet routing setups.
    checkReversePath = "loose";
    interfaces.${interfaceName} = {
      allowedTCPPorts = [ 22 ];
      allowedTCPPortRanges = [
        {
          from = 8000;
          to = 8999;
        }
      ];
    };
  };
}
