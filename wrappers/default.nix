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
        ./chrome
        (import ./nvfetcher {inherit (inputs) nixpkgs;})
      ];
    };
  in {
    packages = eval.config.build.packages;
  };
}
