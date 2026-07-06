{
  config,
  lib,
  pkgs,
  ...
}:
let
  keyNames = [
    "ssh_host_rsa_key"
    "ssh_host_ed25519_key"
    "ssh_host_ecdsa_key"
  ];
  prefix = "/var/lib/tailscale/ssh";
in
{
  services.tailscale = {
    extraSetFlags = [
      "--advertise-exit-node"
    ];
    useRoutingFeatures = lib.mkForce "both";
  };

  networking.firewall.interfaces.${config.services.tailscale.interfaceName} = {
    allowedTCPPorts = [
      22
    ];

    allowedTCPPortRanges = [
      {
        from = 8000;
        to = 8999;
      }
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = false;
    extraConfig = lib.mkOrder 0 ''
      ${lib.concatMapStringsSep "\n" (k: "HostKey ${prefix}/${k}") keyNames}
    '';
  };

  systemd.services."sshd" = {
    after = [ "tailscaled.service" ];
  };

  systemd.paths = lib.mapAttrs' (name: value: lib.nameValuePair "tailscale-${name}" value) (
    lib.genAttrs keyNames (key: {
      wantedBy = [ "paths.target" ];
      pathConfig = {
        Unit = "sshd-restart-tailscaled.service";
        PathModified = "${prefix}/${key}";
      };
    })
  );

  systemd.services."sshd-restart-tailscaled" = {
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${config.systemd.package}/bin/systemctl try-restart sshd.service";
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/tailscale 0700 root root - -"
    "z /var/lib/tailscale 0700 root root - -"
  ];

  environment.systemPackages = [
    pkgs.waypipe
  ];

  assertions = [
    {
      assertion = config.services.tailscale.enable;
      message = "ssh-server.nix requires tailscale";
    }
  ];
}
