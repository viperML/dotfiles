{
  description = "Basic flake devShell boilerplate";

  inputs = {
    nixpkgs.url = "github:NixOS/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    genSystems = nixpkgs.lib.genAttrs [
      "x86_64-linux"
      "aarch-64-linux"
    ];
  in {
    devShells = genSystems (system: {
      default = with nixpkgs.legacyPackages.${system};
        mkShell {
          name = "my-shell";
          packages = [
            # keep
          ];
        };
    });
  };
}
