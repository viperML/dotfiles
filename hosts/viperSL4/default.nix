inputs @ {self, ...}:
self.lib.mkSystem rec {
  system = "x86_64-linux";
  pkgs = self.legacyPackages.${system};
  inherit (inputs.nixpkgs) lib;
  specialArgs = {inherit self inputs;};
  specialisations."base" = {
    nixosModules = with self.nixosModules; [
      ./configuration.nix
      "${inputs.nixpkgs}/nixos/modules/profiles/minimal.nix"
      inputs.nixos-wsl.nixosModules.wsl

      "${self.outPath}/hosts/gen6/builder.nix"

      inputs.nixos-flakes.nixosModules.channels-to-flakes
      inputs.home-manager.nixosModules.home-manager
      common
      ld
      index
      podman
    ];
    homeModules = with self.homeModules; [
      ./home.nix
      common
      inputs.nixos-flakes.homeModules.channels-to-flakes
      git
    ];
  };
}
