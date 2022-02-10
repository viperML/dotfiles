{ modules, inputs }: {

  modules =
    with modules.nixosModules;
    [
      desktop
      desktop-kde
      # desktop-gnome
      # desktop-sway
      gnome-keyring
      mainUser-ayats
      inputs.home-manager.nixosModules.home-manager
      home-manager
      adblock
      virt
      docker
      printing
      gaming
      vfio

      ./configuration.nix
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
            # sway
            # inputs.doom-emacs.hmModule
            # emacs
            firefox
            # discord
            # xonsh
          ];
      }
    ];
}
