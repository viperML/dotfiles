{ config, pkgs, ... }:
# https://github.com/serokell/deploy-rs/blob/715e92a13018bc1745fb680b5860af0c5641026a/examples/system/common.nix
{
  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXESP";
    fsType = "vfat";
  };
}
