{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.bat
  ];

  home.file.".config/bat/config".source = ./config;
  home.sessionVariables.MANPAGER = "sh -c 'col -bx | bat --paging=always -l man -p'";
}
