{
  config,
  pkgs,
  ...
}:
{
  services.tailscale = {
    enable = true;
  };
}
