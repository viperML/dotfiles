/*
Flake compat layer

Usage:

  nix-build -A pkg <flake>/flake-compat.nix
  nix-build -A packages.x86_64-linux.pkg <flake>/flake-compat.nix
*/
{system ? builtins.currentSystem, ...}: let
  lock = builtins.fromJSON (builtins.readFile ../flake.lock);
  flake-compat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };
  flake =
    (import flake-compat {
      src = ./..;
    })
    .defaultNix;
in
  flake
  // flake.legacyPackages.${system}
  // flake.packages.${system}
