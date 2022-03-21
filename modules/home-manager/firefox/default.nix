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
    rev = "b4e09dcdfc634dbe1097820a3d2f10c8b08b870d";
    sha256 = "18x6198sy8siwnmby6yiij80hs3hqsn3188kf70fnbsj0shb8w4f";
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
