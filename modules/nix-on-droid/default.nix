{ config, pkgs, inputs, ... }:

{
  system.stateVersion = "21.11";

  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    config = { config, pkgs, ... }: {
      home.stateVersion = "21.11";
    };
  };
}
