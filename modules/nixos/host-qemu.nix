{ config, pkgs, ... }:
# https://github.com/serokell/deploy-rs/blob/715e92a13018bc1745fb680b5860af0c5641026a/examples/system/common.nix
{
  imports = [
    "${pkgs}/nixos/modules/virtualisation/qemu-vm.nix"
  ];

  virtualisation.diskSize = 8192;

  services.avahi.nssmdns = true;
}
