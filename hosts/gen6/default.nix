inputs @ {self, ...}: let
  system = "x86_64-linux";
  pkgs' = self.legacyPackages.${system};
in
  self.lib.mkSystem {
    inherit system;
    pkgs = pkgs';
    lib = pkgs'.lib;


      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   hyprland
      #   nvidia
      #   ayats
      # ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   awesome
      #   nvidia
      #   ayats
      #   default
      # ]))
      # (self.lib.joinSpecialisations (with self.specialisations; [
      #   sway
      #   nvidia
      #   soch
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
