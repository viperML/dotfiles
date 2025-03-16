{ pkgs, lib, ... }:
let
  commonFlags = [
    "--enable-features=${
      lib.concatStringsSep "," [
        "WebUIDarkMode"
        "TouchpadOverscrollHistoryNavigation"
      ]
    }"
    "--force-dark-mode"
  ];
in
{
  wrappers.google-chrome = {
    basePackage = pkgs.google-chrome;
    flags = commonFlags;
  };

  wrappers.ungoogled-chromium = {
    basePackage = pkgs.ungoogled-chromium;
    flags = commonFlags ++ [
      "--enable-features=${
        lib.concatStringsSep "," [
          "ClearDataOnExit"
        ]
      }"
    ];
  };

  wrappers.microsoft-edge = {
    basePackage = pkgs.microsoft-edge;
    flags = commonFlags;
  };

  wrappers.brave = {
    basePackage = pkgs.brave;
    flags = commonFlags;
  };
}
