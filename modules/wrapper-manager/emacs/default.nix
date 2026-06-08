{ pkgs, ... }: {
  wrappers.emacs-viper = {
    basePackage = pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
    };
    extraPackages = [
      pkgs.emacs-all-the-icons-fonts
    ];
    postBuild = ''
      for f in $out/share/applications/*.desktop; do
        if [[ "$(basename "$f")" == "emacs.desktop" ]]; then
          continue
        fi

        rm -v "$f"
      done
    '';
  };
}
