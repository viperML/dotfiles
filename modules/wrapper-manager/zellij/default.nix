{
  pkgs,
  ...
}:
{
  wrappers.zellij = {
    basePackage = pkgs.zellij;
    env.ZELLIJ_CONFIG_DIR.value = ./.;
    flags = [
      # FIXME doesn't pick it by default
      "--layout"
      ./layouts/default.kdl
    ];
  };
}
