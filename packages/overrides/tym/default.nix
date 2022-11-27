{
  sources,
  #
  tym,
  symlinkJoin,
  makeWrapper,
  vte,
}: let
  myVte = vte.overrideAttrs (old: {
    version = sources.vte.date;
    inherit (sources.vte) src;
    mesonFlags =
      old.mesonFlags
      ++ [
        "-Dsixel=true"
        "-Db_lto=false"
      ];
  });

  myTym =
    (tym.override {
      vte = myVte;
    })
    .overrideAttrs (old: {
      version = sources.tym.date;
      inherit (sources.tym) src;
      patches =
        (old.patches or [])
        ++ [
          ./sixel.patch
        ];
    });
in
  symlinkJoin {
    __nocachix = true;
    inherit (myTym) name pname version;
    paths = [myTym];
    nativeBuildInputs = [makeWrapper];
    postBuild = ''
      TYM_DIR="$out/share/tym"
      mkdir -pv "$TYM_DIR"

      cp -vf ${./config.lua} "$TYM_DIR/config.lua"

      wrapProgram $out/bin/tym \
        --add-flags "--use=$TYM_DIR/config.lua"
    '';
  }
