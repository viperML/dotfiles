{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    eval = inputs.wrapper-manager.lib {
      inherit pkgs;
      modules = [
        ./wezterm
        ./neofetch
        ./foot
        ./git
        ./nushell
        ./zellij
      ];
    };
  in {
    packages = eval.config.build.packages;
  };
}
