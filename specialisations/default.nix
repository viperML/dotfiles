{
  self,
  inputs,
}: {
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
      gnome
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
}
