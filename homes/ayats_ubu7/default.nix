{
  self,
  inputs,
  withSystem,
  _inputs,
  ...
}: {
  flake.homeConfigurations = {
    "ayats@ubu7" = withSystem "x86_64-linux" ({
      pkgs,
      system,
      ...
    }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit self;
          flakePath = "/home/ayats/Projects/dotfiles";
          inputs = _inputs;
          packages = self.lib.mkPackages _inputs system;
        };
        modules = with self.homeModules; [
          ./home.nix
          common
          xdg-ninja
          inputs.nix-common.homeModules.channels-to-flakes
        ];
      });
  };
}
