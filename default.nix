/*
 Based on https://github.com/NixOS/nixpkgs/blob/7f9b6e2babf232412682c09e57ed666d8f84ac2d/pkgs/top-level/impure.nix
 
 Exports flake's legacyPackages as packages to be used by legacy nix tools (nix-shell, nix-build, etc)
 */
{
  localSystem ? {system = args.system or builtins.currentSystem;},
  system ? localSystem.system,
  crossSystem ? localSystem,
  ...
} @ args: let
  lock = builtins.fromJSON (builtins.readFile ./flake.lock);
  flake-compat = fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/${lock.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lock.nodes.flake-compat.locked.narHash;
  };
  flake = import flake-compat {
    src = ./.;
  };
in
  assert args ? localSystem -> !(args ? system);
  assert args ? system -> !(args ? localSystem);
    flake.defaultNix.legacyPackages.${system}
