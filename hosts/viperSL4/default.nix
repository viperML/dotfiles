{
  self,
  inputs,
}: let
in
  /*
   inputs.nixpkgs.lib.nixosSystem {
     system = "x86_64-linux";
     pkgs = self.legacyPackages."x86_64-linux";
     modules =
       nixosModules
       ++ [
         #{
         #  home-manager.sharedModules = homeModules;
         #}
       ];
     specialArgs = {inherit self inputs;};
   }
   */
  self.lib.mkSpecialisedSystem rec {
    system = "x86_64-linux";
    pkgs = self.legacyPackages.${system};
    inherit (inputs.nixpkgs) lib;
    specialArgs = {inherit self inputs;};
    specialisations = {
      "base" = {
        nixosModules = with self.nixosModules; [
          ./configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
          # mainUser-ayats

          inputs.nixos-flakes.nixosModules.channels-to-flakes
          inputs.home-manager.nixosModules.home-manager
          common
        ];
        homeModules = with self.homeModules; [
          # ./home.nix
          common
          inputs.nixos-flakes.homeModules.channels-to-flakes
          #gui
          git
          bat
          fish
          lsd
          neofetch
          neovim
          starship
          zsh
        ];
      };
    };
  }
