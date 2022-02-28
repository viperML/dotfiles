{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta-bin;
    profiles.main = {
      id = 0;
      userChrome = ''
        ${
          lib.concatMapStringsSep "\n" (value: "${builtins.readFile (inputs.firefox-csshacks.outPath + "/chrome/${value}")}") [
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
