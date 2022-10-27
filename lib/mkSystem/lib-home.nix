{
  config,
  lib,
  ...
}:
with lib; {
  options.viper = {
    isWayland = mkOption {
      default = false;
      type = types.bool;
    };
  };
}
