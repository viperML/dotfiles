{
  config,
  pkgs,
  inputs,
  packages,
  ...
}: {
  virtualisation.libvirtd = {
    package = packages.nixpkgs-stable.libvirt;
    qemu.ovmf.package = packages.nixpkgs-stable.OVMFFull;
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
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
}
