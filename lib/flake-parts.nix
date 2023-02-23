{
  lib,
  inputs,
  self,
  ...
}:
with lib; {
  options.flake.homeConfigurations = mkOption {
    type = types.attrs;
    default = {};
  };
}
