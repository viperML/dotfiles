{
  withSystem,
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.iso = withSystem "x86_64-linux" ({
    pkgs,
    system,
    ...
  }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit pkgs system;
      specialArgs = {
        inherit self inputs;
        packages = self.lib.mkPackages (inputs // {inherit self;}) system;
      };
      modules = [
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ./configuration.nix
        inputs.nix-common.nixosModules.channels-to-flakes
      ];
    });
}
