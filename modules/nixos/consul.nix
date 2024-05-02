{config, ...}: {
  services.resolved.extraConfig = ''
    [Resolve]
    DNS=127.0.0.1:8600
    DNSSEC=false
    Domains=~consul
  '';

  services.consul = {
    enable = true;
    webUi = true;
    interface = {
      bind = config.services.tailscale.interfaceName;
      advertise = config.services.tailscale.interfaceName;
    };
    extraConfig = {
      # server = true;
      # bootstrap_expect = 2;
      client_addr = ''
        {{ GetInterfaceIP "${config.services.tailscale.interfaceName}" }} {{ GetAllInterfaces | include "flags" "loopback" | join "address" " " }}'';
    };
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = rec {
    allowedTCPPorts = [8500 8600 8501 8502 8503 8301 8302 8300];
    allowedUDPPorts = allowedTCPPorts;
    allowedTCPPortRanges = [
      {
        from = 21000;
        to = 21255;
      }
    ];
  };

  assertions = [
    {
      assertion = config.services.resolved.enable;
      message = "consul.nix module uses resolved";
    }
    {
      assertion = config.servives.tailscale.enable;
      message = "consul.nix module uses tailscale";
    }
  ];
}
