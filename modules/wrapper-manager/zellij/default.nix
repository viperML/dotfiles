{
  pkgs,
  lib,
  ...
}:
let
  plugins = pkgs.callPackages ./_sources/generated.nix { };

  configDir = pkgs.runCommandLocal "zellij-config-dir" { } ''
    mkdir -p $out/etc
    cp -rL --no-preserve=mode ${./.} $out/etc/zellij
    shopt -s globstar
    substituteInPlace $out/**/*.kdl --replace-warn FOO BAR \
      ${
        plugins
        |> builtins.attrValues
        |> (map ({ pname, src, ... }: "--replace-warn 'nix:${pname}' 'file:${src}'"))
        |> lib.concatStringsSep " "
      }
    find $out/etc/zellij -type f ! -name '*.kdl' -delete
  '';

in
{
  wrappers.zellij = {
    basePackage = pkgs.zellij;
    # env.ZELLIJ_CONFIG_DIR.value = ./.;
    # env.ZELLIJ_CONFIG_DIR.value = "${configDir}/etc/zellij";
    flags = [
      "--config"
      "${configDir}/etc/zellij/config.kdl"
      # FIXME doesn't pick it by default
      "--layout"
      "${configDir}/etc/zellij/layouts/default.kdl"
    ];
    extraPackages = [ configDir ];
  };
}
