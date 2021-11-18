# Simple shell which provides flakes support until it becomes a stable feature
{ pkgs ? import <nixpkgs> { } }:
pkgs.mkShell {
  name = "nixflakes";
  nativeBuildInputs = with pkgs; [
    nixUnstable
  ];

  shellHook = ''
    PATH=${pkgs.writeShellScriptBin "nix" ''
      ${pkgs.nixFlakes}/bin/nix --option experimental-features "nix-command flakes" "$@"
    ''}/bin:$PATH
  '';
}
