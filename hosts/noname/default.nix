{
  self,
  inputs,
}: let
  system = "x86_64-linux";
  pkgs = self.legacyPackages.${system};
  inherit (inputs.nixpkgs) lib;

  specialisations = {
    "base" = {
      nixosModules = with self.nixosModules; [
        ./configuration.nix
        mainUser-ayats

        inputs.nixos-flakes.nixosModules.channels-to-flakes
        inputs.home-manager.nixosModules.home-manager
        desktop
        gnome-keyring

        # adblock
        # virt
        docker
        printing
        # gaming
        # vfio
        # tailscale
      ];
      homeModules = with self.homeModules; [
        common
        inputs.nixos-flakes.homeModules.channels-to-flakes
        gui
        git
        bat
        fish
        lsd
        neofetch
        neovim
        vscode
        firefox
        starship
        wezterm
        nh
        # xonsh
        # emacs
      ];
    };

    inherit
      (self.specialisations)
      gnome
      ;
  };
in
  self.lib.mkSpecialisedSystem {
    inherit system pkgs lib specialisations;
    specialArgs = {inherit self inputs;};
  }
