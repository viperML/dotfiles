{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    eval = inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        ./wezterm
        ./neofetch
      ];
    };
  in {
    packages = eval.config.build.packages;
  };
}
