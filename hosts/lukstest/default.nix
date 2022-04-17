{
  self,
  inputs,
}:
inputs.nixpkgs-luks.lib.nixosSystem rec {
  system = "x86_64-linux";
  pkgs = self.legacyPackages.${system};
  inherit (inputs.nixpkgs) lib;
  specialArgs = {inherit self inputs;};
  modules = with self.nixosModules; [
    ./configuration.nix
  ];
}
