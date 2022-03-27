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
    rev = "5b67ff233aec27dc432b42d482767fb8471bdce7";
    sha256 = "19kfz3pw2wxb1h7x0xpidjjcwxszr56sq1m4fabifwyl66xgsg78";
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
