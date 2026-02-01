let
  lock-true = {
    Value = true;
    Status = "locked";
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
    # TODO
    # https://mrotherguy.github.io/firefox-csshacks/?file=hide_tabs_toolbar_v2.css
  ];
}
