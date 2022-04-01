{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    mpv
    android-tools
  ];
}
