{ pkgs
, lib
, ...
}: {
  wrappers.zellij = {
    basePackage = pkgs.zellij;
    extraPackages = [ (pkgs.writeTextDir "share/zellij/config.kdl" (lib.fileContents ./config.kdl)) ];
    env.ZELLIJ_CONFIG_DIR.value = "$out/share/zellij";
  };
}
