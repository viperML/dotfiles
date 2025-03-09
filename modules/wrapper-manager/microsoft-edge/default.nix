{ pkgs, lib, ... }:
{
  wrappers.microsoft-edge = {
    basePackage = pkgs.microsoft-edge;
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
