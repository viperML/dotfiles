{
  config,
  pkgs,
  ...
}: let
  XDG_DATA_DIRS = [
    "$XDG_DATA_HOME/flatpak/exports/share"
  ];
in {
  services.flatpak.enable = true;
  environment.sessionVariables = {inherit XDG_DATA_DIRS;};
  home-manager.users.ayats = _: {
    home.sessionVariables = {inherit XDG_DATA_DIRS;};
  };
}
