with import <nixpkgs> { };
mkShell {
  packages = [
    nodejs
    ags
    glib
    gobject-introspection
    gtk4
  ];

  shellHook = ''
    ln -vsfT ${astal.gjs} gjs
  '';
}
