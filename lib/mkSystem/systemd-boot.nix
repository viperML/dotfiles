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
  fixedBuilder = pkgs.writeShellScript "systemd-boot" ''
    echo ">>> Installing bootloader for $@"
    ${oldConfig.config.content.system.build.installBootLoader} "$@"
    generation=$(${pkgs.gnused}/bin/sed -n -r "s/default nixos-generation-([0-9]+).*/\1/p" ${loader-conf})
    if [[ -f ${config.boot.loader.efi.efiSysMountPoint}/loader/entries/nixos-generation-$generation-specialisation-${config.viper.defaultSpec}.conf ]]; then
      echo ">>> Changing to the selected default spec to ${config.viper.defaultSpec}"
      ${pkgs.gnused}/bin/sed -i -r "s/^(default nixos-generation-[0-9]+).*/\1-specialisation-${config.viper.defaultSpec}.conf/g" ${loader-conf}
    else
      echo ">>> WARNING: the default spec was not found"
    fi
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
