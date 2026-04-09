{ pkgs, ... }:
{
  imports = [
    ../noctalia
  ];

  file.xdg_config."hypr".source = builtins.toString ./.;
}
