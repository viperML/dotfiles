{
  description = "Basic flake boilerplate";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      name = "my-shell";
      packages = [
        # keep
      ];
    };
  };
}
