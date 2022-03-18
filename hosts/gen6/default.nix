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
        channels-to-flakes
        desktop
        gnome-keyring
        inputs.home-manager.nixosModules.home-manager
        home-manager

        # adblock
        virt
        docker
        printing
        gaming
        # vfio
        tailscale
      ];
      homeModules = with self.homeModules; [
        common
        channels-to-flakes
        fonts
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

    "sway" = {
      nixosModules = with self.nixosModules; [
        desktop-sway
      ];
      homeModules = with self.homeModules; [
        sway
        # waybar
        nwg-panel
      ];
    };

    # "kde" = {
    #   nixosModules = with self.nixosModules; [
    #     desktop-kde
    #   ];
    #   homeModules = with self.homeModules; [
    #     kde
    #   ];
    # };

    "gnome" = {
      nixosModules = with self.nixosModules; [
        desktop-gnome
      ];
      homeModules = with self.homeModules; [
        gnome
      ];
    };

    "awesome" = {
      nixosModules = with self.nixosModules; [
        desktop-awesome
      ];
      homeModules = with self.homeModules; [
        awesome
        picom
        rofi
      ];
    };
  };
in
  self.lib.mkSpecialisedSystem {
    inherit system pkgs lib specialisations;
    specialArgs = {inherit self inputs;};
  }
