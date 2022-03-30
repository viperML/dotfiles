{
  config,
  pkgs,
  ...
}: let
  version = "2.0.57";
  efi-image = pkgs.fetchurl {
    url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.efi";
    sha256 = "00a94sl9d8f9ahh4fk68xxg18153w8s6phrilk9i5q5x26pfmddz";
  };
in {
  boot.loader.grub = {
    extraFiles."netboot.xyz.efi" = efi-image.outPath;
    extraEntries = ''
      ### Start netboot.xyz
      menuentry "netboot.xyz" {
        chainloader /netboot.xyz.efi
      }
      ### End netboot.xyz
    '';
  };
}
