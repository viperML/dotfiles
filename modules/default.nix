{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./neofetch
    ./neovim
  ];
in {
  inherit nixosModules;
}
