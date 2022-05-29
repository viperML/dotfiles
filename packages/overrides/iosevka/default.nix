{
  iosevka,
  symlinkJoin,
  nerd-font-patcher,
}: let
  normal = iosevka.override {
    privateBuildPlan = builtins.readFile ./normal.toml;
    set = "normal";
  };
  quasi = iosevka.override {
    privateBuildPlan = builtins.readFile ./quasi.toml;
    set = "quasi";
  };
in
  symlinkJoin {
    name = "iosevka";
    paths = [normal quasi];
    buildInputs = [
      nerd-font-patcher
    ];
    postBuild = ''
      find $out/share/fonts/ -name "*.ttf" | xargs -n1 \
        nerd-font-patcher --mono --adjust-line-height
    '';
  }
