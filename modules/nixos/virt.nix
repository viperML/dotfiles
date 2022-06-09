{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    qemu.swtpm.enable = true;
  };
  programs.dconf.enable = true;
  environment.systemPackages = [
    pkgs.virt-manager
  ];
  users.groups.libvirtd.members = config.users.groups.wheel.members;

  home-manager.sharedModules = [
    {
      home.file.".config/libvirt/libvirt.conf".text = "uri_default = \"qemu:///system\"";
    }
  ];

  networking.firewall.interfaces.virbr0 = rec {
    allowedTCPPortRanges = [
      {
        from = 8000;
        to = 8999;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
