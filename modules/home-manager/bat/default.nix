{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.bat
  ];

  home.file.".config/bat/config".source = ./config.sh;
}
