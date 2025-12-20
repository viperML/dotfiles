{
  pkgs,
  lib,
  ...
}:
let
  plugins = pkgs.callPackages ./_sources/generated.nix { };

  configDir = pkgs.runCommandLocal "zellij-config-dir" { } ''
    cp -rL --no-preserve=mode ${./.} $out
    shopt -s globstar
    substituteInPlace $out/**/*.kdl --replace-warn FOO BAR \
      ${
        plugins
        |> builtins.attrValues
        |> (map ({ pname, src, ... }: "--replace-warn 'nix:${pname}' 'file:${src}'"))
        |> lib.concatStringsSep " "
      }
    find $out -type f ! -name '*.kdl' -delete
  '';
in
{
  wrappers.zellij = {
    basePackage = pkgs.zellij;
    env.ZELLIJ_CONFIG_DIR.value = configDir;
  };
}
