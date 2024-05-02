{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.browser;
in {
  options.browser = {
    package = lib.mkPackageOption pkgs "firefox" {};
    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = "firefox.desktop";
    };
  };

  config = {
    home.packages = [cfg.package];
    xdg.mimeApps = {
      enable = true;
      defaultApplications = lib.genAttrs [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/chrome"
        "text/html"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/xhtml+xml"
        "application/x-extension-xhtml"
        "application/x-extension-xht"
        "application/pdf"
      ] (_: cfg.desktopFile);
    };
  };
}
