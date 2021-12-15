{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/v1.3.1;
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = github:t184256/nix-on-droid;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Overlays
    nur.url = github:nix-community/NUR;
  };

  outputs = inputs @ { self, nixpkgs, utils, ... }:
    let
      mods = import ./modules { inherit utils; };
    in
    utils.lib.mkFlake {

      inherit self inputs;
      inherit (mods) nixosModules;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        inputs.nur.overlay
      ];

      ### NIXOS Hosts

      hostDefaults.modules = [
        ./nixos/configuration.nix
        ./nix/nix.nix
        inputs.home-manager.nixosModules.home-manager
      ];

      hosts = {
        gen6.modules = [
          ./nixos/hosts/gen6.nix
        ];
        vm.modules = [
          ./nixos/hosts/vm.nix
        ];
      };

      ### Home-manager exports

      homeConfigurations = {
        "ayats@gen6" = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          username = "ayats";
          homeDirectory = "/home/ayats";
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          configuration = { };
          # modules = [
          #   self.nixosModules.neofetch
          # ];
          extraModules = with mods.nixosModules; [
            ./nix/home.nix
            neovim
            fish
            starship
            bat
            lsd
            # ./neofetch/neofetch.nix
            # ./xonsh/xonsh.nix

            # Gui
            ./nix/gui.nix
            ./nix/fonts.nix

            # Personal
            ./nix/git.nix
            neofetch
          ];
        };
      };

      nix-on-droid = inputs.nix-on-droid.lib.aarch64-linux.nix-on-droid {
        config = {};
        extraModules = with mods.nixosModules; [
          nix-on-droid
        ];
      };

    };

}
