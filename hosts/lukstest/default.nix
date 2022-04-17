{
  self,
  inputs,
}:
inputs.nixpkgs-luks.lib.nixosSystem rec {
  system = "x86_64-linux";
  pkgs = self.legacyPackages.${system};
  inherit (inputs.nixpkgs) lib;
  specialArgs = {inherit self inputs;};
  modules = with self.nixosModules; let
    modulesPath = "${inputs.nixpkgs-luks}/nixos/modules";
  in [
    ./configuration.nix
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/minimal.nix")
    inputs.nixos-flakes.nixosModules.channels-to-flakes
  ];
}
