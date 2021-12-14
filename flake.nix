{
  description = "Fernando Ayats's system configuraion";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Overlays
    nur.url = "github:nix-community/NUR";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, nur, ... }:
    let

      # # Enable custom overlays here
      # pkgs = import nixpkgs {
      #   inherit system;
      #   config = {
      #     # allowBroken = true;
      #     allowUnfree = true;
      #   };
      #   overlays = [
      #     nur.overlay
      #   ];
      # };
      pkgs = nixpkgs;

      # Change your platform here
      system = "x86_64-linux";

      # Change your system info here
      username = "ayats";
      hostname = "gen6";

    in {
      # defaultPackage."${system}" = self.homeConfigurations."${username}@${hostname}".activationPackage;

      # homeConfigurations = {
      #   "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration rec {
      #     # Home Manager shenaningans to pass the username down
      #     inherit system pkgs username;
      #     configuration = {
      #       imports = [
      #         # Basic cli
      #         ./nix/home.nix
      #         ./neovim/nvim.nix
      #         ./fish/fish.nix
      #         ./bat/bat.nix
      #         ./lsd/lsd.nix
      #         ./neofetch/neofetch.nix
      #         # ./xonsh/xonsh.nix

      #         # Gui
      #         ./nix/gui.nix

      #         # Personal
      #         ./nix/git.nix
      #       ];
      #       home.username = username;
      #       home.homeDirectory = "/home/" + username;
      #       programs.home-manager = {
      #         enable = true;
      #         path = "…";
      #       };
      #     };
      #     homeDirectory = "/home/" + username;
      #   };
      # };

      nixosConfigurations = {
        gen6 = pkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            ./nixos/hosts/gen6.nix
          ];
          specialArgs = { inherit inputs; };
        };

        # vm = inputs.nixpkgs.lib.nixosSystem {
        #   system = "x86_64-linux";
        #   modules = [
        #     ./configuration.nix
        #     ./hosts/vm.nix
        #     /* ignore */ ignoreme # ignore this; don't include it; it is a small helper for this example
        #   ];
        #   specialArgs = { inherit inputs; };
        # };
      };

    };
}
