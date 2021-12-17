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
      lib = nixpkgs.lib;
    in
    with mods.nixosModules;
    utils.lib.mkFlake {

      inherit self inputs;
      inherit (mods) nixosModules;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        inputs.nur.overlay
        self.overlay
      ];

      ### NIXOS Hosts

      hostDefaults.modules = [
        ./nixos/configuration.nix
        base
        # cachix
        inputs.home-manager.nixosModules.home-manager
      ];

      hosts = {
        gen6.modules = [
          ./nixos/hosts/gen6.nix
          kvm
          docker
        ];
        vm.modules = [
          ./nixos/hosts/vm.nix
        ];
      };

      ### Home-manager exports

      homeConfigurations = {
        ayats = inputs.home-manager.lib.homeManagerConfiguration {
          system = "x86_64-linux";
          username = "ayats";
          homeDirectory = "/home/ayats";
          pkgs = self.pkgs.x86_64-linux.nixpkgs;
          configuration = { };
          # modules = [
          #   self.nixosModules.neofetch
          # ];
          extraModules = [
            {
              xdg.configFile = lib.mapAttrs' (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; }) inputs;
              systemd.user.sessionVariables = lib.mkForce {
                NIX_PATH = "nixpkgs=~/.config/nix/inputs/nixpkgs";
              };

            }
            base-home
            bat
            fish
            git
            home-fonts
            home-gui
            konsole
            lsd
            neofetch
            neovim
            starship
            vscode
          ];
        };
      };

      overlay = import ./overlays;

      # nix-on-droid = inputs.nix-on-droid.lib.aarch64-linux.nix-on-droid {
      #   config = {};
      #   extraModules = with mods.nixosModules; [
      #     nix-on-droid
      #   ];
      # };
      outputsBuilder = channels:  with channels.nixpkgs;{

        defaultPackage = self.homeConfigurations.ayats.activationPackage;

        packages = {
          inherit
            lightly
            sierrabreezeenhanced
            ;
        };

      };

    };

}
