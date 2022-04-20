defaultSpec: {
  pkgs,
  config,
  modulesPath,
  lib,
  ...
}:
with lib; let
  loader-conf = "${config.boot.loader.efi.efiSysMountPoint}/loader/loader.conf";
  oldConfig = import "${modulesPath}/system/boot/loader/systemd-boot/systemd-boot.nix" {inherit pkgs config lib;};
  # TODO check if default spec exists
  fixedBuilder = pkgs.writeShellScript "systemd-boot" ''
    echo ">>> Installing bootloader for $@"
    ${oldConfig.config.content.system.build.installBootLoader} "$@"
    echo ">>>"
    ${pkgs.coreutils}/bin/cat ${loader-conf}
    echo ">>>"
    ${pkgs.gnused}/bin/sed -i -r "s/^(default nixos-generation-[0-9]+).*/\1-specialisation-${defaultSpec}.conf/g" ${loader-conf}
    echo "<<<"
    ${pkgs.coreutils}/bin/cat ${loader-conf}
    echo "<<<"
  '';
in
  if defaultSpec == "base"
  then {}
  else {
    system.build.installBootLoader = lib.mkForce fixedBuilder;
  }
