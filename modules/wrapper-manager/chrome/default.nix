{ pkgs, lib, ... }:
let
  commonFlags = [
    "--enable-features=${
      lib.concatStringsSep "," [
        "WebUIDarkMode"
        "TouchpadOverscrollHistoryNavigation"
        "WaylandTextInputV3"
      ]
    }"
    "--force-dark-mode"
  ];
in
{
  wrappers.google-chrome = {
    basePackage = pkgs.google-chrome;
    prependFlags = commonFlags;
  };

  wrappers.ungoogled-chromium = {
    basePackage = pkgs.ungoogled-chromium;
    prependFlags = commonFlags ++ [
      "--enable-features=${
        lib.concatStringsSep "," [
          "ClearDataOnExit"
        ]
      }"
    ];
  };

  wrappers.microsoft-edge = {
    basePackage = pkgs.microsoft-edge;
    prependFlags = commonFlags;
  };

  wrappers.brave = {
    basePackage = pkgs.brave;
    prependFlags = commonFlags;
  };
}
