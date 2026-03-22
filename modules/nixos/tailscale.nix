{
  config,
  ...
}:
let
  inherit (config.services.tailscale) interfaceName;
in
{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
  };

  networking.firewall = {
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
