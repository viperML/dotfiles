with import <nixpkgs> { };
mkShell {
  packages = [
    # nodejs
    # ags
    # glib
    gobject-introspection
    ags
    astal.hyprland
    # astal.astal4
    # wrapGAppsHook
    gtk4
  ];

  shellHook = ''
    ln -vsfT ${astal.gjs} gjs
  '';
}
