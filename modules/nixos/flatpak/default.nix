{...}: {
  services.flatpak.enable = true;
  environment.sessionVariables = {
    "XDG_DATA_DIRS" = [
      "$XDG_DATA_HOME/flatpak/exports/share"
    ];
  };
}
