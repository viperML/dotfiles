{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.homeConfigurations = {
    "ayats" = withSystem "x86_64-linux" ({
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
          ./ayats/home.nix
          common
          xdg-ninja
          git
          inputs.nix-common.homeModules.channels-to-flakes

          inputs.home-manager-wsl.homeModules.default
          {wsl.baseDistro = "void";}
        ];
      });
  };
}
