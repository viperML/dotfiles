{ utils }:
let
  nixosModules = utils.lib.exportModules [
    ./neofetch
  ];
in {
  inherit nixosModules;
}
