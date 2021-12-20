{
  description = "Fernando Ayats's personal flake";

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

    nur.url = github:nix-community/NUR;
  };

  outputs = inputs @ { self, nixpkgs, utils, ... }:
    let
      modules = import ./modules { inherit utils; };
      lib = nixpkgs.lib;
    in
    with modules.nixosModules;
    utils.lib.mkFlake {

      inherit self inputs;
      inherit (modules) nixosModules;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig.allowUnfree = true;
      sharedOverlays = [
        self.overlay
        inputs.nur.overlay
      ];

      ### NIXOS Hosts

      hostDefaults.modules = [
        nixos-base
        inputs.home-manager.nixosModules.home-manager
      ];

      hosts =  {
        gen6.modules = [
          nixos-gen6
          kvm
          docker
        ];
        vm.modules = [
          nixos-vm
        ];
      };


      homeConfigurations = {
        "ayats" = inputs.home-manager.lib.homeManagerConfiguration rec {
          system = "x86_64-linux";
          username = "ayats";
          homeDirectory = "/home/${username}";
          pkgs = self.pkgs.${system}.nixpkgs;
          configuration = {
            # This home-manager module links the flake inputs into ~/.nix-inputs
            # Set the nix path into the channels from the flake
            # And then deletes the channels created with nix-channel --add ...
            home = {
              file = lib.mapAttrs' (name: value: { name = ".nix-inputs/${name}"; value = { source = value.outPath; }; }) inputs;
            };
          };
          extraModules = [
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

      outputsBuilder = channels: with channels.nixpkgs;{
        defaultPackage = self.homeConfigurations."ayats".activationPackage;
        packages = {
          inherit
            lightly
            sierrabreezeenhanced
            multiload-ng
            ;
        };
      };

      templates = {
        poetry-nix = {
          path = ./templates/poetry-nix;
          description = "Flake for reproducible environments with poetry";
        };
      };

      defaultTemplate = self.templates.poetry-nix;

    };

}
