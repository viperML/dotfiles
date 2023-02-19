{
  lib,
  config,
  ...
}: {
  options = {
    flake.newxosModules = lib.mkOption {
      type = with lib.types; attrs;
    };
  };

  config = {
    flake.newxosModules = {
      kde = import ./kde.nix;
    };
  };

  imports = [
    ./common.nix
  ];
}
