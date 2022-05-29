{
  iosevka,
  symlinkJoin,
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
  }
