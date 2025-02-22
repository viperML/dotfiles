{ pkgs, lib, ... }:
{
  wrappers.google-chrome = {
    basePackage = pkgs.google-chrome;
    flags = [
      "--enable-features=${
        lib.concatStringsSep "," [
          "WebUIDarkMode"
          "TouchpadOverscrollHistoryNavigation"
        ]
      }"
      "--force-dark-mode"
    ];
  };
}
