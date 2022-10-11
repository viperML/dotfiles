{
  self,
  inputs,
  withSystem,
  _inputs,
  ...
}: let
  mkHome = system: customArgs:
    withSystem system ({pkgs, ...}:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs =
          {
            inherit self;
            inputs = _inputs;
            packages = self.lib.mkPackages _inputs system;
          }
          // customArgs.extraSpecialArgs;
        modules = with self.homeModules;
          [
            ./home.nix
            common
            xdg-ninja
            inputs.nix-common.homeModules.channels-to-flakes
          ]
          ++ customArgs.modules;
      });
in {
  flake = {
    homeConfigurations = {
      "ayats" = mkHome "x86_64-linux" {
        extraSpecialArgs = {};
        modules = [];
      };
      "ayats@viperSL4" = mkHome "x86_64-linux" {
        extraSpecialArgs.flakePath = "/home/ayats/Projects/dotfiles";
        modules = [
          ./extra-viperSL4.nix
          inputs.home-manager-wsl.homeModules.default
          {wsl.baseDistro = "void";}
        ];
      };
      "ayats@DESKTOP-M5NKMGG" = mkHome "x86_64-linux" {
        extraSpecialArgs.flakePath = "/home/ayats/Projects/dotfiles";
        modules = [
          ./extra-viperSL4.nix
          inputs.home-manager-wsl.homeModules.default
          {wsl.baseDistro = "ubuntu";}
        ];
      };
      "ayats@chandra" = mkHome "aarch64-linux" {
        extraSpecialArgs.flakePath = "/home/ayats/dotfiles";
        modules = [
          ./extra-chandra.nix
        ];
      };
      "ayats@ubu7" = mkHome "x86_64-linux" {
        extraSpecialArgs.flakePath = "/home/ayats/Documents/dotfiles";
        modules = [
          ./extra-ubu7.nix
        ];
      };
    };

    packages."x86_64-linux".zzz_home_ayats_vipersl4 = self.homeConfigurations."ayats@viperSL4".config.home.activationPackage;
  };
}
