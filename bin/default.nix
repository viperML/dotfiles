_: {
  perSystem = {pkgs, ...}: {
    packages.generate_matrix = pkgs.writers.writePython3Bin "generate_matrix" {
      libraries = [pkgs.python3.pkgs.requests];
    } (builtins.readFile ./generate_matrix.py);
  };
}
