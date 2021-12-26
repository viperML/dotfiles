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

      hostDefaults.modules = with modules.nixosModules; [
        base
        inputs.home-manager.nixosModules.home-manager
        home-manager
      ] ++ [
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
          ];
        }
      ];

      hosts = {
        gen6.modules = with modules.nixosModules; [
          host-gen6
          kvm
          docker
        ];
        # vm.modules = [
        #   nixos-vm
        #   "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        # ];
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
