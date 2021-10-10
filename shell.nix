{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixflakes";
  nativeBuildInputs = with pkgs; [
    git
    git-crypt
    nixUnstable
  ];

  shellHook = ''
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
