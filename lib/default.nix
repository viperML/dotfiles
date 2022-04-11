lib: let
  modules = import ./modules.nix lib;
in {
  mkSystem = import ./mkSystem.nix lib;
  inherit (modules) exportModulesDir folderToList;
  kde = import ./kde.nix lib;
}
