inputs @ {self, ...}: let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.${system};
  pkgs' = self.legacyPackages.${system};
in
  self.lib.mkSystem {
    pkgs = pkgs';
    lib = pkgs'lib;
    inherit system;
    specialArgs = {
      inherit self inputs;
      packages = self.lib.mkPackages inputs system;
    };
    nixosModules = with self.nixosModules; [
      ./configuration.nix
      common
      mainUser-ayats
      inputs.nix-common.nixosModules.channels-to-flakes
      inputs.home-manager.nixosModules.home-manager
      desktop
      keyring
      xdg-ninja

      virt
      docker
      # podman
      printing
      ld
      flatpak

      ./fix-bluetooth.nix
      inputs.nix-gaming.nixosModules.pipewireLowLatency
      {
        services.pipewire.lowLatency.enable = true;
      }
    ];
    homeModules = with self.homeModules; [
      ./home.nix
      common
      inputs.nix-common.homeModules.channels-to-flakes
      gui
      git
      vscode
      wezterm
      nh
      flatpak

      # inputs.nix-doom-emacs.hmModule
      # emacs-doom
    ];
    specialisations = [
      (self.lib.joinSpecialisations (with self.specialisations; [kde nvidia default]))
      # (self.lib.joinSpecialisations (with self.specialisations; [gnome nvidia]))
      # (self.lib.joinSpecialisations (with self.specialisations; [sway nvidia]))
      # (self.lib.joinSpecialisations (with self.specialisations; [sway nouveau]))
    ];
  }
