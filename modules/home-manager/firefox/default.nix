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
    rev = "b9e140dbbd45e8a5358ef1ecb8700c842bfdc2df";
    sha256 = "1jjygi67sckcvsnlvllry912f3px8470y7yjxkwmnsq1j85xmz9n";
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
