{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.viper;
in {
  options.viper = {
    env = mkOption {
      default = {};
      type = with types; attrsOf (either str (listOf str));
    };

    users = mkOption {
      default = [];
      type = with types; listOf str;
    };
  };

  config = {
    environment.variables = cfg.env;
    environment.sessionVariables = cfg.env;
    home-manager.sharedModules = [
      {
        home.sessionVariables = cfg.env;
      }
    ];
  };
}
