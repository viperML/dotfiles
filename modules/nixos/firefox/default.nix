{ pkgs, ... }:
let
  lock-true = {
    Value = true;
    Status = "locked";
  };

  userChrome =
    pkgs.runCommandLocal "user-chrome.css"
      {
        cssFiles = [
          ./hide_tabs_toolbar_v2.css
        ];
      }
      ''
        cat ''${cssFiles[@]} > $out
      '';

  maidModule =
    { config, ... }:
    {
      systemd.services.firefox-reconfigure = {
        enableStrictShellChecks = true;
        wantedBy = [ config.maid.systemdGraphicalTarget ];
        script = ''
          for profile in "$HOME"/.mozilla/firefox/*.default; do
            chromedir="$profile/chrome"
            mkdir -pv "$chromedir"
            ln -vsfT ${userChrome} "$chromedir/userChrome.css"
          done
        '';
      };
    };
in

{
  programs.firefox = {
    enable = true;
    policies = {
      Preferences = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = lock-true;
      };
    };
  };

  maid.sharedModules = [
    maidModule
  ];
}
