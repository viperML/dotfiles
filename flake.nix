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
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    sops-nix = {
      url = github:Mic92/sops-nix;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deploy-rs = {
      url = github:serokell/deploy-rs;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = github:nix-community/nixos-generators;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, utils, ... }:
    let
      modules = import ./modules { inherit utils; };
      # lib = nixpkgs.lib;
    in
    utils.lib.mkFlake {

      inherit self inputs;
      inherit (modules) nixosModules homeModules; # Place into flake outputs

      supportedSystems = [ "x86_64-linux" ];

      # Channels configurations
      channelsConfig.allowUnfree = true;
      overlay = import ./overlay;
      sharedOverlays = [
        self.overlay
        inputs.nur.overlay
        inputs.powercord-overlay.overlay
      ];

      lib =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          lib = nixpkgs.lib;
        in
        import ./lib { inherit pkgs lib; };

      # Hosts definitions

      hostDefaults.modules = with modules.nixosModules; [
        common
      ];

      hosts = {
        gen6.modules = with modules.nixosModules; [
          desktop
          inputs.home-manager.nixosModules.home-manager
          home-manager
          inputs.sops-nix.nixosModules.sops
          sops
          host-gen6

          kvm
          docker
          printing
          gaming
        ] ++ [
          # Split to not insert modules.nixosModules into the namespace
          # might get collision between modules.{nixosModules,homeModules}.base etc
          {
            home-manager.sharedModules = with modules.homeModules; [
              base
              flake-channels
              fonts
              gui
              git

              bat
              fish
              konsole
              lsd
              neofetch
              neovim
              # starship
              vscode
              discord
              kde
              syncthing
            ];
          }
        ];

        test_server.modules = with modules.nixosModules; [
          host-qemu
          docker
        ];
      };

      deploy.nodes.example = {
        sshOpts = [ "-p" "2221" ];
        hostname = "localhost";
        fastConnection = true;
        profiles = {
          system = {
            sshUser = "admin";
            path =
              inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.test_server;
            user = "root";
          };
        };
      };


      # homeConfigurations = {
      #   "ayats" = inputs.home-manager.lib.homeManagerConfiguration rec {
      #     system = "x86_64-linux";
      #     username = "ayats";
      #     homeDirectory = "/home/${username}";
      #     pkgs = self.pkgs.${system}.nixpkgs;
      #     configuration = {
      #       # see modules/base-home.nix for information about this
      #       home = {
      #         file = lib.mapAttrs' (name: value: { name = ".nix-inputs/${name}"; value = { source = value.outPath; }; }) inputs;
      #       };
      #     };
      #     extraModules = [
      #       base-home
      #       bat
      #       fish
      #       git
      #       home-fonts
      #       home-gui
      #       konsole
      #       lsd
      #       neofetch
      #       neovim
      #       vscode
      #     ];
      #   };
      # };


      # nix-on-droid = inputs.nix-on-droid.lib.aarch64-linux.nix-on-droid {
      #   config = {};
      #   extraModules = with mods.nixosModules; [
      #     nix-on-droid
      #   ];
      # };

      outputsBuilder = channels: with channels.nixpkgs; {
        # defaultPackage = self.homeConfigurations."ayats".activationPackage;
        devShell = import ./shell.nix { pkgs = channels.nixpkgs; };
        packages = {
          inherit
            lightly
            sierrabreezeenhanced
            multiload-ng
            any-nix-shell
            papirus-icon-theme
            netboot-xyz-images
            ;
        } // {
          vm-clean = inputs.nixos-generators.nixosGenerate {
            pkgs = channels.nixpkgs;
            format = "vm-bootloader";
            modules = with modules.nixosModules; [
              common
              host-qemu
              
            ];
          };
        };
      };

      templates = {
        poetry-flake = {
          path = ./templates/poetry-flake;
          description = "Flake for reproducible environments with poetry";
        };
        latex-flake = {
          path = ./templates/latex-flake;
          description = "Flake for reproducible latex documents";
        };
      };

      defaultTemplate = self.templates.poetry-flake;

    };

}
