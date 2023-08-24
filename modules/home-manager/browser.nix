{
  packages,
  lib,
  ...
}: {
  home.packages = [
    packages.self.google-chrome
  ];

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
    ] (_: "google-chrome.desktop");
  };
}
