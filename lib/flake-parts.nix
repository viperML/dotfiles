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

  config._module.args._inputs = inputs // {inherit self;};
}
