{
  pkgs,
  lib,
  ...
}: let
  cfg = pkgs.runCommandLocal "zellij-config" {} ''
    mkdir -p "$out/share/zellij"
    cp -v ${./config.kdl} "$out/share/zellij"
  '';
in {
  wrappers.zellij = {
    basePackage = pkgs.zellij;
    extraPackages = [
      cfg
    ];

    env.ZELLIJ_CONFIG_DIR.value = "${cfg}/share/zellij";
  };
}
