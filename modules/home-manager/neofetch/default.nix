{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.neofetch
  ];

  home.file.".config/neofetch/config.conf".source = ./config.sh;
}
