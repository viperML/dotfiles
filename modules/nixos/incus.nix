{
  config,
  pkgs,
  ...
}:
let
  bridge = "incusbr0";
  dnsDomain = "incus";
  ipv4 = "10.0.100.1";
  ipv4Subnet = "24";
in
# Stuff from https://microk8s.io/docs/install-lxd
# https://raw.githubusercontent.com/ubuntu/microk8s/master/tests/lxc/microk8s.profile
{
  assertions = [
    {
      assertion = config.services.resolved.enable;
      description = "incus module uses resolved";
    }
    {
      assertion = !config.virtualisation.docker.enable;
      description = "incus conflicts with docker";
    }
  ];

  environment.systemPackages = [
    pkgs.sshfs
  ];

  boot.kernelModules = [
    "ip_vs"
    "ip_vs_rr"
    "ip_vs_wrr"
    "ip_vs_sh"
    "ip_tables"
    "ip6_tables"
    "netlink_diag"
    "nf_nat"
    "overlay"
    "br_netfilter"
    "iptable_nat"
    "iptable_filter"
  ];

  virtualisation.incus = {
    enable = true;
    package = pkgs.incus; # default is -lts
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
          config = {
            "security.nesting" = true;
            "security.privileged" = true;
            "raw.lxc" = ''
              lxc.apparmor.profile=unconfined
              lxc.mount.auto=proc:rw sys:rw cgroup:rw
              lxc.cgroup.devices.allow=a
              lxc.cap.drop=
            '';
          };
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
            nix_store = rec {
              type = "disk";
              path = "/nix/store";
              readonly = true;
              source = path;
            };
            nix_profiles = rec {
              type = "disk";
              path = "/nix/var/nix/profiles";
              source = path;
              readonly = true;
            };
            nixos_etc_static = rec {
              type = "disk";
              readonly = true;
              source = "/etc/static";
              path = source;
            };
            disable1 = {
              type = "disk";
              path = "/sys/module/nf_conntrack/parameters/hashsize";
              source = "/sys/module/nf_conntrack/parameters/hashsize";
            };
            disable2 = {
              type = "unix-char";
              path = "/dev/kmsg";
              source = "/dev/kmsg";
            };
            disable3 = {
              type = "disk";
              path = "/sys/fs/bpf";
              source = "/sys/fs/bpf";
            };
            disable4 = {
              type = "disk";
              path = "/proc/sys/net/netfilter/nf_conntrack_max";
              source = "/proc/sys/net/netfilter/nf_conntrack_max";
            };
            disable5 = {
              type = "unix-block";
              path = "/dev/dm-0";
              source = "/dev/dm-0";
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
