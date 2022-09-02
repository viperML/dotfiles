{
  self,
  inputs,
  withSystem,
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
          inherit self inputs;
          packages = self.lib.mkPackages (inputs
            // {
              inherit self;
            })
          system;
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
