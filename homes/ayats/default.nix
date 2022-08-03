inputs @ {
  self,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  packages = self.lib.mkPackages inputs system;
in
  home-manager.lib.homeManagerConfiguration {
    pkgs = packages.self;
    modules = with self.homeModules; [
      ./home.nix
      {
        _module.args = {
          inherit inputs self packages;
        };
      }
      common
      inputs.nix-common.homeModules.channels-to-flakes
      git

      inputs.home-manager-wsl.homeModules.default
    ];
  }
