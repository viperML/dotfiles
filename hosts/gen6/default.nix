{
  self,
  inputs,
}: let
  inherit (self) homeModules nixosModules;

  gen6-nixosModules = with nixosModules; [
    ./configuration.nix
    mainUser-ayats

    common
    channels-to-flakes
    desktop
    gnome-keyring
    inputs.home-manager.nixosModules.home-manager
    home-manager

    adblock
    virt
    docker
    printing
    gaming
    # vfio
    tailscale
  ];

  gen6-homeModules = with homeModules; [
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
  ];
in rec {
  system = "x86_64-linux";
  pkgs = self.legacyPackages.${system};
  specialArgs = {
    inherit inputs self;
  };
  modules =
    gen6-nixosModules
    ++ [
      {
        home-manager.sharedModules = gen6-homeModules;

        specialisation = {
          "KDE" = {
            inheritParentConfig = true;
            configuration = {
              imports = [
                nixosModules.desktop-kde
              ];
              home-manager.sharedModules = [
                homeModules.kde
              ];
            };
          };
          "Gnome" = {
            inheritParentConfig = true;
            configuration = {
              imports = [
                nixosModules.desktop-gnome
              ];
              home-manager.sharedModules = [
                homeModules.gnome
              ];
            };
          };
          "Sway" = {
            inheritParentConfig = true;
            configuration = {
              imports = [
                nixosModules.desktop-sway
              ];
              home-manager.sharedModules = [
                homeModules.sway
                homeModules.foot
              ];
            };
          };
        };
      }
    ];
}
