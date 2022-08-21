{self, ...}: {
  flake = {
    homeModules = self.lib.exportModulesDir ./home-manager;
    nixosModules = builtins.removeAttrs (self.lib.exportModulesDir ./nixos) ["users"];
  };
}
