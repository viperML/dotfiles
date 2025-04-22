{
  pkgs,
  ...
}:
{
  wrappers.zellij = {
    basePackage = pkgs.zellij;
    env.ZELLIJ_CONFIG_DIR.value = ./.;
  };
}
