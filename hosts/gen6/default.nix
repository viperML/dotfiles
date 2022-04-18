{
  self,
  inputs,
}:
self.lib.mkSystem rec {
  system = "x86_64-linux";
  pkgs = self.legacyPackages.${system};
  inherit (inputs.nixpkgs) lib;
  specialArgs = {inherit self inputs;};
  specialisations = {
    "base" = {
      nixosModules = with self.nixosModules; [
        ./configuration.nix
        common
        mainUser-ayats

        inputs.nixos-flakes.nixosModules.channels-to-flakes
        inputs.home-manager.nixosModules.home-manager
        desktop
        gnome-keyring
        dram

        virt
        docker
        printing
        gaming
        # vfio
        netboot
        ld
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
        # firefox
        starship
        wezterm
        nh
        xonsh
        # emacs
        # wine
        # inputs.nix-doom-emacs.hmModule
        # emacs-doom
      ];
    };
    inherit
      (self.specialisations)
      gnome
      kde
      # awesome
      
      # sway
      
      ;
  };
}
