{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    eval = inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        ./wezterm
        ./neofetch
        ./foot
        ./git
      ];
    };
  in {
    packages = eval.config.build.packages;
  };
}
