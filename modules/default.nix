{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./neofetch
    ./neovim
    ./fish
    ./starship
  ];
in {
  inherit nixosModules;
}
