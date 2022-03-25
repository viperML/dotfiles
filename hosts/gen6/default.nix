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

        common
        inputs.nixos-flakes.nixosModules.channels-to-flakes
        desktop
        inputs.home-manager.nixosModules.home-manager
        gnome-keyring

        virt
        docker
        printing
        gaming
        # vfio
      ];
      homeModules = with self.homeModules; [
        ./home.nix
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
        xonsh
        # emacs
        # wine
        inputs.nix-doom-emacs.hmModule
        emacs-doom
      ];
    };
    inherit
      (self.specialisations)
      gnome
      kde
      awesome
      ;
  };
in
  self.lib.mkSpecialisedSystem {
    inherit system pkgs lib specialisations;
    specialArgs = {inherit self inputs;};
  }
