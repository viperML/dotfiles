{
  config,
  pkgs,
  ...
}: {
  programs.chromium = {
    enable = true;
  };
}
