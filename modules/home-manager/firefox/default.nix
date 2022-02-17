{
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-beta-bin;
    profiles.main = {
      id = 0;
      userChrome = ''
        ${builtins.readFile ./userChrome.css}

        ${
        builtins.readFile "${inputs.firefox-csshacks.outPath}/chrome/urlbar_centered_text.css"
      }
      '';
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # "privacy.resistFingerprinting" = true;
        # fix inital size of window
      };
    };
  };
}
