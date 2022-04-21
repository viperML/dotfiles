{
  pkgs,
  config,
  modulesPath,
  lib,
  ...
}:
with lib; let
  cfg = config.viper;
  loader-conf = "${config.boot.loader.efi.efiSysMountPoint}/loader/loader.conf";
  oldConfig = import "${modulesPath}/system/boot/loader/systemd-boot/systemd-boot.nix" {inherit pkgs config lib;};
  # TODO check if default spec exists
  fixedBuilder = pkgs.writeShellScript "systemd-boot" ''
    echo ">>> Installing bootloader for $@"
    ${oldConfig.config.content.system.build.installBootLoader} "$@"
    echo ">>>"
    ${pkgs.coreutils}/bin/cat ${loader-conf}
    echo ">>>"
    ${pkgs.gnused}/bin/sed -i -r "s/^(default nixos-generation-[0-9]+).*/\1-specialisation-${config.viper.defaultSpec}.conf/g" ${loader-conf}
    echo "<<<"
    ${pkgs.coreutils}/bin/cat ${loader-conf}
    echo "<<<"
  '';
in {
  options.viper = {
    defaultSpec = mkOption {
      default = "base";
      type = types.str;
      description = ''
        Default specialisation to select in the bootloader
      '';
    };
  };

  config = {
    system.build.installBootLoader = mkIf (config.boot.loader.systemd-boot.enable && (cfg.defaultSpec != "base")) (lib.mkForce fixedBuilder);
  };
}
