{
  pkgs,
  stdenv,
  lib,
}:
stdenv.mkDerivation {
  name = "my-latex-document";
  meta =
    with lib; {
      description = "My latex document";
      license = lib.licenses.cc-by-nc-sa-40;
      platforms = platforms.linux;
    };

  src = ./.;
  buildPhase = "make PREFIX='./'";

  buildInputs =
    with pkgs; [
      (
        texlive.combine {
          inherit
            (texlive)
            scheme-medium
            # Additional packages
            enumitem
            ragged2e
            geometry
            fancyhdr
            xcolor
            xifthen
            etoolbox
            setspace
            fontspec
            unicode-math
            fontawesome
            sourcesanspro
            tcolorbox
            parskip
            hyperref
            ifmtarg
            environ
            trimspaces
            ;
        }
      )
      glibcLocales
    ];
}
