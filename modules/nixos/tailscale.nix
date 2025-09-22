{
  config,
  pkgs,
  lib,
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

  environment.systemPackages = lib.mkMerge [
    (lib.mkIf config.services.desktopManager.plasma6.enable [
      pkgs.ktailctl
    ])
    (lib.mkIf config.services.desktopManager.gnome.enable [
      pkgs.gnomeExtensions.tailscale-qs
    ])
  ];
}
