{
  self,
  inputs,
}: let
  inherit (self) homeModules nixosModules;
  de.desktop = "gnome";
  de.nixosModules =
    if de.desktop == "kde"
    then [nixosModules.desktop-kde]
    else if de.desktop == "sway"
    then [nixosModules.desktop-sway]
    else if de.desktop == "gnome"
    then [nixosModules.desktop-gnome]
    else throw "No DE chosen";

  de.homeModules =
    if de.desktop == "kde"
    then [homeModules.kde]
    else if de.desktop == "sway"
    then
      [
        homeModules.sway
        homeModules.foot
      ]
    else if de.desktop == "gnome"
    then
      [
        homeModules.gnome
      ]
    else throw "No DE chosen";

  gen6-nixosModules = with nixosModules;
    [
      common
      channels-to-flakes
      ./configuration.nix
      desktop
      gnome-keyring

      inputs.home-manager.nixosModules.home-manager
      home-manager
      mainUser-ayats

      adblock
      virt
      docker
      printing
      gaming
      vfio
      tailscale
    ]
    ++ de.nixosModules;

  gen6-homeModules = with homeModules;
    [
      common
      channels-to-flakes
      mainUser-ayats
      fonts
      gui
      git

      bat
      fish
      lsd
      neofetch
      neovim
      vscode
      syncthing
      firefox
      starship
      wezterm
    ]
    ++ de.homeModules;
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
      }
    ];
}
