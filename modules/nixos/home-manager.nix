{ config, pkgs, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.mainUser = { config, pkgs, ... }: {

      # TODO placeholder needed here
      home.packages = with pkgs; [
        hello
      ];

    };
  };
}
