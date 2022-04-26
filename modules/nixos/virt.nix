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
    pkgs.vagrant
    pkgs.distrobox
  ];
  users.groups.libvirtd.members = config.users.groups.wheel.members;

  home-manager.sharedModules = [
    {
      home.file.".config/libvirt/libvirt.conf".text = "uri_default = \"qemu:///system\"";
    }
  ];

  # Punch a hole to serve files to a VM
  networking.firewall.interfaces.virbr0.allowedTCPPorts = [8000];
}
