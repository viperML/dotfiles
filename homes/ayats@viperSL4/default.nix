inputs @ {
  self,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  username = "ayats";
  packages = self.lib.mkPackages inputs system;
in
  home-manager.lib.homeManagerConfiguration {
    inherit system username;
    homeDirectory = "/home/${username}";
    configuration = _: {};
    stateVersion = "21.11";
    extraSpecialArgs = {
      inherit inputs self packages;
    };
    pkgs = packages.self;
    extraModules = with self.homeModules; [
      ./home.nix
      common
      inputs.nixos-flakes.homeModules.channels-to-flakes
      git
    ];
  }
