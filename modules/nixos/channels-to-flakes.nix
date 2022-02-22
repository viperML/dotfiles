{
  config,
  pkgs,
  inputs,
  self,
  lib,
  ...
}:
let
  # relative path to /etc to place our inputs such as /etc/${inputsPath}/nixpkgs
  inputsPath = "nix/inputs";
  selfRegistry = {
    to = {
      path = self.outPath;
      type = "path";
    };
    from = {
      id = "pkgs";
      type = "indirect";
    };
    exact = true;
  };
in {
  nix = {
    package =
      if lib.versionAtLeast pkgs.nix.version pkgs.nix_2_4.version
      then pkgs.nix
      else pkgs.nix_2_4;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # name "pkgs" for convenience, so tools will work with
    # nix shell pkgs#foo ; etc
    registry =
      {
        pkgs = selfRegistry;
      }
      // lib.mapAttrs' (
        name: value: {
          inherit name;
          value.flake = value;
        }
      )
      inputs;

    nixPath = [
      "nixpkgs=/etc/nix/inputs/nixpkgs"
    ];
  };

  environment.etc."nix/inputs/nixpkgs".source = self.outPath;
  environment.variables.NIXPKGS_CONFIG = lib.mkForce "";
}
