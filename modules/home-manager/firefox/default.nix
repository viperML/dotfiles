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
    rev = "db4d9f86c5f961894f85f9f9fe6a9202225a744c";
    sha256 = "1709r1rpg1vz3s2sbfihpfxna22khl6kldsfx1085inkhqfkhi8q";
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
