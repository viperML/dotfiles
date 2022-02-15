{
  config,
  pkgs,
  ...
}:
{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  programs.dconf.enable = true;
  environment.systemPackages =
    with pkgs; [
      virt-manager
    ];
  users.groups.libvirtd.members = config.users.groups.wheel.members;

  home-manager.sharedModules = [
    {
      home.file.".config/libvirt/libvirt.conf".text = "uri_default = \"qemu:///system\"";
    }
  ];
}
