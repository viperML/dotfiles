with import <nixpkgs> {};
  mkShellNoCC {nativeBuildInputs = [perl perlPackages.ConfigINI];}
