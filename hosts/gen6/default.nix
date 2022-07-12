inputs @ {self, ...}: let
  system = "x86_64-linux";
  pkgs = inputs.nixpkgs.${system};
  pkgs' = self.legacyPackages.${system};
in
  self.lib.mkSystem {
    inherit system;
    pkgs = pkgs';
    lib = pkgs'.lib;
    nixosModules = with self.nixosModules; [
      ./configuration.nix
      desktop
      xdg-ninja

      virt
      docker
      # podman
      printing
      ld
      flatpak

      ./nspawn.nix

      ./fix-bluetooth.nix
      inputs.nix-gaming.nixosModules.pipewireLowLatency
      {
        services.pipewire.lowLatency.enable = true;
      }

      inputs.hyprland.nixosModules.default
    ];
    homeModules = with self.homeModules; [
      ./home.nix
      common
      gui
      git
      vscode
      wezterm
      nh
      flatpak
    ];
    specialisations = [
      (self.lib.joinSpecialisations (with self.specialisations; [
        kde
        nvidia
        ayats
        default
      ]))
      (self.lib.joinSpecialisations (with self.specialisations; [
        awesome
        nvidia
        ayats
      ]))
      (self.lib.joinSpecialisations (with self.specialisations; [
        hyprland
        nvidia
        ayats
      ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   hyprland
      #   nvidia-open
      #   ayats
      # ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   gnome
      #   nvidia
      #   soch
      # ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   {
      #     name = "pantheon";
      #     nixosModules = [
      #       (args: {
      #         services.xserver = {
      #           enable = true;
      #           desktopManager.pantheon = {
      #             enable = true;
      #           };
      #           displayManager.lightdm = {
      #             enable = true;
      #             greeters.pantheon.enable = true;
      #           };
      #         };
      #       })
      #     ];
      #   }
      #   nvidia
      #   soch
      # ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   {
      #     name = "cinnamon";
      #     nixosModules = [
      #       (args: {
      #         services.xserver = {
      #           enable = true;
      #           desktopManager.cinnamon = {
      #             enable = true;
      #           };
      #           displayManager.lightdm = {
      #             enable = true;
      #           };
      #         };
      #       })
      #     ];
      #   }
      #   nvidia
      #   soch
      # ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [sway nvidia]))
      # (self.lib.joinSpecialisations (with self.specialisations; [sway nouveau]))
    ];
  }
