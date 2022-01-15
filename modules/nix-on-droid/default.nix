{
  nix-on-droid = { config, pkgs, inputs, ... }: {
    system.stateVersion = "21.11";

    home-manager.config = { config, pkgs }: {
      home.stateVersion = "21.11";
    };
  };
}
