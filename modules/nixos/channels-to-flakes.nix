{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  # relative path to /etc to place our inputs such as /etc/${inputsPath}/nixpkgs
  inputsPath = "nix/inputs";
in {
  nix = {
    package =
      if lib.versionAtLeast pkgs.nix.version pkgs.nix_2_4.version
      then pkgs.nix
      else pkgs.nix_2_4;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    registry =
      lib.mapAttrs' (
        name: value: {
          inherit name;
          value.flake = value;
        }
      )
      inputs;

    nixPath = lib.mapAttrsToList (name: value: "${name}=/etc/${inputsPath}/${name}") inputs;
  };

  environment.etc =
    lib.mapAttrs' (
      name: value: {
        name = "${inputsPath}/${name}";
        value = {
          source = "${value.outPath}";
        };
      }
    )
    inputs;
}
