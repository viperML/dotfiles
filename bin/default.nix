{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      generate_matrix = pkgs.writers.writePython3Bin "generate_matrix" {
        libraries = [pkgs.python3.pkgs.requests];
      } (builtins.readFile ./generate_matrix.py);

      update = let
        base = pkgs.writers.writePython3Bin "update" {} (builtins.readFile ./update.py);
      in
        pkgs.symlinkJoin {
          paths = [base];
          inherit (base) name;
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram $out/bin/update \
              --prefix PATH ':' ${with pkgs;
              lib.makeBinPath [
                git
                nvfetcher
              ]} \
              --set NIX_PATH 'nixpkgs=${inputs.nixpkgs}'
          '';
        };

      cleanup = pkgs.writeShellScriptBin "cleanup" ''
        ${pkgs.fd}/bin/fd '\.nix' --exclude 'generated\.nix' --exec ${pkgs.deadnix}/bin/deadnix -e -l
        ${pkgs.treefmt}/bin/treefmt
      '';
    };
  };
}
