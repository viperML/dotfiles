{ config, ... }:
let
  bridge = "incusbr0";
  dnsDomain = "incus";
  ipv4 = "10.0.100.1";
  ipv4Subnet = "24";
in
{
  assertions = [
    {
      assertion = config.services.resolved.enable;
      description = "incus module uses resolved";
    }
  ];

  virtualisation.incus = {
    enable = true;
    preseed = {
      networks = [
        {
          name = bridge;
          type = "bridge";
          config = {
            "ipv4.address" = "${ipv4}/${ipv4Subnet}";
            "ipv4.nat" = "true";
            "dns.mode" = "managed";
            "dns.domain" = dnsDomain;
          };
        }
      ];
      profiles = [
        {
          name = "default";
          devices = {
            eth0 = {
              name = "eth0";
              network = bridge;
              type = "nic";
            };
            root = {
              path = "/";
              pool = "default";
              size = "35GiB";
              type = "disk";
            };
          };
        }
      ];
      storage_pools = [
        {
          config = {
            source = "/var/lib/incus/storage-pools/default";
          };
          driver = "dir";
          name = "default";
        }
      ];
    };
  };

  users.groups."incus-admin".members = config.users.groups."wheel".members;

  networking.firewall.trustedInterfaces = [ bridge ];

  # https://linuxcontainers.org/incus/docs/main/howto/network_bridge_resolved
  systemd.services."incus-dns-${bridge}" = rec {
    description = "Incus per-link DNS configuration for ${bridge}";
    bindsTo = [ "sys-subsystem-net-devices-${bridge}.device" ];
    after = bindsTo;
    wantedBy = bindsTo;
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      resolvectl dns '${bridge}' '${ipv4}'
      resolvectl domain '${bridge}' '~${dnsDomain}'
    '';
    postStop = ''
      resolvectl revert '${bridge}'
    '';
  };
}
