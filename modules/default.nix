{
  config,
  inputs,
  ...
}: {
  imports = [
    ./nixos
    ./home-manager
    ./new-nixos
  ];

  flake = {
    specialisations = let
      inherit (config.flake) homeModules nixosModules;
    in
      builtins.mapAttrs (name: value: value // {inherit name;}) {
        "default" = {
          default = true;
        };

        "sway" = {
          nixosModules = with nixosModules; [
            desktop-sway
          ];
          homeModules = with homeModules; [
            sway
            way-displays
            waybar
          ];
        };

        "river" = {
          nixosModules = with nixosModules; [
            desktop-river
          ];
          homeModules = with homeModules; [
            # sway
          ];
        };

        "gnome" = {
          nixosModules = with nixosModules; [
            desktop-gnome
          ];
          homeModules = with homeModules; [
            gnome
          ];
        };

        "wayland" = {
          nixosModules = with nixosModules; [
            (args: {
              viper.isWayland = true;
            })
          ];
          homeModules = with homeModules; [
          ];
        };

        "kde" = {
          nixosModules = with nixosModules; [
            desktop-kde
          ];
          homeModules = with homeModules; [
            kde
            # xsettingsd
          ];
        };

        "cinnamon" = {
          nixosModules = with nixosModules; [
            desktop-cinnamon
          ];
          homeModules = with homeModules; [
          ];
        };

        "awesome" = {
          nixosModules = with nixosModules; [
            desktop-awesome
          ];
          homeModules = with homeModules; [
            awesome
            picom
            rofi
            xsettingsd
          ];
        };

        "hyprland" = {
          nixosModules = with nixosModules; [
            desktop-hyprland
            inputs.hyprland.nixosModules.default
          ];
          homeModules = with homeModules; [
            hyprland
            # eww
            waybar
          ];
        };

        "nvidia" = {
          nixosModules = [nixosModules.hardware-nvidia];
        };

        "nouveau" = {
          nixosModules = [nixosModules.hardware-nouveau];
        };

        "ayats" = {
          nixosModules = [nixosModules.user-ayats];
        };

        "soch" = {
          nixosModules = [nixosModules.user-soch];
        };
      };
  };
}
