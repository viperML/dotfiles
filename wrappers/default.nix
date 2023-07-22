{inputs, ...}: {
  perSystem = {
    pkgs,
    config,
    ...
  }: let
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
        (import ./fish {inherit (config) packages;})
        ./bat
        ./helix
      ];
    };
  in {
    packages = eval.config.build.packages;
  };
}
