{ modules
, inputs
}:
{
  modules =
    with modules;
    [
      ./configuration.nix
      nixosModules.desktop
      nixosModules.desktop-kde
      # desktop-gnome
      # desktop-sway
      nixosModules.gnome-keyring

      inputs.home-manager.nixosModules.home-manager
      nixosModules.home-manager
      nixosModules.mainUser-ayats

      nixosModules.adblock
      nixosModules.virt
      nixosModules.docker
      nixosModules.printing
      nixosModules.gaming
      nixosModules.vfio
    ]
    ++ [
      {
        home-manager.sharedModules =
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
            kde
            syncthing
            kitty
            firefox
          ];
      }
    ];
}
