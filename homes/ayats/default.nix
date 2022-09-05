{
  self,
  inputs,
  withSystem,
  _inputs,
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
          inherit self;
          inputs = _inputs;
          packages = self.lib.mkPackages _inputs system;
          flakePath = "/home/ayats/Projects/dotfiles";
        };
        modules = with self.homeModules; [
          ./home.nix
          common
          xdg-ninja
          inputs.nix-common.homeModules.channels-to-flakes
          inputs.home-manager-wsl.homeModules.default
          {wsl.baseDistro = "void";}
        ];
      });
  };

  flake.packages."x86_64-linux".zzz_home_ayats = self.homeConfigurations."ayats".config.home.activationPackage;
}
