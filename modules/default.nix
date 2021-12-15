{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./neofetch
    ./neovim
    ./fish
  ];
in {
  inherit nixosModules;
}
