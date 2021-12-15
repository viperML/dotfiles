{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./neofetch
    ./neovim
    ./fish
    ./starship
    ./lsd
  ];
in {
  inherit nixosModules;
}
