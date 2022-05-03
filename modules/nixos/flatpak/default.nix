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
  home-manager.sharedModules = [
    ./hm.nix
  ];
  environment.sessionVariables = {inherit XDG_DATA_DIRS;};
  home-manager.users.ayats = _: {
    home.sessionVariables = {inherit XDG_DATA_DIRS;};
  };
}
