{ pkgs, ... }:
{
  wrappers.kitty = {
    basePackage = pkgs.kitty;
    env.KITTY_CONFIG_DIRECTORY.value = ./.;
  };
}
