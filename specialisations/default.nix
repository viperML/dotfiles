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
      nwg-panel
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
}
