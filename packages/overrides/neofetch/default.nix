{
  symlinkJoin,
  neofetch,
  makeWrapper,
}: let
  neofetch-small = neofetch.override {x11Support = false;};
in
  symlinkJoin {
    inherit (neofetch-small) name pname version;
    paths = [neofetch-small];
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/neofetch \
        --add-flags "--config ${./config.sh} --ascii ${./logo}"
    '';
  }
