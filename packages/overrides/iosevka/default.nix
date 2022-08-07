{
  pname,
  src,
  version,
  #
  stdenv,
  iosevka,
  symlinkJoin,
  nerd-font-patcher,
  nix-std,
  lib,
  writeTextDir,
}: let
  common = {
    no-cv-ss = true;
    serifs = "sans";

    ligations.inherits = "dlig";
    variants = {
      inherits = "ss14";
      design.zero = "slashed";
    };

    weights = {
      regular = rec {
        css = 400;
        menu = css;
        shape = css;
      };
      semibold = rec {
        css = 600;
        menu = css;
        shape = css;
      };
      bold = rec {
        css = 700;
        menu = css;
        shape = css;
      };
    };
  };

  plans = [
    {
      family = "iosevka-normal";
      spacing = "normal";
    }
    {
      family = "iosevka-quasi";
      spacing = "quasi-proportional";
    }
  ];

  plansMerged =
    map (p: {
      buildPlans.${p.family} = p // common;
    })
    plans;

  plansTOML = map (p:
    writeTextDir
    "share/fonts/truetype/${builtins.head (builtins.attrNames p.buildPlans)}.toml" (nix-std.lib.serde.toTOML p))
  plansMerged;

  fonts = map (p:
    (iosevka.overrideAttrs (prev: {
      inherit src version;
    }))
    .override {
      privateBuildPlan = nix-std.lib.serde.toTOML p;
      set = lib.removePrefix "iosevka-" (builtins.head (builtins.attrNames p.buildPlans));
    })
  plansMerged;
in
  # stdenv.mkDerivation {
  #   inherit (iosevka) pname version;
  #   srcs = [
  #     normal
  #     quasi
  #   ];
  #   nativeBuildInputs = [
  #     moreutils
  #     nerd-font-patcher
  #   ];
  #   dontUnpack = true;
  #   # buildPhase = ''
  #   #   mkdir -p $out/share/fonts
  #   #   find $srcs -name "*.ttf" | xargs -n1 -P$(nproc) \
  #   #     nerd-font-patcher --use-single-width-glyphs --no-progressbars -out $out/share/fonts
  #   # '';
  #   installPhase = ''
  #     set -x
  #     mkdir -p $out/share/fonts
  #     find $srcs -name "*.ttf" | xargs -n1 echo
  #   '';
  #   dontInstall = true;
  # }
  symlinkJoin {
    inherit (iosevka) name pname version;
    paths = fonts ++ plansTOML;
  }
