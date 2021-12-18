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
        self.overlay
        inputs.nur.overlay
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
            # This home-manager module links the flake inputs into ~/.nix-inputs
            # Set the nix path into the channels from the flake
            # And then deletes the channels created with nix-channel --add ...
            {
              home = {
                file = lib.mapAttrs' (name: value: { name = ".nix-inputs/${name}"; value = { source = value.outPath; }; }) inputs;
                sessionVariables = lib.mkForce {
                  NIX_PATH = "nixpkgs=$HOME/.nix-inputs/nixpkgs:$NIX_PATH";
                  FLAKE = "$HOME/.dotfiles";
                };
                activation.use-flake-channels = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                  $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-defexpr
                  $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-defexpr
                  $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.nix-channels
                  $DRY_RUN_CMD ln -s $VERBOSE_ARG /dev/null $HOME/.nix-channels
                '';
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

      outputsBuilder = channels: with channels.nixpkgs;{
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
