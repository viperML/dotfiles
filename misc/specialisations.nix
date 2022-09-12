inputs @ {self, ...}:
builtins.mapAttrs (name: v: v // {inherit name;}) {
  "default" = {
    default = true;
  };

  "sway" = {
    nixosModules = with self.nixosModules; [
      desktop-sway
    ];
    homeModules = with self.homeModules; [
      sway
    ];
  };

  "gnome" = {
    nixosModules = with self.nixosModules; [
      desktop-gnome
    ];
    homeModules = with self.homeModules; [
    ];
  };

  "kde" = {
    nixosModules = with self.nixosModules; [
      desktop-kde
    ];
    homeModules = with self.homeModules; [
      kde
      xsettingsd
    ];
  };

  "cinnamon" = {
    nixosModules = with self.nixosModules; [
      desktop-cinnamon
    ];
    homeModules = with self.homeModules; [
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
      xsettingsd
    ];
  };

  "hyprland" = {
    nixosModules = with self.nixosModules; [
      desktop-hyprland
      inputs.hyprland.nixosModules.default
    ];
    homeModules = with self.homeModules; [
      hyprland
      # eww
      waybar
    ];
  };

  "nvidia" = {
    nixosModules = [self.nixosModules.hardware-nvidia];
  };

  "nouveau" = {
    nixosModules = [self.nixosModules.hardware-nouveau];
  };

  "ayats" = {
    nixosModules = [self.nixosModules.user-ayats];
  };

  "soch" = {
    nixosModules = [self.nixosModules.user-soch];
  };
}
