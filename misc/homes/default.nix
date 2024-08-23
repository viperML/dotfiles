{lib, ...}: {
  imports = [./ayats];

  options.flake.homeConfigurations = lib.mkOption {
    type = with lib.types; lazyAttrsOf unspecified;
    default = {};
  };
}
