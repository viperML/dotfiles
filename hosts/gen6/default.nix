{ modules
, inputs
}:
let
  de.desktop = "kde";

  de.nixosModules =
    if de.desktop == "kde"
    then [ modules.nixosModules.desktop-kde ]
    else if de.desktop == "sway"
    then [ modules.nixosModules.desktop-sway ]
    else throw "No DE chosen";

  de.homeModules =
    if de.desktop == "kde"
    then [ modules.homeModules.kde ]
    else if de.desktop == "sway"
    then [ modules.homeModules.sway ]
    else throw "No DE chosen";

  gen6-nixosModules =
    with modules.nixosModules;
    [
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
    ]
    ++ de.nixosModules;

  gen6-homeModules =
    with modules.homeModules;
    [
      common
      mainUser-ayats
      flake-channels
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
in
{
  modules =
    gen6-nixosModules
    ++ [
      {
        home-manager.sharedModules = gen6-homeModules;
      }
    ];
}
