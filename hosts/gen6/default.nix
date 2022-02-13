{ modules
, inputs
}:
let
  gen6-nixosModules =
    with modules.nixosModules; [
      ./configuration.nix
      desktop
      desktop-kde
      # desktop-gnome
      # desktop-sway
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
    ];
  gen6-homeModules =
    with modules.homeModules; [
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
      kde
      syncthing
      # kitty
      firefox
      starship
      # discord
      wezterm
    ];
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
