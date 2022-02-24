{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."river/init" = {
    source = ./init;
  };
}
