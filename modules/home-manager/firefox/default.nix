{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  firefox-csshacks = pkgs.fetchFromGitHub {
    repo = "firefox-csshacks";
    owner = "MrOtherGuy";
    rev = "0bc77cc51583133ff8279a286f5eae939d13f3e0";
    sha256 = "1pkq4r6p3yllf0ww40v0jaxlqz5islljm2x9bvna03a8y17q392z";
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta-bin;
    profiles.main = {
      id = 0;
      userChrome = ''
        ${
          lib.concatMapStringsSep "\n" (value: "${builtins.readFile (firefox-csshacks.outPath + "/chrome/${value}")}") [
            "urlbar_centered_text.css"
            # "centered_tab_label.css"
            # "floating_findbar_on_top.css"
            "tab_effect_scale_onclick.css"
            # "window_control_force_linux_system_style.css"
            # "tabs_fill_available_width.css"
          ]
        }

        ${builtins.readFile ./userChrome.css}
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "app.update.interval" = 604800; # 1 week
      };
    };
  };
}
