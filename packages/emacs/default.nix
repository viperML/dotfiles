{
  symlinkJoin,
  emacsWithPackagesFromUsePackage,
  emacs-pgtk,
  makeWrapper,
}:
let
  pkg = emacsWithPackagesFromUsePackage {
    config = ./init.el;
    package = emacs-pgtk;
    alwaysEnsure = true;
  };
in
symlinkJoin {
  inherit (pkg)
    name
    meta
    passthru
    ;

  paths = [ pkg ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    for file in $out/bin/emacs $out/bin/emacs-*; do
      wrapProgram $file \
        --add-flags -nw
    done

    rm $out/share/applications
    mkdir -p $out/share/applications
    cp ${pkg}/share/applications/emacs.desktop $out/share/applications
    sed -i -E "s#Exec=emacs([[:space:]]*)#Exec=${pkg}/bin/emacs\1#g" $out/share/applications/emacs.desktop
  '';
}
