lib: let
  modules = import ./modules.nix lib;
in {
  mkSpecialisedSystem = import ./mkSpecialisedSystem.nix lib;
  inherit (modules) exportModulesDir folderToList;
  kde = import ./kde.nix lib;
}
