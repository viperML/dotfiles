{ pkgs, ... }:
{
  wrappers.emacs = {
    basePackage = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
    };

    # Make CLI versions use -nw
    postBuild = ''
      for bin in $out/bin/emacs $out/bin/emacs-*; do
        echo ":: Wrapping $bin"
        wrapProgram "$bin" \
          --add-flags -nw
      done
    '';
  };
}
