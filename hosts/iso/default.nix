{
  withSystem,
  nixpkgs,
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.iso = withSystem "x86_64-linux" ({pkgs, ...}:
    nixpkgs.lib.nixosSystem {
      inherit pkgs;
      system = "x86_64-linux";
      specialArgs = {
        inherit self inputs;
      };
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ./configuration.nix
        inputs.nix-common.nixosModules.channels-to-flakes
      ];
    });
}
